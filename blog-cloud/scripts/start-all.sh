#!/bin/bash
# 博客微服务一键启动脚本
# 启动顺序: Eureka -> blog-home / blog-admin -> blog-gateway -> 前端

set -e

BASE_DIR="/opt/web"
HOST_IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
HOST_IP="${HOST_IP:-127.0.0.1}"

EUREKA_DIR="${BASE_DIR}/eureka"
HOME_DIR="${BASE_DIR}/blog-home"
ADMIN_DIR="${BASE_DIR}/blog-admin"
GATEWAY_DIR="${BASE_DIR}/blog-gateway"
UI_DIR="${BASE_DIR}/blog-ui/blog-ui"

EUREKA_JAR="eureka-0.0.1-SNAPSHOT.jar"
HOME_JAR="blog-home-1.0.0.jar"
ADMIN_JAR="blog-admin-1.0.0.jar"
GATEWAY_JAR="blog-gateway-1.0.0.jar"

log() {
    echo "[$(date '+%H:%M:%S')] $*"
}

check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "错误: 未找到命令 $1，请先安装后再运行本脚本。"
        exit 1
    fi
}

is_running() {
    pgrep -f "$1" > /dev/null 2>&1
}

wait_for_port() {
    local port="$1"
    local name="$2"
    local retries=30

    for ((i = 1; i <= retries; i++)); do
        if ss -tln 2>/dev/null | grep -q ":${port} " || netstat -tln 2>/dev/null | grep -q ":${port} "; then
            log "${name} 端口 ${port} 已就绪"
            return 0
        fi
        sleep 1
    done

    echo "错误: ${name} 在 ${retries} 秒内未启动成功，请查看对应目录下的 nohup.out"
    exit 1
}

start_java_service() {
    local dir="$1"
    local jar="$2"
    local name="$3"

    if is_running "${jar}"; then
        log "${name} 已在运行，跳过启动"
        return 0
    fi

    if [ ! -f "${dir}/${jar}" ]; then
        echo "错误: 找不到 ${dir}/${jar}"
        exit 1
    fi

    log "正在启动 ${name} ..."
    (
        cd "${dir}"
        nohup java -jar "${jar}" > nohup.out 2>&1 &
    )
}

start_frontend() {
    if is_running "vue-cli-service.js serve"; then
        log "前端已在运行，跳过启动"
        return 0
    fi

    if [ ! -d "${UI_DIR}/node_modules" ]; then
        echo "错误: 未找到前端依赖，请先执行:"
        echo "cd ${UI_DIR} && npm install"
        exit 1
    fi

    log "正在启动前端 ..."
    (
        cd "${UI_DIR}"
        nohup npm run serve > nohup.out 2>&1 &
    )
}

log "开始启动博客系统 ..."

check_command java
check_command node
check_command npm
check_command curl

# 1. Eureka
start_java_service "${EUREKA_DIR}" "${EUREKA_JAR}" "Eureka"
wait_for_port 8761 "Eureka"
sleep 3

# 2. 微服务
start_java_service "${HOME_DIR}" "${HOME_JAR}" "blog-home"
start_java_service "${ADMIN_DIR}" "${ADMIN_JAR}" "blog-admin"
wait_for_port 9001 "blog-home"
wait_for_port 9002 "blog-admin"
sleep 5

# 3. 网关
start_java_service "${GATEWAY_DIR}" "${GATEWAY_JAR}" "blog-gateway"
wait_for_port 9000 "blog-gateway"
sleep 5

# 4. 前端
start_frontend
wait_for_port 8082 "前端"

log "进行接口健康检查 ..."
HOME_CODE="$(curl -s -o /dev/null -w '%{http_code}' http://localhost:9000/home/api/posts || true)"
ADMIN_CODE="$(curl -s -o /dev/null -w '%{http_code}' http://localhost:9000/admin/posts || true)"

echo
echo "========================================"
echo " 博客系统启动完成"
echo "========================================"
echo "Eureka 控制台 : http://${HOST_IP}:8761"
echo "博客首页      : http://${HOST_IP}:8082/"
echo "后台管理      : http://${HOST_IP}:8082/admin"
echo "API 网关      : http://${HOST_IP}:9000/home/api/posts"
echo "----------------------------------------"
echo "健康检查:"
echo "  /home/api/posts -> HTTP ${HOME_CODE}"
echo "  /admin/posts    -> HTTP ${ADMIN_CODE}"
echo "========================================"
echo
echo "查看日志示例:"
echo "  tail -f ${GATEWAY_DIR}/nohup.out"
echo "  tail -f ${UI_DIR}/nohup.out"
echo

if [ "${HOME_CODE}" != "200" ] || [ "${ADMIN_CODE}" != "200" ]; then
    echo "警告: 部分接口未返回 200，请检查各服务日志。"
    exit 1
fi
