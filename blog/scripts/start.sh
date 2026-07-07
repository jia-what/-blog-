#!/bin/bash
# Blog 项目启动脚本（传统部署）

JAR_FILE="blog-0.0.1-SNAPSHOT.jar"

if ! command -v java &> /dev/null; then
    echo "错误：Java 未安装"
    exit 1
fi

if [ ! -f "$JAR_FILE" ]; then
    echo "错误：找不到 $JAR_FILE，请将 jar 包放到当前目录"
    exit 1
fi

if pgrep -f "$JAR_FILE" &> /dev/null; then
    echo "错误：应用已在运行"
    exit 1
fi

if [ ! -d "log" ]; then
    mkdir log
fi

nohup java -jar "$JAR_FILE" --spring.config.location=./application.yml > log/blog.log 2>&1 &
echo "Blog 已启动，进程 ID: $!"
echo "日志: tail -f log/blog.log"
