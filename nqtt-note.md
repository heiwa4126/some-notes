MQTTの実験をする

MQTT参照実装のMosquittoを使う。

ver1.4.2以降(2016頃)からWebsocket対応らしい。

[Installing Mosquitto MQTT broker on Raspberry Pi (with websockets) | xperimentia](https://xperimentia.com/2015/08/20/installing-mosquitto-mqtt-broker-on-raspberry-pi-with-websockets/)

[mosquittoでMQTTとWebSocket両方に対応させる - 人と技術のマッシュアップ](http://tomowatanabe.hatenablog.com/entry/2016/01/21/095007)


# インストール

このへんに従う
- 本家 : [Download | Eclipse Mosquitto](http://mosquitto.org/download/)
- [UbuntuにMosquittoをインストールしてMQTTブローカーを構築 - Qiita](https://qiita.com/kyoro353/items/b862257086fca02d3635)

本家のubuntuの項目にはクライアントとブローカのインストール方法が書いてない…

```
sudo apt-get install mosquitto-clients
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

ローカルにテスト

[接続テスト - Qiita](https://qiita.com/kyoro353/items/b862257086fca02d3635#%E6%8E%A5%E7%B6%9A%E3%83%86%E3%82%B9%E3%83%88)

よそのブローカでテスト

[test.mosquitto.org](http://test.mosquitto.org/)

サブスクライブ側
```
mosquitto_sub -t something/fishy -h test.mosquitto.org -p 1883 -d
```
'-d'はデバッグオプション

発信側
```
mosquitto_pub -t something/fishy -h test.mosquitto.org -p 1883 -m Boo!
```

```
mosquitto_pub -t something/fishy -h localhost -m "`date -R`"
```

# 他のテスト

HiveMQのWebsocketクライアントで`test.mosquitto.org`につなげるか?

[MQTT over WebSockets](http://test.mosquitto.org/ws.html)
[MQTT Websocket Client](http://www.hivemq.com/demos/websocket-client/)


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

pythonでpaho-mqttを使ったテストコードを書いて、社内でも取れることを確認した。

Node.jsとAMDでも



