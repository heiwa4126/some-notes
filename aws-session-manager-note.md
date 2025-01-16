# aws ssm start-session のメモ

## Session Manager Plugin

AWS CLI が v1 だろうと v2 だろうと必要。

あと Linux でも `apt update` とかで更新されないので注意。

履歴は
[Session Manager プラグインの最新バージョンとリリース履歴 - AWS Systems Manager](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/plugin-version-history.html)

### Windows

[Windows での Session Manager プラグインのインストール - AWS Systems Manager](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/install-plugin-windows.html)

<https://s3.amazonaws.com/session-manager-downloads/plugin/latest/windows/SessionManagerPluginSetup.exe> からダウンロード

```powershell
session-manager-plugin --version
```

で確認。

### Debian & Ubuntu

[Debian Server と Ubuntu Server での Session Manager プラグインのインストール - AWS Systems Manager](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/install-plugin-debian-and-ubuntu.html)

```sh
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
session-manager-plugin --version
```

## `sudo -i` して `su - foo` を一回で

```sh
sudo su - foo
```

そりゃそうだ。
