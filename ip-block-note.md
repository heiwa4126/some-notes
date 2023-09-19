# ブロックリストの入手先

[Create an Access Control List to Block Countries or Continents](https://www.countryipblocks.net/acl.php)

ただ「中国とロシア」とか選ぶと3万件もリストがでるので現実的かどうかはわからん。
やるなら上流のルーターとかクラウドとかかな...

というか「ホワイトリスト」だな普通は。

AWSでもAzureでも簡単にできるみたい。

- [AWS WAFで特定の国からのアクセスをブロックしてみた | DevelopersIO](https://dev.classmethod.jp/articles/aws-waf-country-block/)
- [Azure Web アプリケーション ファイアウォール (WAF) の Geomatch カスタム ルール | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/web-application-firewall/ag/geomatch-custom-rules)
