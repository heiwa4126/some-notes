[Tera TermでSSMセッションマネージャーを通してSSHアクセスしてみる | DevelopersIO](https://dev.classmethod.jp/articles/teraterm-ssm-session-manager-ssh/)

LinuxからLinuxだとこんな感じ。

```bash
aws ssm start-session \
    --target i-03000000000000000 \
    --document-name AWS-StartPortForwardingSession \
    --parameters portNumber=22,localPortNumber=56789
```

で `ssh foo@127.0.0.1 -p56789`

あと、こっちがわにSession Manager プラグインが必要

- [Session Manager プラグインが見つからない](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-troubleshooting.html#plugin-not-found)
- [Ubuntu Server に Session Manager プラグインをインストールする](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-debian) - .debをダウンロードする式。中身はGoLangっぽい

Windowsにもつながるらしいので試す。
