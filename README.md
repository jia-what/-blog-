# Resume 项目部署实战

在 CentOS 7 虚拟机上完成 Java Web 项目的全流程部署实战：服务器初始化 → MySQL → JDK/Tomcat → 项目上线。

## 项目简介

这是一个运维方向的部署练手项目。应用为基于 **Servlet + JSP + MySQL** 的 Java Web 系统，登录后展示在线运维工程师简历页面。

- 登录页：DevOps 风格登录界面
- 主页：在线简历展示（技能、工作经历、项目经验）

## 技术栈

| 组件 | 版本 |
|------|------|
| 操作系统 | CentOS 7 |
| 数据库 | MySQL 5.7 |
| Web 容器 | Apache Tomcat 8.5.70 |
| JDK | 1.8 |
| 后端 | Java Servlet |
| 前端 | JSP + CSS + jQuery |

## 仓库结构

```
.
├── README.md              # 项目说明
├── docs/
│   └── 部署教程.md         # 完整部署步骤（含排错）
├── sql/
│   └── user.sql           # 数据库初始化脚本
└── webapp/                # Tomcat 部署目录（复制到 webapps/ 下）
    ├── login.jsp
    ├── jsp/index.jsp
    ├── css/
    ├── js/
    └── WEB-INF/
        ├── web.xml
        └── classes/
            └── db.properties.example
```

## 快速部署

### 1. 环境要求

- CentOS 7 虚拟机（2 核 2G 即可）
- 可访问外网（下载 JDK、Tomcat、MySQL）

### 2. 部署步骤

详细步骤见 [docs/部署教程.md](docs/部署教程.md)，主要包括：

1. CentOS 初始化（网络、防火墙、yum 源）
2. MySQL 5.7 安装与配置
3. JDK 8 + Tomcat 8 安装
4. 导入 `sql/user.sql` 创建数据库
5. 配置 `db.properties` 并部署 `webapp/` 到 Tomcat

### 3. 数据库配置

```bash
cp webapp/WEB-INF/classes/db.properties.example webapp/WEB-INF/classes/db.properties
vim webapp/WEB-INF/classes/db.properties
```

填入你的 MySQL 地址、用户名和密码。

### 4. 部署到 Tomcat

```bash
cp -r webapp/ /usr/local/tomcat8/webapps/ROOT/
# 或重命名为 javaweb 后放到 webapps/javaweb/
/usr/local/tomcat8/bin/startup.sh
```

### 5. 访问验证

浏览器打开：`http://你的服务器IP:8080`

默认账号（见 `sql/user.sql`）：

| 用户名 | 密码 |
|--------|------|
| admin  | admin |

## 常用软件下载

| 软件 | 下载地址 |
|------|----------|
| JDK 8 | https://repo.huaweicloud.com/java/jdk/8u192-b12/jdk-8u192-linux-x64.tar.gz |
| Tomcat 8.5.70 | https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.70/bin/apache-tomcat-8.5.70.tar.gz |
| MySQL 5.7 RPM | https://mirrors.aliyun.com/mysql/MySQL-5.7/ |

## 说明

- 本项目为运维部署实战练习，Web 应用原作者为 **he_ber**
- `db.properties` 含数据库密码，已加入 `.gitignore`，请勿提交
- 部署过程遇到的问题与解决方案记录在部署教程中

## License

学习交流用途。
