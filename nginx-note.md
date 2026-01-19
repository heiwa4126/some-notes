# nginxメモ

nginx のメモ

# /run/nginx.pidの警告を抑制する

謎の警告が残る

> nginx.service: Failed to parse PID from file /run/nginx.pid: Invalid argument

既知のバグで、
回避策は [Bug #1581864 “nginx.service: Failed to read PID from file /run/n...” : Bugs : nginx package : Ubuntu](https://bugs.launchpad.net/ubuntu/+source/nginx/+bug/1581864) から引用

root で以下を実行 (systemd の drop-in)

```sh
mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
systemctl daemon-reload
```

で、

```sh
systemctl restart nginx
```
