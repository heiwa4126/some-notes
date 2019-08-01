# RHELのリリースロック

Red Hat Enterprise Linuxのバージョンを固定する話。CentOSは対象外


```
## (たまに起動するホストだと証明書が変な時があるので)
# subscription-manager repos --list-enabled
...
# subscription-manager release
リリースは設定されていません
# subscription-manager release --list
+-------------------------------------------+
          利用可能なリリース
+-------------------------------------------+
7.0
7.1
7.2
7.3
7.4
7.5
7.6
7.7
7Server
## (7ServerのSは大文字)
# subscription-manager release --set=7Server
リリースは次のように設定されています: 7Server
```