# MQTTの実験

## 概要

MQTT参照実装のMosquittoを使う。

ver1.4.2以降(2016頃)からWebsocket対応らしい。

[Installing Mosquitto MQTT broker on Raspberry Pi (with websockets) | xperimentia](https://xperimentia.com/2015/08/20/installing-mosquitto-mqtt-broker-on-raspberry-pi-with-websockets/)

[mosquittoでMQTTとWebSocket両方に対応させる - 人と技術のマッシュアップ](http://tomowatanabe.hatenablog.com/entry/2016/01/21/095007)


# インストール

このへんに従う
- 本家 : [Download | Eclipse Mosquitto](http://mosquitto.org/download/)
- 必見: [How to Install and Secure the Mosquitto MQTT Messaging Broker on Ubuntu 16.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-ubuntu-16-04)
- [UbuntuにMosquittoをインストールしてMQTTブローカーを構築 - Qiita](https://qiita.com/kyoro353/items/b862257086fca02d3635)


本家のubuntuの項目にはクライアントとブローカのインストール方法が書いてない…

一応通しで書くと、
```
sudo apt-get install python-software-properties
sudo apt-add-repository ppa:mosquitto-dev/mosquitto-ppa
sudo apt-get update
sudo apt-get install mosquitto-clients
```

ブローカが要る場合は
```
sudo apt-get install mosquitto
```

2018-4-11では
```
$ dpkg -l mosquitto\*
||/ 名前                     バージョン        アーキテクチャ    説明
+++-========================-=================-=================-=====================================================
ii  mosquitto                1.4.15-0mosquitto amd64             MQTT version 3.1/3.1.1 compatible message broker
ii  mosquitto-clients        1.4.15-0mosquitto amd64             Mosquitto command line MQTT clients
```

# テスト

## 本家のブローカでサブスクライブのテスト

クライアントのテスト。
mosquittoがテスト用のブローカを[test.mosquitto.org](http://test.mosquitto.org/)で動かしている。

FWやproxyで遮られていないなら、
```
mosquitto_sub -t '#' -h test.mosquitto.org
```
全トピックがものすごい勢いで表示される。Ctrl+Cでとめる。


## 本家のブローカでテスト

トピックを`something/fishy`とする(アレンジして下さい)。

サブスクライブ側
```
mosquitto_sub -t something/fishy -h test.mosquitto.org -p 1883 -d
```
'-d'はデバッグオプション

パブリッシュ側
```
mosquitto_pub -t something/fishy -h test.mosquitto.org -p 1883 -m Boo!
```

```
mosquitto_pub -t something/fishy -h localhost -m "`date -R`"
```

## ローカルにテスト

ブローカもインストールした場合

[接続テスト - Qiita](https://qiita.com/kyoro353/items/b862257086fca02d3635#%E6%8E%A5%E7%B6%9A%E3%83%86%E3%82%B9%E3%83%88)



# 他のテスト

HiveMQのWebsocketクライアントで`test.mosquitto.org`につなげるか?

- [MQTT over WebSockets](http://test.mosquitto.org/ws.html)
- [MQTT Websocket Client](http://www.hivemq.com/demos/websocket-client/)


# WebSocket

/etc/mosquitto/conf.d/websokets.conf
```
listener 1883

listener 8080
protocol websockets
```
これで8080/tcpがwebsocket対応になる
```
# systemctl stop mosquitto
# systemctl start mosquitto
# tail /var/log/mosquitto/mosquitto.log
(略)
1523435117: mosquitto version 1.4.15 terminating
1523435122: mosquitto version 1.4.15 (build date Wed, 28 Feb 2018 11:29:47 +0000) starting
1523435122: Config loaded from /etc/mosquitto/mosquitto.conf.
1523435122: Opening ipv4 listen socket on port 1883.
1523435122: Opening ipv6 listen socket on port 1883.
1523435122: Opening websockets listen socket on port 8080.
```
start,stopしてるのはrestartだとなんかうまくいかなかったから。

あとは8080/tcpをFWであける。

# Websocketがうちのproxyを越えられるか

pythonでpaho-mqttを使ったテストコードを書いて、プロキシ内でも取れることを確認した。

TODO:ここにコードを書く
```
code
```

# 認証やSSL

これが超参考になる。

[How to Install and Secure the Mosquitto MQTT Messaging Broker on Ubuntu 16.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-ubuntu-16-04)

# node.js

node.jsのMQTTクライアントMQTT.js([mqtt - npm](https://www.npmjs.com/package/mqtt))を試す。

グローバルにインストールすると (かつ`nmp -b bin`にパスが通っていれば) 特にコードを書かなくても`mqtt`コマンドが使える。

```
npm -g i mqtt
```

ヘルプ
```
mqtt help subscribe
```

サブスクライブのテスト。
```
mqtt subscribe -h test.mosquitto.org -t '#'
```

Websocketでサブスクライブ
```
mqtt subscribe -h test.mosquitto.org -p 8080 -l ws -t '#'
```
proxyがあると動かない。http_proxy環境変数とかもサポートしていない。

[Is a HTTP_PROXY supported? · Issue #452 · mqttjs/MQTT.js](https://github.com/mqttjs/MQTT.js/issues/452)

MQTT.js自体にはproxyのサポートはあるが、mqttコマンドにはオプションがないらしい。

MQTT.jsのexamplesにclient_with_proxy.jsがあるので、これを参考に作る。

[MQTT.js/client_with_proxy.js at master · mqttjs/MQTT.js](https://github.com/mqttjs/MQTT.js/blob/master/examples/wss/client_with_proxy.js)

# ブラウザで

[mqtt - npm](https://www.npmjs.com/package/mqtt#browser)