# 运维 Blog 项目实战

CentOS 7 虚拟机上的 Java Web 项目部署实战合集，包含 **Resume** 与 **Blog** 两个项目。

## 项目一览

| 项目 | 技术栈 | 端口 | 说明 |
|------|--------|------|------|
| [Resume](webapp/) | Servlet + JSP + Tomcat | 8080 | 登录后展示在线运维简历 |
| [Blog](blog/) | Spring Boot + MySQL | 8081 | 博客系统（内置 Tomcat） |

两个项目可在**同一台虚拟机**共存：共用 MySQL、JDK，端口分开即可。

---

## Resume 项目

基于 **Servlet + JSP + MySQL** 的 Java Web 系统，部署在外部 Tomcat 8 上。

详细说明见 [docs/部署教程.md](docs/部署教程.md)。

```bash
# 部署到 Tomcat
cp -r webapp/ /usr/local/tomcat8/webapps/ROOT/
/usr/local/tomcat8/bin/startup.sh
# 访问 http://IP:8080  默认账号 admin/admin
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
chmod +x scripts/start.sh && ./scripts/start.sh
# 访问 http://IP:8081
```

---

## 仓库结构

```
.
├── README.md
├── docs/部署教程.md          # Resume 部署教程
├── sql/user.sql              # Resume 数据库
├── webapp/                   # Resume Web 项目
└── blog/
    ├── README.md
    ├── config/application.yml.example
    ├── docs/部署教程.md
    ├── scripts/start.sh
    ├── sql/blog.sql
    └── docker/               # Docker 部署（可选）
```

## 环境要求

- CentOS 7（2 核 2G）
- MySQL 5.7
- JDK 8
- Tomcat 8.5（仅 Resume 需要）

## 常用下载

| 软件 | 地址 |
|------|------|
| JDK 8 | https://repo.huaweicloud.com/java/jdk/8u192-b12/jdk-8u192-linux-x64.tar.gz |
| Tomcat 8.5.70 | https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.70/bin/apache-tomcat-8.5.70.tar.gz |
| MySQL 5.7 | https://mirrors.aliyun.com/mysql/MySQL-5.7/ |

## 说明

- 部署实战练习项目，Resume 应用原作者 **he_ber**
- `db.properties`、`application.yml` 含敏感信息，已加入 `.gitignore`，仅提交 `.example` 模板
- jar 包体积较大，请自行放置到部署目录，不纳入 Git 仓库

## License

学习交流用途。
