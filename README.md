# 运维 Blog 项目实战

CentOS 7 虚拟机上的 Java Web 项目部署实战合集，包含 **Resume**、**Blog**、**Blog Cloud** 三个项目。

## 项目一览

| 项目 | 目录 | 技术栈 | 端口 | 说明 |
|------|------|--------|------|------|
| Resume | [webapp/](webapp/) | Servlet + JSP + Tomcat | 8080 | 登录后展示在线运维简历 |
| Blog | [blog/](blog/) | Spring Boot + MySQL | 8081 | 单体博客系统（内置 Tomcat） |
| Blog Cloud | [blog-cloud/](blog-cloud/) | Spring Cloud + Vue 3 | 8082 | 微服务博客（前后端分离） |
| Nginx 反代 | [nginx/](nginx/) | Nginx 反向代理 | 80 | 同机反代 Blog，Resume 走 8080 |

三个项目 + Nginx 可在**同一台虚拟机**共存：端口分开即可。

---

## Resume 项目

基于 **Servlet + JSP + MySQL** 的 Java Web 系统，部署在外部 Tomcat 8 上。

详细说明见 [docs/部署教程.md](docs/部署教程.md)。

```bash
# 部署到 Tomcat 启动
/usr/local/tomcat8/bin/startup.sh
# 访问 http://IP:8080  默认账号 admin/admin
#关闭
cd /usr/local/tomcat8/bin
./shutdown.sh
```

---

## Blog 项目

基于 **Spring Boot** 的博客系统，使用 `java -jar` 传统部署。

详细说明见 [blog/README.md](blog/README.md) 与 [blog/docs/部署教程.md](blog/docs/部署教程.md)。

```bash
mkdir -p /opt/web/blog && cd /opt/web/blog
# 上传 blog-0.0.1-SNAPSHOT.jar
cp config/application.yml.example application.yml   # 修改数据库与端口
mysql -uroot -p -e "CREATE DATABASE myblog DEFAULT CHARSET utf8mb4;"
#启动：
chmod u+x scripts/start.sh && ./scripts/start.sh
# 访问 http://IP:8081
#关闭：
ps -ef | grep java #查看端口
ss -lntp | grep java #查看进程
kill <端口号>
```

---

## Blog Cloud 项目

基于 **Spring Cloud 微服务 + Vue 3** 的前后端分离博客，包含 Eureka、Gateway、Home/Admin 微服务。

详细说明见 [blog-cloud/README.md](blog-cloud/README.md) 与 [blog-cloud/docs/部署教程.md](blog-cloud/docs/部署教程.md)。

```bash
# 部署到 /opt/web，上传 4 个 jar 包后：
cp blog-cloud/scripts/start-all.sh /opt/web/start-all.sh
chmod +x /opt/web/start-all.sh
/opt/web/start-all.sh
# 访问 http://IP:8082/  后台 http://IP:8082/admin
#关闭
/opt/web/stop-all.sh
```

---

## Nginx 反向代理

用 Nginx（80 端口）反向代理 Blog（8081）。支持 **一台虚拟机** 和 **两台虚拟机** 两种方式，详见 [nginx/README.md](nginx/README.md)。

| 场景 | 配置模板 | `proxy_pass` 写法 |
|------|----------|-------------------|
| 一台虚拟机（本仓库实战） | `nginx/conf/default.conf.example` | `http://127.0.0.1:8081` |
| 两台虚拟机（教程原版） | `nginx/conf/default.conf.two-vm.example` | `http://Blog虚拟机IP:8081` |

参考教程：[nginx基础 - 反向代理](http://47.121.207.32/blog/6#%E5%9B%9Bnginx%E6%97%A5%E5%BF%97%E7%AE%A1%E7%90%86)（完成至第五大点 5.1）

**一台虚拟机快速部署：**

```bash
ss -tlnp | grep -E ':(8080|8081) '
cp nginx/conf/default.conf.example /etc/nginx/conf.d/default.conf
nginx -t && nginx -s reload

# http://IP/       → Blog（Nginx 反代）
# http://IP:8080/  → Resume
# http://IP:8081   → Blog（直连）
```

**两台虚拟机**：Nginx 装在 Resume 机器，Blog 机器只跑 Blog，用 `default.conf.two-vm.example` 并把 IP 改成 Blog 虚拟机地址。

---

## MySQL 备份

Blog 数据库 `myblog` 定时备份，使用 `mysqldump` + `crontab`。

详细说明见 [script/mysql_bak/README.md](script/mysql_bak/README.md)。

```bash
# 1. 部署脚本（从模板复制，本地修改密码）
mkdir -p /opt/script/mysql_bak
cp script/mysql_bak/mysql_bak.sh.example /opt/script/mysql_bak/mysql_bak.sh
vim /opt/script/mysql_bak/mysql_bak.sh
chmod +x /opt/script/mysql_bak/mysql_bak.sh

# 2. 手动测试
/opt/script/mysql_bak/mysql_bak.sh
ls -lh /opt/script/*-mysql-blog.sql

# 3. 添加定时任务
crontab -e
# 每周日凌晨 2 点备份（推荐）：
# 0 2 * * 0 /opt/script/mysql_bak/mysql_bak.sh
```

> 含真实密码的 `mysql_bak.sh` 和导出的 `.sql` 文件不提交 Git，仅提交 `.example` 模板。

---

## 仓库结构

```
.
├── README.md
├── docs/部署教程.md              # Resume 部署教程
├── sql/user.sql                  # Resume 数据库
├── webapp/                       # Resume（Servlet + JSP）
├── blog/                         # Blog（Spring Boot 单体）
│   ├── README.md
│   ├── config/application.yml.example
│   ├── docs/部署教程.md
│   ├── scripts/start.sh
│   ├── sql/blog.sql
│   └── docker/
├── blog-cloud/                   # Blog Cloud（Spring Cloud 微服务 + Vue）
│   ├── README.md
│   ├── config/                   # 各服务配置模板
│   ├── frontend/                 # Vue 前端源码
│   ├── scripts/
│   │   ├── start-all.sh          # 一键启动
│   │   └── stop-all.sh           # 一键停止
│   └── docs/部署教程.md
└── nginx/                        # Nginx 反向代理
    ├── README.md
    └── conf/
        ├── default.conf.example
        └── default.conf.two-vm.example
└── script/                       # 运维脚本
    └── mysql_bak/
        ├── README.md
        └── mysql_bak.sh.example  # MySQL 备份模板（含 crontab 说明）
```

## 环境要求

- CentOS 7（2 核 2G）
- MySQL 5.7（Resume、Blog 需要）
- JDK 8
- Tomcat 8.5（仅 Resume 需要）
- Nginx 1.18+（yum 或源码包安装，反向代理 Resume + Blog 需要）
- Node.js 16+（仅 Blog Cloud 前端需要）

## 常用下载

| 软件 | 地址 |
|------|------|
| JDK 8 | https://repo.huaweicloud.com/java/jdk/8u192-b12/jdk-8u192-linux-x64.tar.gz |
| Tomcat 8.5.70 | https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.70/bin/apache-tomcat-8.5.70.tar.gz |
| MySQL 5.7 | https://mirrors.aliyun.com/mysql/MySQL-5.7/ |
| Nginx 1.18.0 | https://nginx.org/download/nginx-1.18.0.tar.gz |

## 说明

- 部署实战练习项目，Resume 应用原作者 **he_ber**
- `db.properties`、`application.yml` 含敏感信息，已加入 `.gitignore`，仅提交 `.example` 模板
- jar 包体积较大，请自行放置到部署目录，不纳入 Git 仓库
- Blog Cloud 启停：部署后将 `scripts/start-all.sh` 和 `scripts/stop-all.sh` 复制到 `/opt/web/`，分别用于启动和停止全部服务
- Nginx 反向代理：将 `nginx/conf/default.conf.example` 复制到 `/etc/nginx/conf.d/default.conf`，教程参考 [he_ber nginx 基础](http://47.121.207.32/blog/6)，本仓库为同机部署的最终可用方案
- MySQL 备份：将 `script/mysql_bak/mysql_bak.sh.example` 复制到 `/opt/script/mysql_bak/mysql_bak.sh` 并配置 crontab，密码与 `.sql` 备份文件不纳入 Git

## License

学习交流用途。
