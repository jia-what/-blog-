#!/bin/bash
# 博客微服务一键停止脚本
# 停止顺序: 前端 -> blog-gateway -> blog-home / blog-admin -> Eureka

BASE_DIR="/opt/web"

EUREKA_JAR="eureka-0.0.1-SNAPSHOT.jar"
HOME_JAR="blog-home-1.0.0.jar"
ADMIN_JAR="blog-admin-1.0.0.jar"
GATEWAY_JAR="blog-gateway-1.0.0.jar"
FRONTEND_PATTERN="vue-cli-service.js serve"

log() {
    echo "[$(date '+%H:%M:%S')] $*"
}

stop_process() {
    local pattern="$1"
    local name="$2"

    if pgrep -f "${pattern}" > /dev/null 2>&1; then
        log "正在停止 ${name} ..."
        pkill -f "${pattern}"
        sleep 2
        if pgrep -f "${pattern}" > /dev/null 2>&1; then
            log "${name} 未正常退出，强制停止 ..."
            pkill -9 -f "${pattern}"
            sleep 1
        fi
        log "${name} 已停止"
    else
        log "${name} 未在运行，跳过"
    fi
}

wait_port_closed() {
    local port="$1"
    local name="$2"
    local retries=10

    for ((i = 1; i <= retries; i++)); do
        if ! ss -tln 2>/dev/null | grep -q ":${port} " && ! netstat -tln 2>/dev/null | grep -q ":${port} "; then
            log "${name} 端口 ${port} 已释放"
            return 0
        fi
        sleep 1
    done

    log "警告: ${name} 端口 ${port} 可能仍未释放"
}

log "开始停止博客系统 ..."

# 1. 前端
stop_process "${FRONTEND_PATTERN}" "前端"
wait_port_closed 8082 "前端"

# 2. 网关
stop_process "${GATEWAY_JAR}" "blog-gateway"
wait_port_closed 9000 "blog-gateway"

# 3. 微服务
stop_process "${HOME_JAR}" "blog-home"
stop_process "${ADMIN_JAR}" "blog-admin"
wait_port_closed 9001 "blog-home"
wait_port_closed 9002 "blog-admin"

# 4. Eureka
stop_process "${EUREKA_JAR}" "Eureka"
wait_port_closed 8761 "Eureka"

echo
echo "========================================"
echo " 博客系统已全部停止"
echo "========================================"
echo "重新启动请执行:"
echo "  ${BASE_DIR}/start-all.sh"
echo "========================================"
