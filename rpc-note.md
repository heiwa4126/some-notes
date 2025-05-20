# RPC のメモ

- [Remote procedure call - Wikipedia](https://en.wikipedia.org/wiki/Remote_procedure_call)
- [遠隔手続き呼出し - Wikipedia](https://ja.wikipedia.org/wiki/%E9%81%A0%E9%9A%94%E6%89%8B%E7%B6%9A%E3%81%8D%E5%91%BC%E5%87%BA%E3%81%97)

## 「RPC は何の上で動く?」

トランスポート層(通信経路)は本質的には問わない。つまり、理論上は「なんでもいい」と言える。

とはいうものの「主に」というのはあって、例えば
JSON-RPC はプロトコル非依存であり、TCP/IP 直結、HTTP(S)、WebSocket など、さまざまなトランスポート層で動作する。

tRPC は他に UDP や MQTT なんかでも動かす例がある。

gRPC は主に HTTP/2 上
