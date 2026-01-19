Chromebook メモ

# ChromebookのLinuxを更新する

- [Upgrading Crostini to Debian Buster (10) | Keith I Myers](https://kmyers.me/blog/chromeos/upgrading-crostini-to-debian-buster-10/)

キモは

“chrome://components”で cros-termina の更新を試みる。

で、

```sh
cd /opt/google/cros-containers/bin/
sudo ./upgrade_container
```

の部分。

- [Chromebook で動かしているCrostiniコンテナをDebian 10 にアップグレードしよう | by Letticia | Medium](https://medium.com/@m31mac/chromebook-%E3%81%A7%E5%8B%95%E3%81%8B%E3%81%97%E3%81%A6%E3%81%84%E3%82%8Bcrostini%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E3%82%92debian-10-%E3%81%AB%E3%82%A2%E3%83%83%E3%83%97%E3%82%B0%E3%83%AC%E3%83%BC%E3%83%89%E3%81%97%E3%82%88%E3%81%86-42369f5246fd)
- [(1) Yoshikazu AoyamaさんはTwitterを使っています 「/opt/google/cros-containers/bin/upgrade_container を見ると、単にapt-get dist-upgradeしてるだけっぽいな。 そりゃそうか。」 / Twitter](https://twitter.com/blauerberg/status/1286195586442526720)
- [Chrome OS の Debian を 10 にアップグレードする [みちのぶのねぐら 工作室]](https://michinobu.jp/tec/dialy/chromeosdebianupgradeto10)
- [ChromeOS で Firefox を起動する | Firefox ヘルプ](https://support.mozilla.org/ja/kb/run-firefox-chromeos)
