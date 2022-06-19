---
title: logrotate只读文件系统问题
date: 2022-06-19 10:51:52
tags:
---

logrotate手动以root执行成功，但是自动运行失败。
<!--more-->

systemd日志提示:
```
logrotate: error: error renaming  /usr/local/nginx/logs/site.access.log.7.gz to /usr/local/nginx/logs/site.access.log.8.gz: Read-only file system
```

因为systemd有沙盒sandbox机制，可以限制service对文件系统的访问

/lib/systemd/system/logrotate.service
```
[Service]
ProtectSystem=full
```
这里启用了文件系统保护，当设置为full时，/usr、/boot、/efi和/etc文件系统是只读的，所以出现了上面的问题。可以添加一个参数来豁免特定的文件系统，让service对其可以读写，这里unit文件添加以下行:
```
[Service]
ProtectSystem=full
ReadWritePaths=/usr/local/nginx/logs
```

然后
```
$ sudo systemctl daemon-reload
```

References:

[1][logrotate read only system](https://askubuntu.com/questions/1275668/logrotate-succeeds-when-manually-run-as-root-but-fails-with-read-only-file-sys)

[2][systemd.exec](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)