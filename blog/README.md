# Blog 项目

基于 **Spring Boot** 的博客系统，支持传统部署（`java -jar`）与 Docker 部署。

## 技术栈

| 组件 | 说明 |
|------|------|
| 框架 | Spring Boot（内置 Tomcat） |
| 数据库 | MySQL 5.7 |
| JDK | 1.8 |
| 模板 | Thymeleaf |

## 目录结构

```
blog/
├── config/application.yml.example   # 配置模板（含端口 8081）
├── docs/部署教程.md                    # 传统部署完整步骤
├── scripts/start.sh                   # 启动脚本
├── sql/blog.sql                       # 数据库脚本
└── docker/                            # Docker 部署配置
```

## 快速部署（传统方式）

```bash
# 1. 创建目录并上传 jar 包
mkdir -p /opt/web/blog && cd /opt/web/blog

# 2. 复制配置模板并修改
cp application.yml.example application.yml
vim application.yml

# 3. 创建数据库
mysql -uroot -p -e "CREATE DATABASE myblog DEFAULT CHARSET utf8mb4;"
mysql -uroot -p myblog < blog.sql

# 4. 启动
chmod +x start.sh && ./start.sh
```

访问：`http://服务器IP:8081`

## 与 Resume 项目同机部署

| 项目 | 端口 | 运行方式 |
|------|------|----------|
| resume | 8080 | 外部 Tomcat |
| blog | **8081** | `java -jar` |

共用 MySQL、JDK，数据库分别使用 `resume` / `myblog`。

详细步骤见 [docs/部署教程.md](docs/部署教程.md)。
