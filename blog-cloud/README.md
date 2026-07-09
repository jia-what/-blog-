# Blog Cloud 项目

基于 **Spring Cloud 微服务 + Vue 3 前后端分离** 的博客系统，包含 Eureka 注册中心、Gateway 网关、Home/Admin 微服务与 Vue 前端。

## 技术栈

| 组件 | 说明 |
|------|------|
| 注册中心 | Eureka（8761） |
| API 网关 | Spring Cloud Gateway（9000） |
| 微服务 | blog-home（9001）、blog-admin（9002） |
| 前端 | Vue 3 + Vue Router + Axios（8082） |
| JDK | 1.8 |
| Node.js | 16+（前端开发） |

## 与其他项目的区别

| 项目 | 目录 | 架构 | 端口 |
|------|------|------|------|
| Resume | `webapp/` | Servlet + JSP + Tomcat | 8080 |
| Blog | `blog/` | Spring Boot 单体 | 8081 |
| **Blog Cloud** | `blog-cloud/` | **Spring Cloud 微服务 + Vue** | **8082** |

## 目录结构

```
blog-cloud/
├── config/                         # 各服务配置模板
│   ├── eureka/application.yml.example
│   ├── blog-gateway/application.yml.example
│   ├── blog-home/application.yml.example
│   └── blog-admin/application.yml.example
├── frontend/                       # Vue 前端源码
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── vue.config.js
├── scripts/start-all.sh            # 一键启动脚本
└── docs/部署教程.md
```

## 快速部署

```bash
# 1. 创建部署目录
mkdir -p /opt/web/{eureka,blog-home,blog-admin,blog-gateway,blog-ui}

# 2. 上传 jar 包到对应目录（jar 不纳入 Git，需自行准备）
#    eureka-0.0.1-SNAPSHOT.jar
#    blog-home-1.0.0.jar
#    blog-admin-1.0.0.jar
#    blog-gateway-1.0.0.jar

# 3. 复制配置模板
cp config/eureka/application.yml.example      /opt/web/eureka/application.yml
cp config/blog-home/application.yml.example   /opt/web/blog-home/application.yml
cp config/blog-admin/application.yml.example  /opt/web/blog-admin/application.yml
cp config/blog-gateway/application.yml.example /opt/web/blog-gateway/application.yml

# 4. 修改网关 CORS 中的 YOUR_IP 为虚拟机实际 IP
vim /opt/web/blog-gateway/application.yml

# 5. 部署前端
cp -r frontend/ /opt/web/blog-ui/blog-ui
cd /opt/web/blog-ui/blog-ui && npm install

# 6. 一键启动
cp scripts/start-all.sh /opt/web/start-all.sh
chmod +x /opt/web/start-all.sh
/opt/web/start-all.sh
```

## 访问地址

| 页面 | 地址 |
|------|------|
| 博客首页 | `http://IP:8082/` |
| 后台管理 | `http://IP:8082/admin` |
| Eureka 控制台 | `http://IP:8761` |
| API 网关（仅接口） | `http://IP:9000/home/api/posts` |

> 注意：`9000` 是 API 网关，根路径 `/` 没有页面，404 是正常现象。

## 详细说明

见 [docs/部署教程.md](docs/部署教程.md)。
