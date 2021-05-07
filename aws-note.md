# AWS忘備録

AWSのメモ
- [AWS忘備録](#aws忘備録)
- [メタデータ](#メタデータ)
- [AWS CLIのインストール手順](#aws-cliのインストール手順)
  - [Amazon Linux](#amazon-linux)
  - [Debian, Ubuntu Linux系](#debian-ubuntu-linux系)
  - [RHEL 7, CentOS 7](#rhel-7-centos-7)
- [AWS CLI コマンド補完](#aws-cli-コマンド補完)
- [EC2ってntpは要るの?](#ec2ってntpは要るの)
- [ElasticIPなしのEC2で外部IPをroute53でFQDNをふる](#elasticipなしのec2で外部ipをroute53でfqdnをふる)
  - [欠点](#欠点)
- [127.0.0.53](#1270053)
- [「インスタンスの開始」と「インスタンスの起動」](#インスタンスの開始とインスタンスの起動)
- [EC2インスタンスを停止するとどうなるか](#ec2インスタンスを停止するとどうなるか)
- [EC2Launch v2](#ec2launch-v2)
  - [EC2Launch TIPS](#ec2launch-tips)


# メタデータ

自分のパブリックFQNDやパブリックIPなんかが取れる。

IMDSv1の場合
``` bash
curl http://169.254.169.254/latest/meta-data/
```

↑の結果(2020-09)
```
ami-id
ami-launch-index
ami-manifest-path
block-device-mapping/
events/
hostname
identity-credentials/
instance-action
instance-id
instance-life-cycle
instance-type
local-hostname
local-ipv4
mac
metrics/
network/
placement/
product-codes
profile
public-hostname
public-ipv4
public-keys/
reservation-id
security-groups
```

なので、
```sh
export PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
export PUBLIC_HOSTNAME=`curl http://169.254.169.254/latest/meta-data/public-hostname`
```
とかするとよいです。

参考:
* [インスタンスメタデータの取得 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html) - IMDSv2の例が
* [インスタンスメタデータとユーザーデータ - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
* [Instance Metadata and User Data - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
* [AWS | AWS の169.254.169.254とは何か](https://awsjp.com/AWS/Faq/c/AWS-169.254.169.254-towa-4135.html)


# AWS CLIのインストール手順

[Linux での AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html)

```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
```
更新するのも同じ手順で(本当)


以下は古い。

[AWS CLI のインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-install.html)

汎用的なのは
``` bash
pip3 install awscli --upgrade --user
```

## Amazon Linux

プリインストール

## Debian, Ubuntu Linux系

``` bash
sudo apt install awscli -y
```

## RHEL 7, CentOS 7

[Linux に AWS CLI をインストールする - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-linux.html)

カレントユーザにインストールする例
```
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm ./get-pip.py
pip install awscli --upgrade --user
hash -r
```

# AWS CLI コマンド補完

[コマンド補完 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-completion.html)

bashだったら~/.bashrcの最後の方に
```
# AWS CLI aws_completer
complete -C "$HOME/.local/bin/aws_completer" aws
```
(pipで入れた場合)

Azure CLIにも同じようなやつがある。
aptで入れたら
`/etc/bash_completion.d/azure-cli`
がインストールされるので
特に追加作業はない。


# EC2ってntpは要るの?

[Linux インスタンスの時刻の設定 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-time.html)
というのがあるので、たぶん要る。

Azureでは
[Azure での Linux VM の時刻同期 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync)
によると
「Hyper-VなのでVMICTimeSyncあるけど、ntp併用のほうが多いね。でもAzure内にNTPサーバはないよ」
みたいな感じ。
このページの[ツールとリソース](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync#tools-and-resources)
の項目が、Linuxでhvが動いてるかのチェックになってて面白い。

NTPサーバは

- 169.254.169.123 (リンクローカル)
- 0.amazon.pool.ntp.org
- 1.amazon.pool.ntp.org
- 2.amazon.pool.ntp.org
- 3.amazon.pool.ntp.org

が使える。

ntpdだったら景気よく
```
server 169.254.169.123 iburst
server 0.amazon.pool.ntp.org iburst
server 1.amazon.pool.ntp.org iburst
server 2.amazon.pool.ntp.org iburst
server 3.amazon.pool.ntp.org iburst
```
しとけばいいのではないか。

ntpdやchronyのようなNTPサーバの機能を持つものではなく
sntpやsystemd-timesyncdのようなSNTPクライアントだけのものが軽いのではないか。試してみる。

systemd-timesyncdはVMだと動かない? [ゆきろぐ: systemd-timesyncdによる時刻同期](http://yukithm.blogspot.com/2014/09/systemd-timesyncd.html)
試してみたが動くみたい。


# ElasticIPなしのEC2で外部IPをroute53でFQDNをふる

予算がなくてElasticIPのないEC2(動的に外部IPは割り振られる)を
Route53でFQDNを振る方法。

- [Elastic IP を利用せずに、Amazon EC2と Route 53 のドメイン名を紐付ける](https://www.kiminonahaseichi.link/memo/2017/08/elastic-ip-amazon-ec2-route-53.html)
- [【AWS】EC2サーバに固定IPなしで独自ドメインでアクセスする方法 - Movable Type技術ブログ](http://www.mtcms.jp/movabletype-blog/aws/201401302220.html)
- [Amazon Route 53: How to automatically update IP addresses without using Elastic IPs - DEV](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)

この最後のやつをためしてみる。

FQDNを決める。もうホストゾーンが1つ以上あるものと仮定している(なければ作る)。

EC2インスタンスを起動して
現在の「パブリック IPv4 アドレス」を得る。
(別に適当でもいいのだがテストにつかえる)

(もうホストゾーンが1つ以上あるものとして)
[Route 53 Console Hosted Zones](https://console.aws.amazon.com/route53/v2/hostedzones#)
で、該当ドメインの「ホストゾーン ID」を得る。

きめたFQDNと現在の「パブリック IPv4 アドレス」で、
そこのホストゾーンに
Aレコードを登録する。
TTLは300(5分)で。

EC2のインスタンスにタグをつける
- AUTO_DNS_NAME - 上で決めたFQDN
- AUTO_DNS_ZONE - 上で得た「ホストゾーン ID」

さらにこのEC2インスタンスに以下のIAMポリシーをもったロールを作る(すでにロールが付いてるなら混ぜる)。
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeTags",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/HOSTED-ZONE-ID"
        }
    ]
}
```
↑[元サイト](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)からコピペ。`HOSTED-ZONE-ID`のとこは「上で得たホストゾーン ID」に書き換えて。


ポータルのアクション-セキュリティ-IAMロールを変更

rootでawsコマンドを使うのでawsコマンドを用意。
[Linux での AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html)

```sh
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
/usr/local/bin/aws --version
aws --version
```

で、/var/lib/cloud/scripts/per-boot/の下に好きな名前でシェルスクリプトおく。
```sh
#!/bin/bash
# see [Amazon Route 53: How to automatically update IP addresses without using Elastic IPs - DEV](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)
AWS=/usr/local/bin/aws

# Extract information about the Instance
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)

# Extract tags associated with instance
ZONE_TAG=$($AWS ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`AUTO_DNS_ZONE`].Value' --output text)
NAME_TAG=$($AWS ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`AUTO_DNS_NAME`].Value' --output text)

# DEBUG
cat <<EOF
INSTANCE_ID = $INSTANCE_ID
AZ = $AZ
MY_IP = $MY_IP
ZONE_TAG = $ZONE_TAG
NAME_TAG = $NAME_TAG
EOF

# Update Route 53 Record Set based on the Name tag to the current Public IP address of the Instance
$AWS route53 change-resource-record-sets --hosted-zone-id $ZONE_TAG --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$NAME_TAG'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}'
```

↑[元サイト](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)からコピペ。ちょっとだけアレンジ。

いちおう手動で実行して、変なtypoとかないかを確認しておく。

↑は[gistに置いたので](https://gist.githubusercontent.com/heiwa4126/57831f4a3607de798a116eea5ac49298/raw/4a0d84d96eaf7c8abf0759f4072b246fba727c52/r53register.sh)、←のURLをwgetかcurl -Oして、 chmod +x してください。

EC2をpoweroffして、もういちど電源を入れる。
IPが更新されていたらOK。

## 欠点

- EC2を停止してもAレコードが消えない。FQDNで死活監視とかすると混乱が起きる。
- TTLが300秒はいかにも短いがどうしようもない。

# 127.0.0.53

AWSで
```
# grep nameserver /etc/resolv.conf
nameserver 127.0.0.53

# fuser -v 53/udp
                     USER        PID ACCESS COMMAND
53/udp:              systemd-resolve    707 F.... systemd-resolve
```

systemd-resolveとは何か?

[AWS EC2 (Ubuntu) で DNS のスタブリゾルバ 127.0.0.53 と Amazon Provided DNS の関連を確認する - Qiita](https://qiita.com/nasuvitz/items/b67100028f7245ebe9b9)


# 「インスタンスの開始」と「インスタンスの起動」

EC2でよく間違えるやつ。「停止」と「終了」もよく間違える。

インスタンスの:
- 起動 - [run-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/run-instances.html)
- 開始 - [start-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/start-instances.html)
- 停止 - [stop-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/stop-instances.html)
- 終了 - [terminate-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/terminate-instances.html)

参考: [Amazon EC2 インスタンスの起動、一覧表示、および終了 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-services-ec2-instances.html)


# EC2インスタンスを停止するとどうなるか

- [インスタンスの停止と起動 - Windows - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/Stop_Start.html#what-happens-stop)
- [インスタンスの停止と起動 - Linux - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/Stop_Start.html#what-happens-stop)
- [「EC2: インスタンスを停止」アクションによる停止はOSからシャットダウンしたときの動作と同じですか？ – 株式会社サーバーワークス サポートページ](https://support.serverworks.co.jp/hc/ja/articles/900004772883--EC2-%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%82%92%E5%81%9C%E6%AD%A2-%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AB%E3%82%88%E3%82%8B%E5%81%9C%E6%AD%A2%E3%81%AFOS%E3%81%8B%E3%82%89%E3%82%B7%E3%83%A3%E3%83%83%E3%83%88%E3%83%80%E3%82%A6%E3%83%B3%E3%81%97%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AE%E5%8B%95%E4%BD%9C%E3%81%A8%E5%90%8C%E3%81%98%E3%81%A7%E3%81%99%E3%81%8B-)



# EC2Launch v2

Windows用cloud-init的ななにか。

[EC2Launch v2](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2.html)


- 設定ファイルの場所: `C:\ProgramData\Amazon\EC2Launch\config`
- 設定ファイル: `agent-config.yml`
- ログフォルダ: `C:\ProgramData\Amazon\EC2Launch\log`
- v2の本体: `C:\Program Files\Amazon\EC2Launch\EC2Launch.exe`
- v2の設定ツールの場所: `C:\Program Files\Amazon\EC2Launch\settings\EC2LaunchSettings.exe`


設定ファイルの例:
```yaml
version: 1.0
config:
  - stage: boot
    tasks:
      - task: extendRootPartition
  - stage: preReady
    tasks:
      - task: activateWindows
        inputs:
          activation:
            type: amazon
      - task: setDnsSuffix
        inputs:
          suffixes:
            - $REGION.ec2-utilities.amazonaws.com
      - task: setAdminAccount
        inputs:
          password:
            type: random
      - task: setWallpaper
        inputs:
          path: C:\ProgramData\Amazon\EC2Launch\wallpaper\Ec2Wallpaper.jpg
          attributes:
            - hostName
            - instanceId
            - privateIpAddress
            - publicIpAddress
            - instanceSize
            - availabilityZone
            - architecture
            - memory
            - network
  - stage: postReady
    tasks:
      - task: startSsm
```

[EC2Launch v2 の設定 \- Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2-settings.html)

実際のGUIと↑のGUI画面がぜんぜん違う... v1のだ。

なんか様子がおかしかったら移行ツールを使う。
[EC2Launch v2 に移行する \- Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2-migrate.html)

Goで書いてあるらしい。サブコマンド式。パスは通っていない。

```
C:\Users\Administrator>"C:\Program Files\Amazon\EC2Launch\EC2Launch.exe" help
EC2Launch command line tool, providing commands like
        sysprep <-logs> <-reboot/shutdown>
        collect-logs

Usage:
  ec2launch [flags]
  ec2launch [command]

Available Commands:
  collect-logs     Collect log files for EC2Launch
  get-agent-config Print agent-config.yml content in selected format.
  help             Help about any command
  list-volumes     List volumes attached to this instance
  reset            Reset agent state and optionally clean instance logs.
  run              To run EC2Launch
  status           Get the status of the EC2Launch service.
  sysprep          Sysprep the instance to prepare it for imaging.
  validate         Validate agent config file agent-config.yml
  version          Get executable version
  wallpaper        Set wallpaper command for EC2Launch

Flags:
  -h, --help   help for ec2launch

Use "ec2launch [command] --help" for more information about a command.
```

ユーザコマンドを実行する例
[EC2Launch v2 の設定 \- Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2-settings.html#ec2launch-v2-task-configuration)

ユーザコマンドを追加した設定ファイル (末尾参照)
`C:\ProgramData\Amazon\EC2Launch\config\agent-config.yml`

```yaml
version: "1.0"
config:
- stage: boot
  tasks:
  - task: extendRootPartition
- stage: preReady
  tasks:
  - task: activateWindows
    inputs:
      activation:
        type: amazon
  - task: setDnsSuffix
    inputs:
      suffixes:
      - $REGION.ec2-utilities.amazonaws.com
  - task: setAdminAccount
    inputs:
      password:
        type: random
  - task: setWallpaper
    inputs:
      path: C:\ProgramData\Amazon\EC2Launch\wallpaper\Ec2Wallpaper.jpg
      attributes:
      - hostName
      - instanceId
      - privateIpAddress
      - publicIpAddress
      - instanceSize
      - availabilityZone
      - architecture
      - memory
      - network
- stage: postReady
  tasks:
  - task: startSsm
  # example https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2-settings.html#ec2launch-v2-task-configuration
  - task: executeScript
    inputs:
    - frequency: always
      type: powershell
      runAs: admin
      content: |-
        New-Item -Path 'C:\PowerShellTest.txt' -ItemType File
        Set-Content 'C:\PowerShellTest.txt' "hello world"
```

## EC2Launch TIPS

PowerShell使うとログファイル出力がUTF-8とUTF-16まじりになって死ねる。

Powershellを実行すると
`C:\ProgramData\Amazon\EC2Launch\log\agent.log`
に、
```
2021-05-07 11:45:15 Info: Script file is created at: C:\Windows\TEMP\EC2Launch900411335\UserScript.ps1
2021-05-07 11:45:15 Info: Error file is created at: C:\Windows\TEMP\EC2Launch900411335\err583552122.tmp
2021-05-07 11:45:15 Info: Output file is created at: C:\Windows\TEMP\EC2Launch900411335\output399549329.tmp
```
みたいにファイルを作る。
エラーがおきた場合、これらが消えないで残るので、
これらを参照すること。これはよい設計。真似る。