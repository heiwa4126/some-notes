- [MTUの確認](#mtuの確認)

# MTUの確認

```
# ping -M do -s 1472 -c 3 192.168.56.75
(省略)
# ping -M do -s 1473 -c 3 192.168.56.75
ping: local error: Message too long, mtu=1500
```
+18 octetsがMTU


