# MySQL 备份脚本

Blog 项目数据库 `myblog` 的定时备份方案，使用 `mysqldump` 导出 SQL 文件。

## 文件说明

| 文件 | 说明 |
|------|------|
| `mysql_bak.sh.example` | 配置模板（提交到 Git） |
| `mysql_bak.sh` | 实际运行脚本（含密码，**仅放服务器，不提交 Git**） |

## 部署步骤

```bash
# 1. 创建目录
mkdir -p /opt/script/mysql_bak

# 2. 从仓库复制脚本模板
cp script/mysql_bak/mysql_bak.sh.example /opt/script/mysql_bak/mysql_bak.sh

# 3. 修改数据库连接信息（IP、密码、库名等）
vim /opt/script/mysql_bak/mysql_bak.sh

# 4. 授权并手动测试
chmod +x /opt/script/mysql_bak/mysql_bak.sh
/opt/script/mysql_bak/mysql_bak.sh

# 5. 确认备份文件已生成
ls -lh /opt/script/*-mysql-blog.sql
```

## 脚本做了什么

1. 读取 MySQL 连接配置（主机、端口、用户、密码、库名）
2. 在 `/opt/script/` 下生成带时间戳的备份文件，例如：
   ```
   /opt/script/2026-07-10-16-34-mysql-blog.sql
   ```
3. 使用 `mysqldump` 导出 `myblog` 数据库全部数据

## 定时任务（crontab）

当前服务器上的定时任务：

```cron
* * * * 0 /opt/script/mysql_bak/mysql_bak.sh
```

含义：**每周日（0），每分钟执行一次**。

> 若只需每周备份一次，建议改为例如每周日凌晨 2 点：
>
> ```cron
> 0 2 * * 0 /opt/script/mysql_bak/mysql_bak.sh
> ```

### 添加/修改定时任务

```bash
crontab -e
```

添加一行后保存，查看是否生效：

```bash
crontab -l
```

### crontab 时间格式

```
分  时  日  月  星期
*   *   *   *   0    → 每周日每分钟（当前配置）
0   2   *   *   0    → 每周日凌晨 2:00（推荐）
0   3   *   *   *    → 每天凌晨 3:00
```

## 恢复备份（参考）

```bash
mysql -uroot -p myblog < /opt/script/2026-07-10-16-34-mysql-blog.sql
```

## 注意事项

- `mysql_bak.sh` 内含数据库密码，已加入 `.gitignore`，请勿提交到 GitHub
- 备份 `.sql` 文件体积会持续增长，需定期清理旧备份或配合日志轮转
- 确保服务器已安装 `mysqldump`（MySQL 客户端工具）
- Resume 项目数据库为 `resume`，若需备份可另建脚本或扩展本脚本
