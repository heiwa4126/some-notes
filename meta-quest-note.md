# Meta Quest のメモ

## Meta Quest のはじめかた

Meta Quest 3 はここ ↓ から。2, pro は左ペインから選ぶ

- [Meta Quest 3 のセット内容](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-3/quest-3-in-the-box/)
- [Meta Quest 3 を設定する](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-3/set-up-quest-3/) - この動画は先に見といたほうがいいです。

まず最初にモバイルデバイス(**必須**。iOS か Android)
を用意して app をインストール

- [「Meta Quest」を App Store で](https://apps.apple.com/jp/app/meta-quest/id1366478176)
- [Meta Quest - Google Play のアプリ](https://play.google.com/store/apps/details?id=com.oculus.twilight&hl=ja&gl=US)

App 起動すると
Mata account を作る必要がある。これは Facebook アカウントや Instagram アカウントとは別管理。だけど、Facebook や Instagram で OAuth はできる。

次に

- ヘッドセットのバンドの調整(
  [Meta Quest 3 のフィット感を調整する](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-3/adjust-fit-feel-quest-3/))
- ヘッドセットを起動し(スリープボタン長押し。メタのマークが Y 軸で回転する)、
- コントローラの電池タブを引き抜く動画
- レンズ間隔調整、
- WiFi の設定、
- そのあと問題のペアリング。

「ペアリング」は Bluetooth じゃない。
同一 LAN 内にあるデバイスを探してる?
もしくはロケーションの near by?
ルータの設定によってハマる可能性はありそう。

あとは App のガイド
およびヘッドセットのガイドに従えば
なんとかなる。ならない場合はお手上げみたい。

ごちゃごちゃやってる間に、Meta Quest 本体のアップデートとコントローラのアップデートが降ってくるので、再起動
[Meta Quest ヘッドセットを再起動する](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-2/restart-oculus-quest-2/)

長い USB ケーブルは用意しといたほうがいい。**電池がすぐなくなる**。
純正は
[Quest Link ケーブル](https://www.meta.com/jp/quest/accessories/link-cable/)。
バカ高いので、Ali Express や TEMU などで安く手に入るコピー品で十分
だと思う(推奨するものではありません)。微妙にヤバい 2 口のケーブルもある。
ついでにチープなケースも注文するといいです
(推奨するものではありません)。

[Meta Quest 3 の LED インジケーターの色](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-3/led-indicators-quest-3/) - 側面 LED と正面 LED

これが最初から付いてるので練習する:

- [Meta Quest の「First Hand 」| Quest VR ゲーム | Meta Store](https://www.meta.com/ja-jp/experiences/5030224183773255/)
- [Meta Quest の「First Encounters 」| Quest VR ゲーム | Meta Store](https://www.meta.com/ja-jp/experiences/6236169136472090/)
- [Meta Quest の「はじめての Quest 2 」| Quest VR ゲーム | Meta Store](https://www.meta.com/ja-jp/experiences/3675568169182204/)

(2024 年初頭まで "Asgard's Wrath 2" も付いてた)

他 MR の SDK のショーケース
[Meta Quest の「Discover 」| Quest VR ゲーム | Meta Store](https://www.meta.com/ja-jp/experiences/7041851792509764/)

## 買ったコンテンツの一覧

[マイ Quest コンテンツ](https://secure.oculus.com/my/quest/)

デバイスにダウンロード済みかどうかもわかるといいんだけど。

## ストレージの空き容量

(未確認)

クイック設定 \> 設定(歯車アイコン) \> ストレージ

[Meta Quest 3 の使いかたに関する Tips | XR メモランダム](https://orecen.com/x-reality/meta-quest3-settings-tips/)

## 買ったばかりのデバイスが未保障になる

https://www.meta.com/my/devices/ で
「あなたのデバイスは有効な保証の対象外であるか、保証の期限が切れています。」
と表示される場合。

デバイスのアクティベート後 7 日後に表示が反映されるそうです。
すごいぞ Meta の技術力。

## SDK

(Oculus Rift を除外した場合。
Oculus Rift のは[PC SDK | Oculus 開発者](https://developer.oculus.com/documentation/native/pc/pcsdk-intro/)
)

3 種類あるらしい。

- Unity SDK
- Unreal Engine SDK
- Android SDK (「ネィティブ」) - OpenXR 必須。昔は「モバイル SDK」というのがあったらしい。

このへんから参照

- [Oculus Quest プラットフォーム向け開発のスタートガイド | Oculus 開発者](https://developer.oculus.com/quest/) - 古い。英語版参照
- [Device Setup \| Oculus Developers](https://developer.oculus.com/documentation/native/android/mobile-device-setup/)
- [VR Development Pathway - Unity Learn](https://learn.unity.com/pathway/vr-development)

で MR 用には

- [Meta XR Utilities SDK | 機能統合 | Unity Asset Store](https://assetstore.unity.com/packages/tools/integration/meta-xr-utilities-sdk-261898?locale=ja-JP)
-

## Quest Link と Air Link

要は「有線」と「無線」。両方とも PC にしかつながらない。モバイル機器は

- Quest Link - USB ケーブルを使用して Meta Quest を PC に接続する機能。[Set up Meta Quest Link | Meta Store](https://www.meta.com/ja-jp/help/quest/articles/headsets-and-accessories/oculus-link/set-up-link/)。有線なので安定しているが、ケーブルが邪魔。
- Air Link - Wi-Fi を使用して Meta Quest を PC に接続する機能。[Connect Meta Quest to your PC over Wi-Fi with Air Link | Meta Store](https://www.meta.com/ja-jp/help/quest/articles/headsets-and-accessories/oculus-link/connect-with-air-link/)

[Meta Store ヘルプセンター | Meta Store](https://www.meta.com/ja-jp/help/quest/articles/headsets-and-accessories/oculus-link/)

## コントローラーにニッケル水素電池は使えない?

Touch Plus コントローラーのバッテリーカバーには
「単三形リチウムイオン電池のみ使用してください」
と書いてあるらしい。(真偽不明)

「1.5V の単三形リチウムイオン電池」が何か怪しい感じがする。

## Meta Quest 3 のオーディオジャックは...

出力だけ。マイクなし。
(Meta Quest 3 はマイク内蔵)

## ジェスチャーコントロール(Hand Tracking) と ダイレクトタッチ(Direct Touch)

> ダイレクトタッチは、私たちのハンドトラッキング技術を大きく改善し、システムや 2D パネル全般をより直感的で魅力的な方法で操作できるようになりました。First Hand"の最新バージョンで試すことができます。

[Use Your Fingers (Not Controllers) to Swipe Through the VR Interface on Meta Quest | Meta](https://about.fb.com/news/2023/02/meta-quest-direct-touch-use-your-fingers-in-vr/)

- [Direct Touch on Meta Quest](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-3/direct-touch-quest-3/)
- [Meta Quest ヘッドセットでジェスチャーコントロールを使用する | Meta Store](https://www.meta.com/ja-jp/help/quest/articles/headsets-and-accessories/controllers-and-hand-tracking/hand-tracking/)
- [ジェスチャーコントロールとボディトラッキングに関するプライバシー通知](https://www.meta.com/ja-jp/help/quest/articles/accounts/privacy-information-and-settings/hand-tracking-privacy-notice/)

コントローラを「平らなところに」置くことでジェスチャーモードに切り替えるように設定できる。どうやってそれを検出してるのか。「動きがなくなったら」ってことか?

「両コントローラーの側面を同時にダブルタップ」でも切り替わる。
コントローラーのいずれかのボタンを押せばコントローラーに戻る。

## ダブルタップでパススルー

まず機能を有効にする必要がある。クイック設定 \> 物理的空間 \>パススルー \> ダブルタップでパススルーの横の切り替えボタン

タップする場所と間隔がわかりにくい。コツがいる。本体のガイドに動画があるので 100 回見る。

- [\[ダブルタップでパススルー\]をオンにする](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-pro/full-color-passthrough/)
- [【Quest】超便利!! パススルー(外との画面切り替え)のやり方&ショートカット](https://ichioshi-life.com/2020/11/26/passthrough/)
- [Oculus Quest2 で簡単にパススルーを実行する方法 - VR PEAK](https://vr-peak.blog/how-to-perform-passthrough-in-oculus-quest-2/)

## Meta Quest 3 の音量ボタンはどちらが音を大きくする方?

調べる

## TIPS のリンク

[【50 項目以上】メタクエストの機能・設定・小ネタまとめ](https://orentame.com/metaquest-knowledge/)
