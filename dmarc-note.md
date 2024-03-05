# SPF/DKIM/DMARC のメモ

SPF や DMARC はわかりやすいけど(DNS の設定だけ)
DKIM はちょっとめんどくさい(DNS と MTA の両方設定が要る)。

## 特定ドメインの DMARC/DKIM を見る

```bash
# DMARC
dig _dmarc.example.com txt

# DKIMの公開鍵
dig SELECTOR._domainkey.example.com txt
```

## DMARC サンプルと解説

## DMARC の資料

導入:

- [送信ドメイン認証 導入指南 2018](https://www.nic.ad.jp/ja/materials/iw/2017/proceedings/s12/s12-suzuki.pdf) - **「送信ドメイン認証とは、送信者がドメインを守るための技術」**
- [送信ドメイン認証技術導入マニュアル第 3.1 版](https://www.dekyo.or.jp/soudan/data/anti_spam/meiwakumanual3/manual_3rd_edition.pdf)
  - [関連資料 | 迷惑メール対策推進協議会 | 迷惑メール相談センター](https://www.dekyo.or.jp/soudan/aspc/report.html)

チェックサイト:

- [DMARC Inspector - dmarcian](https://dmarcian.com/dmarc-inspector/)
- [DKIM Inspector - dmarcian](https://dmarcian.com/dkim-inspector/)
- [SPF Surveyor - dmarcian](https://dmarcian.com/spf-survey/)
- [Check a DKIM Core Key](https://dkimcore.org/tools/keycheck.html)

Dmarc Report Analyzer:

- [DMARC Report Analyzer - DMARC Email XML Parser - MxToolbox](https://mxtoolbox.com/DmarcReportAnalyzer.aspx)
  - [DMARC 集計レポートを受信して可視化するツールを探す | DevelopersIO](https://dev.classmethod.jp/articles/dmarc-report-analyzer/)
- [DMARC/25 Analyze | TwoFive](https://www.twofive25.com/service/dmarc25.html)
- [NEC DMARC レポート分析サービス | NEC](https://jpn.nec.com/actsecure/acts_dmarcreport.html)

## Ubuntu の Postfix に DKIM の秘密鍵を設定する

- [web 帳 | Ubuntu 20.04 LTS サーバ構築 – DKIM、DMARC を設定する](https://www.webcyou.com/?p=11234)

## DKIM のセレクタは rs で始まる必要がありますか?

いいえ。

参照: [RFC 6376 の selector の節](https://datatracker.ietf.org/doc/html/rfc6376#section-3.1)。

## DKIM のテスト

DKIM のテストは結構めんどう。

DKIM(DomainKeys Identified Mail)が正しく設定されているかどうかをテストするための手順を、DNS 側と MTA(Mail Transfer Agent)側に分けて説明します。

### DNS 側のテスト手順

1. **DNS レコードの確認**
   - ドメインの DNS レコードを確認し、DKIM レコードが存在することを確認します。
   - DKIM レコードは、ドメインの TXT レコードとして保存されています。レコード名は**selector.\_domainkey.yourdomain.com**のような形式です。
2. **DKIM レコードの内容確認**
   - DKIM レコードの内容を確認して、適切な形式で設定されているかどうかを確認します。
   - DKIM レコードには、公開鍵やセレクタ、ハッシュアルゴリズム、ドメインなどが含まれます。
3. **公開鍵の確認**
   - DKIM レコードに含まれる公開鍵が正しいことを確認します。
   - 公開鍵が誤っている場合、メールの署名検証が失敗する可能性があります。

### MTA 側のテスト手順

1. **DKIM 署名の確認**
   - MTA(メール転送エージェント)が受信したメールのヘッダーを確認し、DKIM 署名が付与されているかどうかを確認します。
   - DKIM 署名は、ヘッダーの**DKIM-Signature**フィールドで指定されます。
2. **署名の検証**
   - MTA は、受信したメールの DKIM 署名を検証します。
   - 公開鍵を使って署名の検証を行い、メールが正当なものかどうかを確認します。
3. **検証の結果**
   - DKIM 署名の検証に成功した場合、メールが信頼できるものであることが確認されます。
   - 検証に失敗した場合、メールが改ざんされている可能性があります。その場合は適切な措置を講じる必要があります。
4. **DKIM エラーのログ**:
   - MTA は DKIM 検証に関するエラーを適切にログに記録し、問題がある場合にそれを報告します。
   - エラーログを確認して、設定に問題があるかどうかを判断します。

これらの手順を実行することで、DNS 側と MTA 側の両方で DKIM の設定状況を確認し、メールのセキュリティを向上させることができます。
