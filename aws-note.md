# AWS 忘備録

AWS のメモ

- [メタデータ](#メタデータ)
- [AWS CLI のインストール手順](#aws-cli-のインストール手順)
  - [Amazon Linux](#amazon-linux)
  - [Debian, Ubuntu Linux 系](#debian-ubuntu-linux-系)
  - [RHEL 7, CentOS 7](#rhel-7-centos-7)
- [AWS CLI コマンド補完](#aws-cli-コマンド補完)
- [EC2 って ntp は要るの?](#ec2-って-ntp-は要るの)
  - [ElasticIP なしの EC2 で外部 IP を route53 で FQDN をふる](#elasticip-なしの-ec2-で外部-ip-を-route53-で-fqdn-をふる)
  - [欠点](#欠点)
- [ElasticIP なしの EC2 で外部 IP を noip で FQDN をふる](#elasticip-なしの-ec2-で外部-ip-を-noip-で-fqdn-をふる)
- [127.0.0.53](#1270053)
- [「インスタンスの開始」と「インスタンスの起動」](#インスタンスの開始とインスタンスの起動)
- [EC2 インスタンスを停止するとどうなるか](#ec2-インスタンスを停止するとどうなるか)
- [EC2Launch v2](#ec2launch-v2)
  - [EC2Launch TIPS](#ec2launch-tips)
  - [EC2Launch v2 の便利なコマンド](#ec2launch-v2-の便利なコマンド)
- [cloudformation の更新と進行の表示](#cloudformation-の更新と進行の表示)
- [S3 で WWW](#s3-で-www)
  - [cloudformation で](#cloudformation-で)
- [DNS](#dns)
- [AWS アカウントのエイリアス](#aws-アカウントのエイリアス)
- [EC2 Instance Connect](#ec2-instance-connect)
  - [接続の条件](#接続の条件)
- [VPC を作ろうとしたら "The maximum number of VPCs has been reached." と言われた](#vpc-を作ろうとしたら-the-maximum-number-of-vpcs-has-been-reached-と言われた)

## メタデータ

自分のパブリック FQND やパブリック IP なんかが取れる。

IMDSv1 の場合

```bash
curl http://169.254.169.254/latest/meta-data/
```

↑ の結果(2020-09)

```text
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

なので、

```sh
export PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
export PUBLIC_HOSTNAME=`curl http://169.254.169.254/latest/meta-data/public-hostname`
```

とかするとよいです。

参考:

- [インスタンスメタデータの取得 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html) - IMDSv2 の例が
- [インスタンスメタデータとユーザーデータ - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
- [Instance Metadata and User Data - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
- [AWS | AWS の 169.254.169.254 とは何か](https://awsjp.com/AWS/Faq/c/AWS-169.254.169.254-towa-4135.html)

GCP や Azure にも(おなじアドレスで)存在する。

- [Windows 用の Azure Instance Metadata Service - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/windows/instance-metadata-service?tabs=linux)
- [仮想マシン上でマネージド ID を使用してアクセス トークンを取得する \- Azure AD \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token)

## AWS CLI のインストール手順

[Linux での AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html)

```sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
```

更新するのも同じ手順で(本当)

以下は古い。

[AWS CLI のインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-install.html)

汎用的なのは

```bash
pip3 install awscli --upgrade --user
```

### Amazon Linux

プリインストール

### Debian, Ubuntu Linux 系

```bash
sudo apt install awscli -y
```

### RHEL 7, CentOS 7

[Linux に AWS CLI をインストールする - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-linux.html)

カレントユーザにインストールする例

```sh
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm ./get-pip.py
pip install awscli --upgrade --user
hash -r
```

## AWS CLI コマンド補完

[コマンド補完 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-completion.html)

bash だったら~/.bashrc の最後の方に

```sh
## AWS CLI aws_completer
complete -C "$HOME/.local/bin/aws_completer" aws
```

(pip で入れた場合)

Azure CLI にも同じようなやつがある。
apt で入れたら
`/etc/bash_completion.d/azure-cli`
がインストールされるので
特に追加作業はない。

## EC2 って ntp は要るの?

[Linux インスタンスの時刻の設定 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-time.html)
というのがあるので、たぶん要る。

Azure では
[Azure での Linux VM の時刻同期 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync)
によると
「Hyper-V なので VMICTimeSync あるけど、ntp 併用のほうが多いね。でも Azure 内に NTP サーバはないよ」
みたいな感じ。
このページの[ツールとリソース](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync#tools-and-resources)
の項目が、Linux で hv が動いてるかのチェックになってて面白い。

NTP サーバは

- 169.254.169.123 (リンクローカル)
- 0.amazon.pool.ntp.org
- 1.amazon.pool.ntp.org
- 2.amazon.pool.ntp.org
- 3.amazon.pool.ntp.org

が使える。

ntpd だったら景気よく

```conf
server 169.254.169.123 iburst
server 0.amazon.pool.ntp.org iburst
server 1.amazon.pool.ntp.org iburst
server 2.amazon.pool.ntp.org iburst
server 3.amazon.pool.ntp.org iburst
```

しとけばいいのではないか。

ntpd や chrony のような NTP サーバの機能を持つものではなく
sntp や systemd-timesyncd のような SNTP クライアントだけのものが軽いのではないか。試してみる。

systemd-timesyncd は VM だと動かない? [ゆきろぐ: systemd-timesyncd による時刻同期](http://yukithm.blogspot.com/2014/09/systemd-timesyncd.html)
試してみたが動くみたい。

(2022-07)
AWS EC2 の Ubuntu2204LTS のデフォルトでは chrony で 169.254.169.123 が動いてた。

[Amazon Time Sync Service で時間を維持する | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/keeping-time-with-amazon-time-sync-service/)

### ElasticIP なしの EC2 で外部 IP を route53 で FQDN をふる

予算がなくて ElasticIP のない EC2(動的に外部 IP は割り振られる)を
Route53 で FQDN を振る方法。

- [Elastic IP を利用せずに、Amazon EC2 と Route 53 のドメイン名を紐付ける](https://www.kiminonahaseichi.link/memo/2017/08/elastic-ip-amazon-ec2-route-53.html)
- [【AWS】EC2 サーバに固定 IP なしで独自ドメインでアクセスする方法 - Movable Type 技術ブログ](http://www.mtcms.jp/movabletype-blog/aws/201401302220.html)
- [Amazon Route 53: How to automatically update IP addresses without using Elastic IPs - DEV](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)

この最後のやつをためしてみる。

FQDN を決める。もうホストゾーンが 1 つ以上あるものと仮定している(なければ作る)。

EC2 インスタンスを起動して
現在の「パブリック IPv4 アドレス」を得る。
(別に適当でもいいのだがテストにつかえる)

(もうホストゾーンが 1 つ以上あるものとして)
[Route 53 Console Hosted Zones](https://console.aws.amazon.com/route53/v2/hostedzones#)
で、該当ドメインの「ホストゾーン ID」を得る。

きめた FQDN と現在の「パブリック IPv4 アドレス」で、
そこのホストゾーンに
A レコードを登録する。
TTL は 300(5 分)で。

EC2 のインスタンスにタグをつける

- AUTO_DNS_NAME - 上で決めた FQDN
- AUTO_DNS_ZONE - 上で得た「ホストゾーン ID」

さらにこの EC2 インスタンスに以下の IAM ポリシーをもったロールを作る(すでにロールが付いてるなら混ぜる)。

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

↑[元サイト](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)からコピペ。`HOSTED-ZONE-ID`のとこは「上で得たホストゾーン ID」に書き換えて。

ポータルのアクション-セキュリティ-IAM ロールを変更

root で aws コマンドを使うので aws コマンドを用意。
[Linux での AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html)

```sh
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
/usr/local/bin/aws --version
aws --version
```

で、/var/lib/cloud/scripts/per-boot/の下に好きな名前でシェルスクリプトおく。

```sh
##!/bin/bash
## see [Amazon Route 53: How to automatically update IP addresses without using Elastic IPs - DEV](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)
AWS=/usr/local/bin/aws

## Extract information about the Instance
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)

## Extract tags associated with instance
ZONE_TAG=$($AWS ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`AUTO_DNS_ZONE`].Value' --output text)
NAME_TAG=$($AWS ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`AUTO_DNS_NAME`].Value' --output text)

## DEBUG
cat <<EOF
INSTANCE_ID = $INSTANCE_ID
AZ = $AZ
MY_IP = $MY_IP
ZONE_TAG = $ZONE_TAG
NAME_TAG = $NAME_TAG
EOF

## Update Route 53 Record Set based on the Name tag to the current Public IP address of the Instance
$AWS route53 change-resource-record-sets --hosted-zone-id $ZONE_TAG --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$NAME_TAG'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}'
```

↑[元サイト](https://dev.to/aws/amazon-route-53-how-to-automatically-update-ip-addresses-without-using-elastic-ips-h7o)からコピペ。ちょっとだけアレンジ。

いちおう手動で実行して、変な typo とかないかを確認しておく。

↑ は[gist に置いたので](https://gist.githubusercontent.com/heiwa4126/57831f4a3607de798a116eea5ac49298/raw/4a0d84d96eaf7c8abf0759f4072b246fba727c52/r53register.sh)、← の URL を wget か curl -O して、
`chmod +x` して
`/var/lib/cloud/scripts/per-boot`においてください。

こんな感じ

```sh
curl 'https://gist.githubusercontent.com/heiwa4126/57831f4a3607de798a116eea5ac49298/raw/4a0d84d96eaf7c8abf0759f4072b246fba727c52/r53register.sh' -O
chmod +x r53register.sh
sudo mv r53register.sh /var/lib/cloud/scripts/per-boot
```

テストは

```sh
/var/lib/cloud/scripts/per-boot/r53register.sh
```

EC2 を poweroff して、もういちど電源を入れる。
IP が更新されていたら OK。

### 欠点

- EC2 を停止しても A レコードが消えない。FQDN で死活監視とかすると混乱が起きる。
- TTL が 300 秒はいかにも短いがどうしようもない。

## ElasticIP なしの EC2 で外部 IP を noip で FQDN をふる

自分の保持するドメインでなくていいなら
[Amazon Linux インスタンスでの動的な DNS のセットアップ - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/dynamic-dns.html)
で `xxxx.xxxxxxxx.ddns.com` みたいに使える。

[No-IP の登録と DDNS クライアントの設定 | tarufulog](https://tarufu.info/domain_acquisition_no-ip/)

ほかにも freeip とかのサービスがあるのでそれも参照。

登録とか広告とか制限とかめんどくさそうなので、あんまり使いたくない...

## 127.0.0.53

AWS で

```
## grep nameserver /etc/resolv.conf
nameserver 127.0.0.53

## fuser -v 53/udp
                     USER        PID ACCESS COMMAND
53/udp:              systemd-resolve    707 F.... systemd-resolve
```

systemd-resolve とは何か?

[AWS EC2 (Ubuntu) で DNS のスタブリゾルバ 127.0.0.53 と Amazon Provided DNS の関連を確認する - Qiita](https://qiita.com/nasuvitz/items/b67100028f7245ebe9b9)

## 「インスタンスの開始」と「インスタンスの起動」

EC2 でよく間違えるやつ。「停止」と「終了」もよく間違える。

インスタンスの:

- 起動 - [run-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/run-instances.html)
- 開始 - [start-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/start-instances.html)
- 停止 - [stop-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/stop-instances.html)
- 終了 - [terminate-instances — AWS CLI 2.1.33 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/terminate-instances.html)

参考: [Amazon EC2 インスタンスの起動、一覧表示、および終了 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-services-ec2-instances.html)

## EC2 インスタンスを停止するとどうなるか

- [インスタンスの停止と起動 - Windows - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/Stop_Start.html#what-happens-stop)
- [インスタンスの停止と起動 - Linux - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/Stop_Start.html#what-happens-stop)
- [「EC2: インスタンスを停止」アクションによる停止は OS からシャットダウンしたときの動作と同じですか? – 株式会社サーバーワークス サポートページ](https://support.serverworks.co.jp/hc/ja/articles/900004772883--EC2-%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%82%92%E5%81%9C%E6%AD%A2-%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AB%E3%82%88%E3%82%8B%E5%81%9C%E6%AD%A2%E3%81%AFOS%E3%81%8B%E3%82%89%E3%82%B7%E3%83%A3%E3%83%83%E3%83%88%E3%83%80%E3%82%A6%E3%83%B3%E3%81%97%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AE%E5%8B%95%E4%BD%9C%E3%81%A8%E5%90%8C%E3%81%98%E3%81%A7%E3%81%99%E3%81%8B-)

## EC2Launch v2

Windows 用 cloud-init 的ななにか。

- [EC2Launch v2](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2.html)
- [EC2Launch v2 (Ver.2.0.651) のインストール・移行に失敗する件について | DevelopersIO](https://dev.classmethod.jp/articles/how-to-fix-ec2launch-v2-0-651-migration-error/)

* 設定ファイルの場所: `C:\ProgramData\Amazon\EC2Launch\config`
* 設定ファイル: `agent-config.yml`
* ログフォルダ: `C:\ProgramData\Amazon\EC2Launch\log`
* v2 の本体: `C:\Program Files\Amazon\EC2Launch\EC2Launch.exe`
* v2 の設定ツールの場所: `C:\Program Files\Amazon\EC2Launch\settings\EC2LaunchSettings.exe`

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

実際の GUI と ↑ の GUI 画面がぜんぜん違う... v1 のだ。

なんか様子がおかしかったら移行ツールを使う。
[EC2Launch v2 に移行する \- Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2-migrate.html)

Go で書いてあるらしい。サブコマンド式。パスは通っていない。

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

ユーザコマンドを実行する例
[EC2Launch v2 の設定 \- Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/ec2launch-v2-settings.html#ec2launch-v2-task-configuration)

ユーザコマンドを追加した設定ファイル (末尾参照)
`C:\ProgramData\Amazon\EC2Launch\config\agent-config.yml`

```yaml
version: '1.0'
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

### EC2Launch TIPS

PowerShell 使うとログファイル出力が UTF-8 と UTF-16 まじりになって死ねる。

Powershell を実行すると
`C:\ProgramData\Amazon\EC2Launch\log\agent.log`
に、

```
2021-05-07 11:45:15 Info: Script file is created at: C:\Windows\TEMP\EC2Launch900411335\UserScript.ps1
2021-05-07 11:45:15 Info: Error file is created at: C:\Windows\TEMP\EC2Launch900411335\err583552122.tmp
2021-05-07 11:45:15 Info: Output file is created at: C:\Windows\TEMP\EC2Launch900411335\output399549329.tmp
```

みたいにファイルを作る。
エラーがおきた場合、これらが消えないで残るので、
これらを参照すること。これはよい設計。真似る。

### EC2Launch v2 の便利なコマンド

- "C:\Program Files\Amazon\EC2Launch\EC2Launch.exe" version
- "C:\Program Files\Amazon\EC2Launch\EC2Launch.exe" validate
- "C:\Program Files\Amazon\EC2Launch\EC2Launch.exe" run

powershell からだったら頭に&つけて。

[EC2Launch v2 の機能一覧 | DevelopersIO](https://dev.classmethod.jp/articles/ec2launch-v2-all-features-202007/)

## cloudformation の更新と進行の表示

ここから:
[AWS CloudFormation スタックの更新 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks.html)

えっ、そんなんできるんですか(© 内場勝則)

## S3 で WWW

基本は:
[S3 でウェブサイトを公開する - Qiita](https://qiita.com/SSMU3/items/94d60998038e9af80cf9)

で
[Amazon S3 のウェブサイトエンドポイントを使用している CloudFront ディストリビューションからの Access Denied エラーを解決する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/s3-website-cloudfront-error-403/)

次のいずれかの方法で、オブジェクトへのパブリック読み取りアクセスを許可します。

- バケット内のすべてのオブジェクトに対してパブリック読み取りアクセスを許可するバケットポリシーを作成します。[バケットポリシーの例 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/example-bucket-policies.html#example-bucket-policies-use-case-2)
- Amazon S3 コンソールを使用してオブジェクトに対するパブリック読み取りアクセスを許可します。[ACL の設定 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/managing-acls.html)

さらに
[Route 53 に登録されたカスタムドメインを使用した静的ウェブサイトの設定 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html)

S3 の WWW って https にはならない?
[AWS S3 での https 対応含む静的ウェブサイト公開 - Qiita](https://qiita.com/THacker/items/11eadffe6b3ce3491e3b)
CloudFront(と独自ドメイン)がいるらしい。

### cloudformation で

[AWS::S3::Bucket WebsiteConfiguration \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-s3-websiteconfiguration.html)

## DNS

169.254.169.253
または VPC の CIDR(ネットワーク範囲)に 2 をプラスした値

> 「10.0.0.0/16」の CIDR の VPC なら「10.0.0.2」、「172.31.0.0/16」なら「172.31.0.2」という具合
> [VPC デフォルトの DNS サーバへの通信は Security Group の Outbound ルールで制御できないことを確認してみた | DevelopersIO](https://dev.classmethod.jp/articles/security-group-outbound-rule-cannot-filter-traffic-to-amazon-dns-server/)

## AWS アカウントのエイリアス

[AWS アカウント ID とそのエイリアス - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/console_account-alias.html#CreateAccountAlias)

## EC2 Instance Connect

EC2 起動したら sshd がこんな感じで起動していた。(適当に改行してあります)

```bash
/usr/sbin/sshd -D \
 -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized_keys %u %f \
 -o AuthorizedKeysCommandUser ec2-instance-connect [listener] 0 of 10-100 startups
```

[EC2 Instance Connect を使用して接続 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html)

AWS コンソールから WEB ベースで Linux に接続できる機能。

### 接続の条件

- EC2 Instance Connect をサポートする OS(Amazon Linux と Ubuntu)
- 特定のリージョン(大阪とかはダメらしい)
- IPv4 の 22/tcp で sshd が待ってること
- セキュリティグループで ↓ のアドレスが許可されてること

[EC2 Instance Connect を使用した接続のトラブルシューティング](https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-instance-connect-troubleshooting/)

```bash
curl -s https://ip-ranges.amazonaws.com/ip-ranges.json| jq -r '.prefixes[] | select(.region=="ap-northeast-1") | select(.service=="EC2_INSTANCE_CONNECT") | .ip_prefix'
```

どこのホストで実行してもいい。東京リージョンでは `3.112.23.0/29` だった。

## VPC を作ろうとしたら "The maximum number of VPCs has been reached." と言われた

VPC の上限はリージョン単位。

参考: [AWS Service Quotas がリリースされました | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-service-quotas/)

1. <https://console.aws.amazon.com/servicequotas/> へ行く
2. リージョンが該当リージョンであることを確認する
3. <https://console.aws.amazon.com/servicequotas/home/services/vpc/quotas> で "VPCs per Region" を探す。
4. ラジオボタンをチェックして「アカウントレベルでの引き上げをリクエスト」ボタン
5. クォータ値を引き上げ「リクエスト」ボタン
6. クォータリクエストの履歴 <https://console.aws.amazon.com/servicequotas/home/requests> へ行って変更されるのを待つ。待つ。待つ。待つ。
