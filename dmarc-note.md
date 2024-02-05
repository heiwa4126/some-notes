# SPF/DKIM/DMARC のメモ

## 特定ドメインの DMARC を見る

```bash
dig _dmarc.example.com txt
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
