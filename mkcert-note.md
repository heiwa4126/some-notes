# mkcert のメモ

- [FiloSottile/mkcert: A simple zero-config tool to make locally trusted development certificates with any names you'd like.](https://github.com/FiloSottile/mkcert)
- [Ubuntu Manpage: mkcert - zero-config tool to make locally trusted certificates](https://manpages.ubuntu.com/manpages/noble/en/man1/mkcert.1.html)
- [Chocolatey Software | mkcert 1.4.4](https://community.chocolatey.org/packages/mkcert)

HTTPS でないとダメな API とかを開発するとき。

ブラウザを動かす OS の上に mkcert をインストールして `mkcert -install` を実行するのが楽。

たとえば WSL2 で開発してるなら、Windows 上で

```powershell
# Windows に mkcert をインストール
sudo choco install mkcert

# Windows の system trust store と Firefox(あれば) に CAの証明書をインストール
sudo mkcert -install
## WindowsではFirefoxは未サポートらしい。`mkcert -CAROOT`でpemみつけて手動でやる。

# localhost用の証明書と鍵ファイルをカレントディレクトリにつくる
mkcert localhost
```

で、出来た .pem ファイル 2 個を WSL にコピーして使いまわす。

このケースだと
Playwright の headless なんかはどちらで動くのか...

`mkcert -CAROOT` で CA 鍵の場所を表示できるので、これを WSL 側に設定する。
Node なら `export NODE_EXTRA_CA_CERTS="/path/to/your/rootCA.pem"`でできるけど
Python だと辛いかも。

## localhost だけ 特例で http:(wss:)でいい API 等

- [Secure contexts - Security on the web | MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts)
- [Features restricted to secure contexts - MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts/features_restricted_to_secure_contexts)

多くのブラウザ API や Web プラットフォーム機能は、通常 HTTPS(または WSS)で提供される「セキュアコンテキスト」でのみ利用可能ですが、開発利便性のために「localhost」や「127.0.0.1」などローカルホストでは例外的に許可される場合があります。

| 機能・API                   | HTTPS 必須 | localhost 例外 | 備考                            |
| --------------------------- | :--------: | :------------: | ------------------------------- |
| Service Workers             |     〇     |       〇       | `localhost`/`127.0.0.1`で利用可 |
| Cookie 属性 `Secure`        |     〇     |       〇       | `localhost`で`Secure`属性付き可 |
| Cookie 属性 `SameSite=None` |     〇     |       〇       | `localhost`で`Secure`属性付き可 |
| Web Push API                |     〇     |       〇       | `localhost`で利用可             |
| Geolocation API             |     〇     |       〇       | `localhost`で利用可             |
| Web Bluetooth API           |     〇     |       〇       | `localhost`で利用可             |
| WebUSB API                  |     〇     |       〇       | `localhost`で利用可             |
| Clipboard API (書き込み)    |     〇     |       〇       | `localhost`で利用可             |
| Notification API            |     〇     |       〇       | `localhost`で利用可             |
| WebRTC(getUserMedia など)   |     〇     |       〇       | `localhost`で利用可             |

あと OAuth のコールバックも localhost を例外にしているプロバイダが多い。

## 逆に http://localhost が例外になっていないサービスは?

| API / 機能名            | 説明                                                           | MDN リンク                                                                                        |     |
| ----------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | --- |
| **Clipboard API**       | `navigator.clipboard.writeText()` などのクリップボード操作は、 | [Clipboard API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard_API)             |     |
| **Web Crypto API**      | 暗号化や署名などの機能を提供。                                 | [Web Crypto API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)           |     |
| **Web Bluetooth API**   | ブルートゥースデバイスとの通信を可能にする API。               | [Web Bluetooth API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API)     |     |
| **Web MIDI API**        | MIDI デバイスとの通信を可能にする API。                        | [Web MIDI API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Web_MIDI_API)               |     |
| **Web NFC API**         | NFC デバイスとの通信を可能にする API。                         | [Web NFC API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API)                 |     |
| **WebHID API**          | HID デバイスとの通信を可能にする API。                         | [WebHID API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API)                   |     |
| **Web Serial API**      | シリアルデバイスとの通信を可能にする API。                     | [Web Serial API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Web_Serial_API)           |     |
| **WebUSB API**          | USB デバイスとの通信を可能にする API。                         | [WebUSB API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebUSB_API)                   |     |
| **Payment Request API** | 支払いリクエストを処理する API。                               | [Payment Request API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Payment_Request_API) |     |
| **Screen Capture API**  | 画面のキャプチャを可能にする API。                             | [Screen Capture API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Screen_Capture_API)   |     |
| **Idle Detection API**  | ユーザーのアイドル状態を検出する API。                         | [Idle Detection API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/Idle_Detection_API)   |     |
| **WebCodecs API**       | メディアのエンコード/デコードを行う API。                      | [WebCodecs API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebCodecs_API)             |     |
| **WebGPU API**          | GPU アクセラレーションを利用する API。                         | [WebGPU API - MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API)                   |     |
