# Nginx 反向代理

用 Nginx（80 端口）反向代理 Blog 项目（8081），实现统一访问入口。支持 **一台虚拟机** 和 **两台虚拟机** 两种部署方式。

## 两种场景对比

| 对比项 | 两台虚拟机（教程/视频常见） | 一台虚拟机（本仓库实战） |
|--------|---------------------------|-------------------------|
| 部署方式 | Resume、Nginx 在 **VM1**；Blog 在 **VM2** | Resume、Blog、Nginx **同一台** |
| Nginx 装在哪 | **Resume 那台**（VM1） | 本机 |
| `proxy_pass` 目标 | **Blog 虚拟机 IP**:8081 | `127.0.0.1`:8081 |
| Resume 访问 | `http://VM1_IP:8080/` | `http://IP:8080/` |
| Blog 直连 | `http://VM2_IP:8081` | `http://IP:8081` |
| Blog 经 Nginx | `http://VM1_IP/` | `http://IP/` |
| 配置模板 | `conf/default.conf.two-vm.example` | `conf/default.conf.example` |

---

## 场景一：两台虚拟机（教程原版）

和视频教程一致：Resume 和 Nginx 在 **虚拟机 A**，Blog 在 **虚拟机 B**。

### 架构图

```
                    虚拟机 A（Resume 机器）              虚拟机 B（Blog 机器）
                    例：192.168.153.8                   例：192.168.153.9
                    ┌─────────────────────┐          ┌─────────────────────┐
浏览器 ────────────►│ Nginx :80           │          │                     │
  http://A/         │   proxy_pass ───────┼─────────►│ Blog :8081          │
                    │                     │  内网转发 │                     │
  http://A:8080/ ──►│ Tomcat :8080        │          └─────────────────────┘
  (Resume)          │ (Resume)            │
                    └─────────────────────┘
```

### 部署步骤

**虚拟机 B（Blog 机器）**——只跑 Blog，不需要 Nginx：

```bash
# 部署 Blog，监听 8081
cd /opt/web/blog
./scripts/start.sh

# 确认 Blog 已启动
ss -tlnp | grep 8081
curl -I http://127.0.0.1:8081/
```

**虚拟机 A（Resume 机器）**——跑 Resume + Nginx：

```bash
# 1. 启动 Resume（Tomcat 8080）
/usr/local/tomcat8/bin/startup.sh

# 2. 测试能否访问 Blog 虚拟机（重要！）
curl -I http://192.168.153.9:8081/
# 必须返回 200，否则 Nginx 反代会 502

# 3. 复制两台虚拟机专用配置（把 IP 改成你的 Blog 虚拟机 IP）
cp nginx/conf/default.conf.two-vm.example /etc/nginx/conf.d/default.conf
vim /etc/nginx/conf.d/default.conf   # 修改 proxy_pass 中的 Blog 虚拟机 IP

# 4. 检查并重载
nginx -t
nginx -s reload
```

### 关键配置

```nginx
location / {
    proxy_pass http://192.168.153.9:8081;   # Blog 虚拟机的 IP
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

### 访问方式

| 地址 | 看到什么 |
|------|----------|
| `http://192.168.153.8/` | Blog（Nginx 反代，走 VM1 的 80 端口） |
| `http://192.168.153.8:8080/` | Resume（VM1 上的 Tomcat） |
| `http://192.168.153.9:8081` | Blog 直连（VM2） |

### 两台机器注意事项

- Blog 虚拟机防火墙需放行 **8081**，Resume 虚拟机防火墙需放行 **80、8080**
- Resume 虚拟机必须能 `ping` 通、`curl` 通 Blog 虚拟机的 8081
- Nginx **只装在 Resume 虚拟机**，Blog 虚拟机不需要装 Nginx
- `proxy_pass` 写 **Blog 虚拟机的内网 IP**，不要写 `127.0.0.1`（Blog 不在本机）

---

## 场景二：一台虚拟机（本仓库实战 ✅）

Resume、Blog、Nginx 都在同一台机器，只需把教程里的 Blog IP 改成 `127.0.0.1`。

### 架构图

```
                    同一台虚拟机 192.168.153.8
                    ┌─────────────────────────────────┐
浏览器              │                                 │
  http://IP/    ───►│ Nginx :80 ──► Blog :8081 (本机)  │
  http://IP:8080/ ►│ Tomcat :8080 (Resume)           │
  http://IP:8081  ►│ Blog :8081 (直连)               │
                    └─────────────────────────────────┘
```

| 端口 | 服务 | 访问内容 |
|------|------|----------|
| 80 | Nginx | Blog（反向代理后） |
| 8080 | Tomcat | Resume（`http://IP:8080/`，非 `/resume`） |
| 8081 | Spring Boot | Blog（直连） |

### 部署步骤

#### 1. 确认 Resume 和 Blog 已启动

```bash
ss -tlnp | grep -E ':(8080|8081) '

curl -I http://127.0.0.1:8080/
curl -I http://127.0.0.1:8081/
```

#### 2. 确认 80 端口由系统 Nginx 占用

```bash
ss -tlnp | grep ':80 '
# 应看到 /usr/sbin/nginx
```

> **重要**：若同时安装了 yum 版（`/usr/sbin/nginx`）和源码版（`/usr/local/nginx/sbin/nginx`），**只能选一个占 80 端口**。本方案使用 **yum 安装的系统 Nginx**。

#### 3. 复制配置模板

```bash
cp nginx/conf/default.conf.example /etc/nginx/conf.d/default.conf
```

#### 4. 检查并重载

```bash
nginx -t
nginx -s reload
```

#### 5. 验证

| 地址 | 预期 |
|------|------|
| `http://IP/` | 看到 Blog 页面 |
| `http://IP:8081` | Blog 直连正常 |
| `http://IP:8080/` | Resume 登录页（账号 `admin/admin`） |

### 关键配置

```nginx
location / {
    proxy_pass http://127.0.0.1:8081;   # 本机 Blog，写 127.0.0.1
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

---

## 参考教程

学习参考：[nginx基础 - 第五大点：反向代理](http://47.121.207.32/blog/6#%E5%9B%9Bnginx%E6%97%A5%E5%BF%97%E7%AE%A1%E7%90%86)

| 教程章节 | 完成情况 |
|----------|----------|
| 一、nginx 概念 | 已学习 |
| 二、nginx 安装（yum / 源码包） | 已实践（两种方式都装过） |
| 三、Nginx 基本配置 | 已学习 |
| 四、Nginx 日志管理 | 未做 |
| **五、反向代理 → 5.1 反向代理的配置** | **已做（按教程初配）** |
| 五、反向代理 → 5.2 负载均衡及以后 | 未做 |
| 六～十一章 | 未做 |

教程示例是把请求代理到 `http://www.baidu.com`，实际应代理 Blog 项目。两台虚拟机写 Blog 的 IP，一台虚拟机写 `127.0.0.1`。

## 关键配置说明

| 指令 | 作用 |
|------|------|
| `proxy_pass` | 把请求转发到后端 Blog |
| `proxy_set_header Host` | 传递访问域名 |
| `X-Real-IP` | 传递客户端真实 IP |
| `X-Forwarded-For` | 传递代理链 IP |
| `X-Forwarded-Proto` | 传递 http/https 协议 |

## 踩坑记录

### 1. 80 端口被占用，源码版 Nginx 启动失败

```
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
```

**原因**：yum 版 Nginx 已在跑，源码版 `/usr/local/nginx/sbin/nginx` 无法再占 80。

**处理**：使用已在运行的系统 Nginx，执行 `nginx -s reload`，不要重复启动第二套。

### 2. reload 报错 pid 为空

```
nginx: [error] invalid PID number "" in "/usr/local/nginx/logs/nginx.pid"
```

**原因**：源码版 Nginx 从未成功启动，`nginx.pid` 是空的。

**处理**：对系统 Nginx 操作：

```bash
nginx -t
nginx -s reload
```

### 3. 按教程配了 `/usr/local/nginx` 但不生效

教程用源码安装，配置写在 `/usr/local/nginx/conf/nginx.conf`；实际占 80 的是 `/etc/nginx/conf.d/default.conf`。

**处理**：改 **系统 Nginx** 的配置，不是只改源码版那份。

### 4. `http://IP:8080/resume` 返回 404

**原因**：Resume 部署在 Tomcat 的 `ROOT` 目录，访问路径是 `/` 而不是 `/resume`。

**正确地址**：`http://IP:8080/`

## 常用命令

```bash
# 查看端口
ss -tlnp | grep -E ':(80|8080|8081) '

# 检查配置
nginx -t

# 重载配置（不中断服务）
nginx -s reload

# 启停系统 Nginx
systemctl start nginx
systemctl stop nginx

# 查看日志
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log
```

## 目录结构

```
nginx/
├── README.md                          # 本文档（含一台/两台虚拟机对比）
└── conf/
    ├── default.conf.example           # 一台虚拟机：proxy_pass 127.0.0.1:8081
    └── default.conf.two-vm.example    # 两台虚拟机：proxy_pass Blog虚拟机IP:8081
```

- **一台虚拟机**：复制 `default.conf.example` → `/etc/nginx/conf.d/default.conf`
- **两台虚拟机**：复制 `default.conf.two-vm.example`，修改其中的 Blog IP

## 后续可学习内容（教程未做部分）

- 五、5.2 负载均衡（upstream）
- 六、动静分离
- 七、HTTPS 配置
- 四、日志轮转

详见 [教程原文](http://47.121.207.32/blog/6)。
