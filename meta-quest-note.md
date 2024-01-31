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
Mata account を作る必要がある。これは Facebook アカウントや Instagram アカウントとは別管理。だけど、Facebook や Instagram で OAuth(OpenID connect?) はできる。

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

- [Meta Quest の「First Hand 」| Quest VR ゲーム | Meta Store](https://www.meta.com/experiences/5030224183773255/)
- [Meta Quest の「First Encounters 」| Quest VR ゲーム | Meta Store](https://www.meta.com/experiences/6236169136472090/)
- [Meta Quest の「はじめての Quest 2 」| Quest VR ゲーム | Meta Store](https://www.meta.com/ja-jp/experiences/3675568169182204/)

(2024 年初頭まで "Asgard's Wrath 2" も付いてた)

他 MR の SDK のショーケース
[Meta Quest の「Discover 」| Quest VR ゲーム | Meta Store](https://www.meta.com/ja-jp/experiences/7041851792509764/)

また Web ベースの VR ゲームもけっこうある

(TODO)

## 買ったコンテンツの一覧を見る

[マイ Quest コンテンツ](https://secure.oculus.com/my/quest/)

デバイスにダウンロード済みかどうかもわかるといいんだけど。

## ストレージの空き容量

クイック設定 \> 設定(歯車アイコン) \> ストレージ

[Meta Quest 3 の使いかたに関する Tips | XR メモランダム](https://orecen.com/x-reality/meta-quest3-settings-tips/)

## 買ったばかりのデバイスが未保障になる

[デバイス | Meta Store](https://www.meta.com/my/devices/) で
「あなたのデバイスは有効な保証の対象外であるか、保証の期限が切れています。」
と表示される。

デバイスのアクティベート後 7 日後に表示が反映されるそうです。
すごいぞ Meta の技術力。

→ その後無事に更新されました。「7 日」ではなく土日にバッチ処理とからしい(真偽不明)。

## Meta Quest Link と Air Link

要は「有線」と「無線」。両方とも PC につなぐ話 (モバイルではない)。

- Meta Quest Link - USB ケーブルを使用して Meta Quest を PC に接続する機能。[Set up Meta Quest Link | Meta Store](https://www.meta.com/ja-jp/help/quest/articles/headsets-and-accessories/oculus-link/set-up-link/)。有線なので安定しているが、ケーブルが邪魔。Oculus Link の改称らしい。
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

## 「ダブルタップでパススルー」

まず機能を有効にする必要がある。
クイック設定 \> 物理的空間 \>パススルー \> ダブルタップでパススルーの横の切り替えボタン

タップする場所と間隔がわかりにくい。コツがいる。
本体のガイドに動画があるので 100 回見る。
→ 3 回ぐらいであっさり慣れた。

- [\[ダブルタップでパススルー\]をオンにする](https://www.meta.com/ja-jp/help/quest/articles/getting-started/getting-started-with-quest-pro/full-color-passthrough/)
- [【Quest】超便利!! パススルー(外との画面切り替え)のやり方&ショートカット](https://ichioshi-life.com/2020/11/26/passthrough/)
- [Oculus Quest2 で簡単にパススルーを実行する方法 - VR PEAK](https://vr-peak.blog/how-to-perform-passthrough-in-oculus-quest-2/)

## Meta Quest 3 の音量ボタンはどちらが音を大きくする方?

ヘッドセットの下、鼻の穴の向かって右側にボリュームがある。

右が音量 UP。

ヘッドセットをかぶっていれば UI が見えるので間違えないが、
他人のかぶったヘッドセットを調整する時ちょっとめんどう。

## スクリーンショット

右コントローラのメタボタンを押しながら(長押しではない)、
右コントローラのトリガーを押す。

同様に
右コントローラのメタボタンを押しながら(長押しではない)、
右コントローラのトリガーを長押しで動画撮影開始。
同じアクションで撮影終了。

右目か左目の表示が撮影できる。

先にカメラアプリを起動して、設定を確認しておくと良い。

以下の FAQ は翻訳まちがい。英語の方はあってる。
[Meta Quest ヘッドセットでスクリーンショットを撮影する](https://www.meta.com/ja-jp/help/quest/articles/in-vr-experiences/social-features-and-sharing/take-a-screenshot-oculus/)

画像・ビデオはヘッドセット内に保存される。USB ケーブルなどで PC に持ってこれる(未確認)。
[写真や動画を Meta Quest ヘッドセットからコンピューターに転送する](https://www.meta.com/ja-jp/help/quest/articles/headsets-and-accessories/using-your-headset/transfer-files-from-computer-to-headset/)

## TIPS のリンク

- [【50 項目以上】メタクエストの機能・設定・小ネタまとめ](https://orentame.com/metaquest-knowledge/)
- [Pocket - 13 Tips & Tricks for New Quest 3 Owners](https://getpocket.com/read/3951602015)

視点リセット - Meta/Oculus ボタンを長押し

## アプリのレビューに 25%引きの紹介コードが

ある時がある。
星 5 つでフィルタして、下のページャーで最後のレビューへ行くと見つかることが多い。

なぜか
`https://www.oculus.com/appreferrals/...`
の形式が多い。あやしい。

## アプリの返金ポリシー

[Meta Quest/Rift コンテンツ購入代金返金ポリシー | Meta Quest | Meta Store](https://www.meta.com/jp/ja/legal/quest/quest-rift-content-refund-policy/)

14 日以内に購入したコンテンツで、**2 時間未満**プレイした場合に返金。

自動返金の対象外となるコンテンツは:

- 映画
- バンドル
- アプリ内購入

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

## コントローラのパワーオフ

「コントローラを平らなところに置く」とパワーが切れる。
つまり動かさないとパワーオフらしい。

ボタンを押すとパワーオン。持ち上げるだけでもいいみたい。

では乗り物などで運搬だとどうなる?
たぶん本体が sleep か off または非リンク状態だと
コントローラはオンにならないんだと思うけど。

## センサー

Meta Quest には

- ヘッドセットの位置と向き (6DoF)
- 左右コントローラーの位置と向き (光学式モーショントラッキング 6DoF)

の 3 種類のセンサーがあり、
それに加えてハンドトラッキング・ボディトラッキングが補助的に使える感じ。

コントローラに関しては「コントローラ周囲から IR を発して、それをヘッドセットのカメラで処理」しているらしい。でも内部にモーションセンサーがあるような気がする。

オリジナルの Oculus Touch コントローラーは「トラッキングリング」がついていて、上記の通りの動作。Meta Quest 3 のコントローラはリングがなく IR の一部が手で隠れる。CV で手のモデルトラッキングさせることでそれを補っている。

引用元: [Beat Saber founder on Quest 3 controller tracking: "It's good, don't worry"](https://mixed-news.com/en/quest-3-controller-tracking-quality/)

とりあえず Meta Quest では
頭の位置と回転、
左右の拳の位置と回転
しかセンスできてない。

もちろん[モーションキャプチャスーツ](https://www.google.com/search?q=motion+capture+suits&tbm=isch&source=lnms)や、足首にセンサーつければデータはとれるんだろうけど、

- コンシューマ製品として価格が問題
- コンシューマ製品として「装着が困難なもの」はどうなの?

なのでこのインプットからどんなゲームをデザインするかが問題となる。

フィットネスアプリの
[LES MILLS BODYCOMBAT](https://www.meta.com/experiences/4015163475201433/)だと腿上げのトレーニングがあって、
これをうまいこと左右の手のセンサーだけで処理してる。

ボタンと併用する方法もありうるけど

- ヘッドセットつけてるとボタンが見えない。A/B ボタンよく押し間違える
- なにより直感的でない。せいぜいトリガーボタンとグリップボタン

Meta Quest 3 に付いてた
[Asgard's Wrath 2](https://www.meta.com/ja-jp/experiences/2603836099654226/)
がそういった意味で操作が難しくて。ボタン操作多すぎ。あと 3D 酔。
慣れたらまたやる。

## 3D 酔い (VR motion sickness)

[Asgard's Wrath 2](https://www.meta.com/ja-jp/experiences/2603836099654226/)

- 平面を移動するのはどの方向でも平気
- スムースでない回転で少し酔う(たぶんスムースな回転だともっと酔う)
- 階段。登りでも下りでもめちゃめちゃ酔う。例えばローラーコースタのビデオと同種。

傾向がわかりやすいなあ。原因も予想がつく。

[First Hand](https://www.meta.com/experiences/5030224183773255/)
に出てくるテレポートだと高低差があっても酔わない。

## クラウドバックアップ

- [クラウドバックアップについて](https://www.meta.com/ja-jp/help/quest/articles/in-vr-experiences/oculus-features/cloud-sync/)
- [クラウドバックアップ](https://secure.oculus.com/my/cloud-backup/)

> クラウドバックアップを有効にすると、デバイスのアプリデータ(アプリの進行状況やアプリ設定など)がクラウドにバックアップされます。

## VR を人に伝えるのは難しい

LES MILLS XR DANCE に関する下の動画 2 つ

- https://twitter.com/LuismiLorente/status/1735298605911814341
- https://twitter.com/Laser_Cowboy11/status/1735670437936275757

下のは酔う。でもヘッドセットかぶってる人自体は楽しいわけで。
