# resume项目部署

### 一、环境准备

准备一台服务器，2核心2线程，2G的服务器；

我们一般有了新的项目要部署就会申请服务器，一般我们拿到一台新的服务器都要对这个服务器进行一个初始化，比如IP的配置，防火墙的配置，还有账号密码的设置等，我这里搞了一个简单的初始化脚本

```bash
#!/bin/bash
 # 设置要分配的IP地址、子网掩码和默认网关
echo '正在关闭防火墙'
systemctl stop firewalld && systemctl disable firewalld
echo '正在关闭networkmanager'
systemctl stop NetworkManager && systemctl disable NetworkManager
echo '正在关闭selinux'
setenforce 0 && sed -ri 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
echo '正在配置网卡'
ip_address="192.168.153.8"
subnet_mask="255.255.255.0"
default_gateway="192.168.137.2"
networkfile=/etc/sysconfig/network-scripts/ifcfg-ens32
if [ -f "$networkfile" ]; then
    rm "$networkfile"
fi
# 编写ifcfg-ens32文件并将其复制到相应目录中
cat >> /etc/sysconfig/network-scripts/ifcfg-ens32 <<EOF
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="yes"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens32"
UUID="2a28f6f8-c188-4415-b960-42b19519a04b"
DEVICE="ens32"
ONBOOT="yes"
IPADDR=$ip_address
NETMASK=$subnet_mask
GATEWAY=$default_gateway
DNS1=114.114.114.114
DNS2=223.5.5.5
EOF

echo '正在安装基础软件包'
yum -y install wget lrzsz unzip gzip telnet
echo '配置基础环境变量'
cat >> /etc/profile <<EOF
if [ $(id -u) == 0 ]; then
export PS1='[\[\e[31;1m\]\u\[\e[m\]@\h \w]# '
else
export PS1='[\[\e[34;1m\]\u\[\e[m\]@\h \w]$ '
fi
alias ll='ls -lh --color=auto'
alias grep='grep --color'
alias free='free -m'
alias df='df -h'
alias du='du -h'
alias vi='vim'
EOF
cat >> ~/.vimrc <<EOF
"设置高亮
syntax on
"显示行号
set number
"自动缩进功能
set autoindent
"启用鼠标支持
"set mouse=a
"vim新打开.sh文件自动添加一下内容
autocmd BufNewFile *.sh exec ":call SetComment()"
func SetComment()
     if expand("%:e")=='sh'
         call setline(1,'#!/bin/bash')
         call setline(2,'#Author:     xxx')
         call setline(3,'#Create time:'.strftime("%Y-%m-%d"))
     endif
endfunc
EOF
source /etc/profile
systemctl restart network
echo '脚本执行完毕'

```

没有执行权限，给他一个执行权限

```
chmod +x init.sh
```

### 二、项目解析

我们服务器开好后应该先了解一下项目的部署，如需要哪些中间件来支撑这个服务；

使用jdk8+tomcat8+mysql5.7

但是我们部署项目的时候如果看到数据库那么我们最好优先部署数据库

### 三、数据库的部署

数据库的部署我们可以使用3种部署方法

1.配置mysql的yum源然后直接安装

2.直接下载rpm包然后直接安装（我选择第二种）

3.下载mysql的源码包进行安装

##### 1.下载rpm包

```bash
mkdir /opt/soft/mysql -p && cd /opt/soft/mysql
wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-community-client-5.7.36-1.el7.x86_64.rpm
wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-community-common-5.7.36-1.el7.x86_64.rpm
wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-community-devel-5.7.36-1.el7.x86_64.rpm
wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-community-libs-5.7.36-1.el7.x86_64.rpm
wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-community-libs-compat-5.7.36-1.el7.x86_64.rpm
wget https://mirrors.aliyun.com/mysql/MySQL-5.7/mysql-community-server-5.7.36-1.el7.x86_64.rpm
```

##### 2.安装mysql

```bash
yum -y install mysql-community*
```

##### 3.配置

安装完成后我们不要急着启动，先给mysql来一个自定义配置

备份原来的配置，然后添加新的配置

mv /etc/my.cnf /etc/my.cnf20250609

vim /etc/my.cnf

```cnf
#客户端设置
[client]

#mysql服务配置
[mysqld]
#服务器监听端口，默认为3306
port=3306
#数据存储位置
datadir=/var/lib/mysql
#Unix套接字文件路径
socket=/var/lib/mysql/mysql.sock
#MySQL服务唯一标识,开启二进制日志，做主从时需要
server-id=1
log-bin=mysql-bin
#不会跟随符号链接
symbolic-links=0
#日志路径
log-error=/var/log/mysqld.log
#服务进程pid文件路径
pid-file=/var/run/mysqld/mysqld.pid
#mysql字符集设置
character_set_server=utf8mb4
#mysql比较规则设置
collation_server=utf8mb4_general_ci
```

##### 4.启动mysql

```bash
#设置开机自启并立即启动
systemctl enable mysqld && systemctl start mysqld
#查看mysql状态
systemctl status mysqld
```

##### 5.修改密码

yum安装的mysql会在日志中给我们生成一个临时密码，我们需要用这个临时密码去修改成我们自己的密码

```bash
#查看临时密码
grep 'password' /var/log/mysqld.log
#修改mysql密码
mysqladmin -uroot -p'临时密码' password '需要修改的密码'
mysqladmin -uroot -p'临时密码' password '你的密码'
```

##### 6.授权

mysql安装完成后还需要给一个登录权限不然无法用IP连接

登录mysql

```sql
mysql -uroot -p
- 查看一下用户是否具有权限
SELECT user,host,authentication_string from mysql.user;
```

授权

```sql
--语法
GRANT 权限列表 ON 库名.表名 TO '用户名'@'客户端主机ip' IDENTIFIED BY '密码' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY '你的密码' WITH GRANT OPTION;
-- 最后刷新
FLUSH PRIVILEGES;
```

##### 7.创建数据库

创建数据库并导入数据

### 四、部署tomcat和jdk

##### 1.创建包存放目录

```bash
mkdir /opt/soft/tomcat && cd /opt/soft/tomcat
#上传安装包
[root@localhost /opt/soft/tomcat]# ll
-rw-r--r--. 1 root root 11M 6月   9 09:09 apache-tomcat-8.5.70.tar.gz
```

##### 2.解压安装包

```bash
tar -zxvf apache-tomcat-8.5.70.tar.gz
```

##### 3.创建解压安装后的目录

```bash
mkdir /usr/local/tomcat8
```

##### 4.移动解压好的文件

```bash
mv /opt/soft/tomcat/apache-tomcat-8.5.70/* /usr/local/tomcat8/
```

##### 5.安装jdk

```bash
#创建目录并上传包
mkdir /opt/soft/jdk && cd /opt/soft/jdk
#创建Java文件夹
mkdir /usr/local/java
#上传jdk后解压
unzip jdk1.8.0_121.zip
#移动解压后的jdk
mv jdk1.8.0_121 /usr/local/java/
#授权，这里不授权java命令执行时会提示没权限
chmod +x /usr/local/java/jdk1.8.0_121/bin/*
chmod +x /usr/local/java/jdk1.8.0_121/jre/bin/*
```

##### 6.配置环境变量

```bash
#vim /etc/profile
export JAVA_HOME=/usr/local/java/jdk1.8.0_121
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=$JAVA_HOME/lib:${JRE_HOME}/lib:$CLASSPATH
export CATALINA_HOME=/usr/local/tomcat8
export JAVA_PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin:${CATALINA_HOME}/bin
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$CATALINA_HOME/bin
#刷新环境变量
source /etc/profile
```

##### 7.在Tomcat中配置jdk

```bash
vim /usr/local/tomcat8/bin/catalina.sh
#添加
export JAVA_HOME=/usr/local/java/jdk1.8.0_121/
export JRE_HOME=/usr/local/java/jdk1.8.0_121/jre
```

##### 8.启动Tomcat

```bash
[root@localhost /opt/soft/jdk]# cd /usr/local/tomcat8/bin/
[root@localhost /usr/local/tomcat8/bin]# ./startup.sh 
Using CATALINA_BASE:   /usr/local/tomcat8
Using CATALINA_HOME:   /usr/local/tomcat8
Using CATALINA_TMPDIR: /usr/local/tomcat8/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_121/jre
Using CLASSPATH:       /usr/local/tomcat8/bin/bootstrap.jar:/usr/local/tomcat8/bin/tomcat-juli.jar
Using CATALINA_OPTS:   
Tomcat started.
```

##### 9.访问

打开浏览器，输入IP:port能访问就表示tomcat部署完成

### 五、运行resume

##### 1.上传项目

```bash
/usr/local/tomcat8/webapps
```

##### 2.修改配置文件

```bash
vim /usr/local/tomcat8/webapps/javaweb/WEB-INF/classes/db.properties
```

##### 3.重启tomcat

```bash
[root@localhost /usr/local/tomcat8/bin]# cd /usr/local/tomcat8/bin/
[root@localhost /usr/local/tomcat8/bin]# ./shutdown.sh 
Using CATALINA_BASE:   /usr/local/tomcat8
Using CATALINA_HOME:   /usr/local/tomcat8
Using CATALINA_TMPDIR: /usr/local/tomcat8/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_121/jre
Using CLASSPATH:       /usr/local/tomcat8/bin/bootstrap.jar:/usr/local/tomcat8/bin/tomcat-juli.jar
Using CATALINA_OPTS:   
[root@localhost /usr/local/tomcat8/bin]# ./startup.sh 
Using CATALINA_BASE:   /usr/local/tomcat8
Using CATALINA_HOME:   /usr/local/tomcat8
Using CATALINA_TMPDIR: /usr/local/tomcat8/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_121/jre
Using CLASSPATH:       /usr/local/tomcat8/bin/bootstrap.jar:/usr/local/tomcat8/bin/tomcat-juli.jar
Using CATALINA_OPTS:   
Tomcat started.
```

##### 4.访问

