# Amazon SageMaker Studio Lab のメモ

## 特徴 & 感想

- AWS の普通のアカウントとは別管理
- いちおう無料。メールアドレスと電話番号(最初に start runtime を押すときにきかれる)が必要
- アカウントの申し込み → メールアドレスの確認 → ウエイティングリストに登録 → (約一日) → 本登録(メールアドレス、パスワード、ユーザ名)
- CAPTCHA がけっこうウザい。なんか無茶な使い方をした奴がいたんだろう
- ブラウザで
  ポップアップの解除と
  ターミナルでコピペの許可と
  `*.awswaf.com`(AWS WAF) をトラスティッドドメインに追加する必要あり
- Jupyter が Colab と比べると使いにくい。右クリックでプルダウンメニューが多い感じ
- `%conda` は死ぬほど遅い(たぶんバグ) ので、Linux の lib パッケージが必要なやつ(`matplotlib`など)以外は `%pip`

## FAQ から抜粋

[SageMaker Studio Lab - FAQ](https://studiolab.sagemaker.aws/faq)

### Q: SageMaker Studio Lab ではどのようなインスタンスタイプを使用していますか?

変更される可能性がありますが、現在は
GPU に G4dn.xlarge インスタンス、
CPU に T3.xlarge インスタンス
を使用しています。

参考: [料金 - Amazon SageMaker | AWS](https://aws.amazon.com/jp/sagemaker/pricing/#Pricing_examples)

### Q: ストレージとメモリの容量は? もっと必要な場合は?

プロジェクトには 15 GB の永続ストレージと 16 GB の RAM が割り当てられています。追加のストレージや計算リソースが必要な場合は、Amazon SageMaker Studio への切り替えをご検討ください。

### Q: コンピュート・リソースに制限はありますか?

プロジェクトのランタイムを開始するたびに、CPU か GPU のどちらかを選択できます。

CPU ランタイムは、1 セッションあたり 4 時間まで、24 時間の合計が 8 時間を超えないように制限されています。

GPU ランタイムは、1 セッションあたり 4 時間に制限され、24 時間の合計が 4 時間を超えないようにします。

セッション時間の制限に達すると、すべてのファイルが永続プロジェクト・ストレージに保存され、ランタイムはシャットダウンします。
1 日の制限時間に達していない場合は、プロジェクト・ランタイムを再起動することができます。
CPU または GPU ランタイムの可用性は保証されておらず、需要に左右されます。
標準的なユーザーインターフェイスを超える方法でコンピュートへのアクセスを試みると、アカウントが停止、ブロック、または削除される場合があります。

### Q: 携帯電話番号を持っていない場合はどうなりますか？

携帯電話番号をお持ちでないお客様は、SageMaker Studio Lab でランタイムを開始することができません。

### Q: オープンソースの Python パッケージはどのようにインストールできますか？

Python パッケージをインストールするには、次のようにします

`%pip install <パッケージ>`

または

`%conda install --yes <パッケージ>`

を使うことができます。**必ず '!pip' や '!conda' ではなく、この形式（'%'付き）を使ってください。**
'%'を使うことで、パッケージを正しいパスにインストールすることができます。

## トラスティッドドメインへの追加

Firefox だと `network.negotiate-auth.trusted-uris` で検索すると手順が出てくる。

ほかのブラウザは OS で設定らしいが試してない(TODO)

## Open in Studio Lab ボタンの設置方法

[Open in Studio Lab ボタンの設置方法](https://github.com/aws-sagemaker-jp/awesome-studio-lab-jp/blob/main/README_button.md)

## 参考リンク

- [GitHub - aws/studio-lab-examples: Example notebooks for working with SageMaker Studio Lab. Sign up for an account at the link below!](https://github.com/aws/studio-lab-examples)
- [GitHub - aws-sagemaker-jp/awesome-studio-lab-jp: SageMaker Studio Lab の教材を紹介するリポジトリ。](https://github.com/aws-sagemaker-jp/awesome-studio-lab-jp)
