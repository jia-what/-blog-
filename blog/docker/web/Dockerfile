FROM openjdk:8-jdk-alpine
MAINTAINER heber<heber@123.com>
# 设置工作目录为 /app
 WORKDIR /app
# 将当前目录下的 target/所有东西复制到工作目录
 COPY ./* /app/

# 定义容器启动后执行的命令，运行 Java 应用
 CMD ["java", "-jar", "/app/blog-0.0.1-SNAPSHOT.jar"]
