# EMV コンタクトレス

[EMV - Wikipedia](https://en.wikipedia.org/wiki/EMV)

マークは

- 楕円の中に WiFi を横、チップを持つ手 (端末側ロゴ)
- WiFi を横 (カード側ロゴ)

にしたやつ。

ロゴの画像は

- PDF [EMVCo Contactless Symbol Guidelines 2012](https://www.emvco.com/wp-content/uploads/2022/10/EMVCo-Contactless-Symbol-Reproduction-Requirements-Oct-2019.pdf)
- [NFC Logos – AtaDistance](https://atadistance.net/2018/08/13/nfc-logos/)
- [商標センター | EMVCo](https://www.emvco.com/trademark-centre/)

を参照。

EMV コンタクトレスのカードは各社ブランド名をつけてて

- Mastercard Contactless
- Visa Contactless または Visa Tap to Pay (Visa タッチ決済)
- JCB Contactless (JCB コンタクトレス)
- American Express Contactless (アメリカン・エキスプレス・コンタクトレス)
- Diners Club Contactless
- Discover Contactless または Discover Zip
- UnionPay QuickPass (銀聯クイックパス)

これらは全部 EMV コンタクトレス。

で、
[Apple Pay が使える場所について - Apple サポート (日本)](https://support.apple.com/ja-jp/120364)

> 日本では、EMV 非接触型決済マークが表示されているところで Apple Pay を使えます。
> 以下のロゴのいずれかがある場合も、Apple Pay で支払うことができます。

には EMV コンタクトレスマークが書いてある。
iPhone をコンタクトレスのクレジットカードとして使用することが可能。

[使えるカード - Google Pay(日本)](https://pay.google.com/intl/ja_jp/about/card-lineup/)

つまり

- 「コンタクトレスのクレジットカード」が使える場所
- 「クレジットカード会社のコンタクトレスブランド」が使える、と書いてある場所
- EMV コンタクトレス端末側シンボルが書いてある場所

で ApplePay/GooglePay は EMV コンタクトレスカードとして使用できる。

これなんでこんなにややこしいの?
なぜ同じものを全部別の名前で表記しなければならないの?
知らないの自分だけ?

## contactless でない非接触のクレジットカードを Apple Pay に取り込み、このクレジットカードを iPhone 上で EMV コンタクトレスとして使用できますか?

これに関しては確実な情報が無い。おおむね出来そうらしい。

でも明らかにできないカードもあるらしくて、
[Apple Pay でタッチ決済が使えない|クレジットカードはライフカード](https://help.lifecard.co.jp/Apple%20Pay%E3%81%A7%E3%82%BF%E3%83%83%E3%83%81%E6%B1%BA%E6%B8%88%E3%81%8C%E4%BD%BF%E3%81%88%E3%81%AA%E3%81%84-6705d424f441be001d244a8e)

このへんは Visa Contactless との互換性の問題らしいので、現時点では解消されてるらしい。

[Apple Pay に対応しているアジア太平洋地域の銀行とカード発行元 - Apple サポート (日本)](https://support.apple.com/ja-jp/102897)

組み合わせによっていろいろあるけど、
アメックスはおおむねダメで、
JCB などにまれにダメな場合があるらしい。

## JCB はなぜ QUICPay と EMV contactless の両方をやっているの?

SMS と同じようなネタ。Felica 上の QUICPay の方が先輩らしい。

Felica ベース。

- [QUICPay - Wikipedia](https://ja.wikipedia.org/wiki/QUICPay)
- JCB Contactless - [カードをかざす | JCB ブランド](https://www.jcb.jp/variety/contactless/)

## EMVCo は他にも

EMVCo の QR コード。
PayPay みたいのの共通規格。
アジアでは国家標準になってる国がずいぶんある。
[EMV QR Code - ナムウィキ](https://ja.namu.wiki/w/EMV%20QR%20Code)

まああんまり流行ってないみたい。
いや UnionPay QR はけっこう流行ってるみたい。

Mastercard の QR コードのブランド名は Masterpass

- [Masterpass: Learn More](https://www.mastercard.com/mc_us/wallet/learnmore/ja/JP/)
- [Masterpass | Mastercard Developers](https://developer.mastercard.com/product/masterpass/)

他 EMVCo Click to Pay

## ほか参考

[EMVCo Marks – What and Why? | EMVCo](https://www.emvco.com/knowledge-hub/emvco-marks-what-and-why/)

決済系の NFC 規格として、世界的に「EMV コンタクトレス(Type-A/B)」と「FeliCa(Type-F)」が主に使われていますが、この他に決済用途でメジャーな規格はほとんどありません。

**主な NFC 決済規格の概要**

| 規格名                        | 主な用途・特徴                                                                  | 主な利用地域         |
| ----------------------------- | ------------------------------------------------------------------------------- | -------------------- |
| EMV コンタクトレス (Type-A/B) | 国際ブランド決済(Visa, Mastercard など)、Apple Pay, Google Pay など             | 世界中               |
| FeliCa (Type-F)               | 日本の交通系 IC カード(Suica, PASMO)、電子マネー(Edy, nanaco, iD, QUICPay など) | 日本、一部アジア地域 |
| ISO/IEC 15693                 | 決済ではなく、主に物流や商品管理用の RFID タグ                                  | 世界中               |

**その他の規格について**

- **Type-A/B(EMV コンタクトレス)** は、決済用途で世界的に最も普及している規格です[7][9][10]。
- **ISO/IEC 15693**は NFC 関連規格ですが、決済には利用されていません[10]。
- **その他**、NFC 規格として Type-A/B/F(FeliCa)以外にも細かな規格は存在しますが、決済用途で「メジャー」と言えるものはありません。

NFC のこともっと調べる。

Type-A/B/F は NFC の通信規格のうち物理層や下位レイヤーの通信方式・プロトコル。
無線通信の物理的な方式(変調方式・符号化方式)など。

これに加えて「タグ仕様」があり、
(Type-1/2/3/4 など)
これは、
NFC タグが持つ「データの格納や読み書きの仕方、セキュリティや容量」などのルールを定めたもの。
