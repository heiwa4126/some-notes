# Snappyメモ

# proxy

```
sudo emacs /etc/systemd/system/snapd.service.d/snap_proxy.conf
[Service]
Environment="HTTP_PROXY=http://10.250.42.37:3128"
Environment="HTTPS_PROXY=http://10.250.42.37:3128"
EOF
sudo systemctl daemon-reload
sudo systemctl restart snapd.service
sudo snap refresh
```
