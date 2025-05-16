# 「メッセージ(text messaging) アプリ」のメモ

ややこしい。理解できないのも当然。

ややこしい理由:

- 通信事業者依存のメッセージアプリと TCP/IP ベースのメッセージアプリが、機能や見た目が同じで区別がつかない
- メッセージアプリのくせに「メール」を名乗るものがある
  - 「[キャリアメール](https://ja.wikipedia.org/wiki/%E3%82%AD%E3%83%A3%E3%83%AA%E3%82%A2%E3%83%A1%E3%83%BC%E3%83%AB)」の存在 (キャリアメールは日本にしか無いらしい)。この Wikipedia の記事面白いです。おすすめ
- Apple の「メッセージアプリ」は MMS,SMS を使う「メッセージ」と TCP/IP ベースの「iMessage」の両方をまとめたものだったりする。その上 iMessage は Apple の独自規格

ちょっと検索すると世界中で大混乱を観察できる。
Message+(VeVerizon Messages)から Google message (Google Jibe)の話とか。

## おおまかな分類

- 携帯電話事業者が提供するネットワークインフラと規格に基づくもの
  - SMS (Short Message Service) - 短文テキスト専用
  - MMS (Multimedia Messaging Service) - 画像や動画も送れる拡張版
  - RCS (Rich Communication Services) - チャットアプリ並みの高機能メッセージサービス
- そうでないもの
  - OTT (Over The Top App) - 通信事業者に依存しない

「携帯電話事業者が提供するネットワークインフラと規格に基づくもの」を別の言い方をすると
「電話番号(MSISDN)のあるものでしか使えない」
「携帯通信網（GSM/3G/4G/5G）を使って動作する」
ということ。

まあ普通にテクスティングする人にとっては「そんなことはどうでもいい」。

## SMS (Short Message Service)

- **定義**: SMS は「ショートメッセージサービス」の略で、携帯電話やスマートフォンの電話番号を宛先に、短いテキストメッセージ(最大 160 文字)を送受信できるサービス
- **特徴**:
  - 携帯電話番号を宛先として、短いテキストメッセージを送受信するためのサービス
  - 送信先は電話番号
  - ほぼ全ての携帯電話で利用可能
  - シンプルで信頼性が高い
  - インターネットプロトコル (IP) ではなく、携帯電話の**制御チャネル**という、通話や位置登録などに使われる回線を利用して通信を行う
  - GSM (Global System for Mobile Communications) 規格の一部として 1980 年代に開発された。ガラケーの時代から存在する。詳しくは [ショートメッセージサービス - Wikipedia](https://ja.wikipedia.org/wiki/%E3%82%B7%E3%83%A7%E3%83%BC%E3%83%88%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9)
    や、[英語版](https://en.wikipedia.org/wiki/SMS)など参照。日本では SMS がポケベルを滅ぼしたらしい
- **SMS に属するサービス・アプリ**
  - 各携帯キャリア標準の「メッセージ」アプリ(iPhone の「メッセージ」、Android の「メッセージ」など)
  - ドコモ、au、ソフトバンク、楽天モバイルの SMS 機能
  - Y!mobile や格安 SIM(MVNO)の SMS 機能

## MMS (Multimedia Messaging Service)

- **定義**: MMS は「マルチメディアメッセージングサービス」の略で、画像・動画・音声などのマルチメディアファイルをメッセージに添付して送信できるサービス
- **特徴**:
  - SMS の拡張規格
  - テキストに加え、画像・動画・音声ファイルなどを送信可能
  - 送信先は主にメールアドレスだが、同じ携帯会社間では電話番号宛も可能
  - 長文メッセージにも対応 (データ容量の上限あり)
  - 受信端末が対応していない場合は Web リンクで閲覧
  - MMS の送受信には、携帯電話の**トラフィックチャネル**という、データ通信に使われる回線が利用される。トラフィックチャネルは IP ベース。
  - インターネット技術の一部(例えば、WAP - Wireless Application Protocol など)を利用することもあるが、**本質的には携帯電話ネットワークの規格**に基づいている
- **MMS に属するサービス・アプリ**
  - ソフトバンクの「S!メール」
  - au の「@ezweb.ne.jp」メール
  - Y!mobile の「@ymobile.ne.jp」メール
  - iPhone の「メッセージ」アプリ (MMS 設定時、キャリアメールとして利用)
  - Android の標準メールアプリ (MMS 設定時、キャリアメールとして利用)
  - ※ドコモと楽天モバイルは MMS 非対応

## RCS (Rich Communication Services)

- **定義**: RCS は「リッチコミュニケーションサービス」の略で、SMS や MMS の進化版となる次世代メッセージング規格
- **特徴**:
  - 高画質画像や動画、音声、ファイルの送受信が可能
  - 既読通知や入力中表示、グループチャットなど、チャットアプリに近い機能を標準搭載
  - 電話番号を使ってやりとり
  - インターネット接続(モバイルデータや Wi-Fi)が必要
  - 日本では「+メッセージ」として大手キャリアが提供
  - セキュリティ強化(暗号化対応もあり)
  - 海外キャリアとの相互接続には制限がある場合も
  - IP ベースで通信を行うため、データ通信に使われるトラフィックチャネルを通じてメッセージやファイルなどを送受信
- **RCS に属するサービス・アプリ**
  - +メッセージ(プラスメッセージ) - NTT ドコモ・au・ソフトバンクの 3 大キャリア共同サービス
  - 楽天モバイルの「Rakuten Link」
  - Google メッセージ (Android 標準搭載、RCS 対応端末で利用可)
  - joyn (欧州で普及した RCS サービス)
  - Advanced Messaging、Message+ (海外キャリア向け RCS サービス)

### RCS 参考リンク

- [リッチコミュニケーションサービス - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%AA%E3%83%83%E3%83%81%E3%82%B3%E3%83%9F%E3%83%A5%E3%83%8B%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9)
- [RCC.07 RCS Advanced Communications Services and Client Specification Version 14.0 - Networks](https://www.gsma.com/solutions-and-impact/technologies/networks/gsma_resources/rich-communication-suite-advanced-communications-services-and-client-specification-version-14-0/)

## OTT (Over The Top) メッセージアプリ・チャットアプリ

- **定義**: 通信事業者(キャリア)やインターネットサービスプロバイダー(ISP)を介さず、インターネット回線を通じてメッセージや音声、動画などのサービスを提供するアプリやサービスを指します。「Over The Top」は「限界を超えて」という意味で、通信インフラの上に独自にサービスを展開することからこの名がついています。

- **特徴**
  - **キャリア非依存**: 携帯キャリアや ISP のサービスに依存せず、インターネット接続さえあれば利用可能
  - **マルチプラットフォーム対応**: スマートフォン、タブレット、PC など様々なデバイスで利用できる
  - **多機能**: テキストチャットだけでなく、画像・動画・音声通話・ビデオ通話・ファイル共有など幅広い機能を持つ
  - **グローバル展開**: 国やキャリアを問わず、世界中で利用できるサービスが多い
  - **独自のアカウントシステム**: 電話番号やメールアドレス、SNS アカウントなどを使ってユーザー登録・認証を行う
  - **通信事業者の「土管化」**: キャリアはインターネット接続のみを提供し、サービスの主導権は OTT 事業者が握る構造になっている
- **OTT に属するサービス・アプリ**
  - WhatsApp
  - LINE
  - Facebook Messenger
  - WeChat
  - Telegram
  - KakaoTalk
  - Viber
  - Signal
  - iMessage (Apple デバイス間)
  - Snapchat
  - Skype
  - Discord

## 例えば「プラスメッセージ」を使う場合

[+メッセージ - Wikipedia](https://ja.wikipedia.org/wiki/%2B%E3%83%A1%E3%83%83%E3%82%BB%E3%83%BC%E3%82%B8)

宛先の特定には電話番号(MSISDN をトラフィックチャンネル上で RCS の仕様で)を使います。

実際のメッセージやデータの送受信は、携帯キャリアの IMS(IP Multimedia Subsystem)基盤を通じて、TCP/IP で行われます。

この流れは「Google メッセージ」でも同じ。

RCS,MMS,SMS の使えるデバイスでのみ使用できる、ということ。

## 日本の MMS

ドコモは「i モードメール」とその後継の「SP メール」、
au は「EZweb メール」、
ソフトバンクは「S!メール」
が MMS。ただしそれぞれ独自の実装で、本物の MMS 規格 と互換が無い。

↑ これはけっこう微妙な表現。他文献も見てね。

## 世界初の SMS 受信可能なケータイ

1992 年 12 月 3 日に送信された世界初の SMS「Merry Christmas」は、
イギリスの通信事業者 Vodafone のネットワークを通じて、
Vodafone のエンジニアのニール・パップワースがコンピュータから送信し、
Orbitel 901 で受信されました。

- [SMS - Wikipedia](https://en.wikipedia.org/wiki/SMS)
- ['Merry Christmas': The 30th anniversary of the first text message](https://www.vodafone.co.uk/newscentre/features/merry-christmas-the-30th-anniversary-of-the-first-text-message/)
- [Merry Christmas - Vodafone UK News Centre](https://www.vodafone.co.uk/newscentre/tag/merry-christmas/)

受信のみなのでポケベルみたいな感じ?

## 世界初の SMS 送受信可能なケータイ

フィンランドの Nokia が 1994 年 1 月に発売した Nokia 2010 です。
Nokia 2010 で SMS を送受信できた最初の通信事業者は、
フィンランドの Radiolinja(現在の Elisa)でした。

## 中国の SMS

中国の SMS,MMS.RCS ベース(TCP/IP ベースではない)の texting アプリ

RCS を 5G Messages(5G 消息)というブランド名で展開してるらしい。
MMS は無くて SMS/RCS らしい。

アプリは

- 中国移動(China Mobile)の "5G Messages"
- Juphoon 社の "Juphoon"

らしい。
