WinRM(WS-Man)のメモ

- [非AD環境のWindows・Windows間でWinRMを使う](#%e9%9d%9ead%e7%92%b0%e5%a2%83%e3%81%aewindows%e3%83%bbwindows%e9%96%93%e3%81%a7winrm%e3%82%92%e4%bd%bf%e3%81%86)
  - [危険な方](#%e5%8d%b1%e9%99%ba%e3%81%aa%e6%96%b9)
    - [サーバ側(service側)](#%e3%82%b5%e3%83%bc%e3%83%90%e5%81%b4service%e5%81%b4)
    - [クライアント側](#%e3%82%af%e3%83%a9%e3%82%a4%e3%82%a2%e3%83%b3%e3%83%88%e5%81%b4)
    - [テスト](#%e3%83%86%e3%82%b9%e3%83%88)
    - [AllowUnencrypted プロパティについて](#allowunencrypted-%e3%83%97%e3%83%ad%e3%83%91%e3%83%86%e3%82%a3%e3%81%ab%e3%81%a4%e3%81%84%e3%81%a6)
- [PSRemotingのもう少し実用的なサンプル](#psremoting%e3%81%ae%e3%82%82%e3%81%86%e5%b0%91%e3%81%97%e5%ae%9f%e7%94%a8%e7%9a%84%e3%81%aa%e3%82%b5%e3%83%b3%e3%83%97%e3%83%ab)
  - [httpsで接続して、かつ証明書をごまかすPowershellサンプル](#https%e3%81%a7%e6%8e%a5%e7%b6%9a%e3%81%97%e3%81%a6%e3%81%8b%e3%81%a4%e8%a8%bc%e6%98%8e%e6%9b%b8%e3%82%92%e3%81%94%e3%81%be%e3%81%8b%e3%81%99powershell%e3%82%b5%e3%83%b3%e3%83%97%e3%83%ab)
- [その他参考](#%e3%81%9d%e3%81%ae%e4%bb%96%e5%8f%82%e8%80%83)
- [pywinrmでの例](#pywinrm%e3%81%a7%e3%81%ae%e4%be%8b)


# 非AD環境のWindows・Windows間でWinRMを使う

非AD環境でWindows-Windows間でWinRMを使うのはひどく難しい。
Linux-WindowsでWinRMを使うほうが遥かに楽。

どちらかを選ぶ:
- 証明書を設定する(設定面倒、メンテ面倒&安全)
- HTTPトランスポート,BASIC認証,平文通信で使う(簡単&危ない)

ひとえにAnsibleみたいな`winrm_server_cert_validation=ignore`が無いからだと思う。

winrmコマンドを使うのを諦めて、pythonを使ったほうが楽かもしれない(試してない)。

参考: [PowerShellを使わずにWinRMでコマンド実行する - とりあえず備忘](http://miyataro.hatenablog.com/entry/2017/10/11/PowerShell%E3%82%92%E4%BD%BF%E3%82%8F%E3%81%9A%E3%81%ABWinRM%E3%81%A7%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E5%AE%9F%E8%A1%8C%E3%81%99%E3%82%8B)

## 危険な方

HTTPトランスポート,BASIC認証,平文通信で使う場合の設定。
**まあちょっとWinRM/WinRSを使ってみようかな、というときのみ使う。**

まず、サーバ・クライアントともに、Ansible提供のスクリプトでWinRMの標準設定をしておくこと。Enable-PSremotingも実行されるみたい。
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
powershell -ExecutionPolicy RemoteSigned .\ConfigureRemotingForAnsible.ps1
```

参考: [WMWare - HTTP を使用するための WinRM の構成](https://docs.vmware.com/jp/vRealize-Orchestrator/7.3/com.vmware.vrealize.orchestrator-use-plugins.doc/GUID-D4ACA4EF-D018-448A-866A-DECDDA5CC3C1.html)

### サーバ側(service側)

```
@rem 基本認証を有効
winrm set winrm/config/service/auth @{Basic="true"}
@rem WinRM クライアントで暗号化されていないデータの転送を許可
winrm set winrm/config/service @{AllowUnencrypted="true"}
```

設定の確認
```
C:\> winrm get winrm/config/service
Service
(略)
    AllowUnencrypted = true <-ここ
    Auth
        Basic = true  <-ここ
        Kerberos = true
        Negotiate = true
        Certificate = false
        CredSSP = true
        CbtHardeningLevel = Relaxed
    DefaultPorts
        HTTP = 5985
        HTTPS = 5986
    IPv4Filter = *
    IPv6Filter = *
    EnableCompatibilityHttpListener = false
    EnableCompatibilityHttpsListener = false
    CertificateThumbprint
    AllowRemoteAccess = true
```

### クライアント側

```
@rem 基本認証を有効
winrm set winrm/config/client/auth @{Basic="true"}
@rem WinRM クライアントで暗号化されていないデータの転送を許可
winrm set winrm/config/client @{AllowUnencrypted="true"}
@rem 信頼できるホストを指定
winrm set winrm/config/client @{TrustedHosts="host1, host2, host3"}
```

設定の確認
```
C:\> winrm get winrm/config/client
Client
(略)
    AllowUnencrypted = true <- ここ
    Auth
        Basic = true  <- ここ
        Digest = true
        Kerberos = true
        Negotiate = true
        Certificate = true
        CredSSP = false
    DefaultPorts
        HTTP = 5985
        HTTPS = 5986
    TrustedHosts = 172.31.1.888, 172.31.1.999  <- ここ
```

### テスト

クライアントで以下のようなWinrmコマンドを実行(要アレンジ)
```
c:\> winrm id -r:http://172.31.1.999:5985 -auth:basic -u:administrator -p:adminspassword -encoding:utf-8
```

続いてwinrsでwhoamiを実行(要アレンジ)
```
c:\> winrs -r:http://172.31.1.999:5985 -u:administrator -p:adminspassword  whoami
```

さらにPSremoting
```
ps> Enter-PSSession -ComputerName 172.31.1.999 -Credential 172.31.1.999\Administrator
(ダイアログが開く)
[172.31.1.999]: PS> exit
```

### AllowUnencrypted プロパティについて

[IBM Knowledge Center - Hyper-V ホストでの WinRM の構成](https://www.ibm.com/support/knowledgecenter/ja/SS2TKN_9.0.0/com.ibm.tivoli.tem.doc_9.0/SR_9.0/com.ibm.license.mgmt.doc/admin/t_configuring_winrm.html)
>この値を「TRUE」に設定しても、ユーザー名やパスワードなどの機密データが、暗号化されていない形式でネットワークを介して渡されるわけではありません。 SOAP メッセージの内容のみがプレーン・テキストで送信されます。 セキュリティー上の理由でこれを受け入れられない場合は、HTTPS リスナーを定義してセキュア・トランスポート (HTTPS) を使用する一方で、Subcapacity Reporting サーバーで VM マネージャーを定義して、TLS プロトコルを使用してすべてのネットワーク・トラフィックが暗号化されるようにしてください。

[PowerShell リモート処理のセキュリティに関する考慮事項 | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/scripting/setup/winrmsecurity?view=powershell-6)
> 使用されているトランスポート プロトコル (HTTP または HTTPS) に関係なく、PowerShell リモート処理では、常にすべての通信が、初期認証後に、セッションごとの AES 256 対称キーを使用して暗号化されます。



# PSRemotingのもう少し実用的なサンプル

参考: [PowerShell でリモート接続する ( Enter-PSSession ) – 行け！偏差値40プログラマー](http://hensa40.cutegirl.jp/archives/677)

WMIをいくつか取ってくる
```
$hostname = "172.31.1.999"
$username = "172.31.1.999\administrator"
$passwd   = "password"

# Credential オプションに指定するオブジェクトのインスタンス生成
$psc = New-Object System.Management.Automation.PsCredential($username, (ConvertTo-SecureString $passwd -AsPlainText -Force))

# New-PSSession コマンドによるセッションの生成
$sess = New-PSSession -ComputerName $hostname -Credential $psc

## セッションの確認

# 若干のWMIの収集
$cpu = Invoke-Command -Session $sess -ScriptBlock {Get-WmiObject Win32_Processor}
$mem = Invoke-Command -Session $sess -ScriptBlock {Get-WmiObject Win32_PhysicalMemory}
$sys = Invoke-Command -Session $sess -ScriptBlock {Get-WmiObject Win32_ComputerSystem}

## 3回呼ぶよりはdict作って返したほうがいいかも

# セッションを削除
Remove-PSSession -Session $sess

## セッションの確認
#Get-PSSession
```

Get-WmiObjectは`-computername`でリモートを指定できるけれど、PSRemotingの方が早い。
WMIの通信の設定もかなり面倒。

## httpsで接続して、かつ証明書をごまかすPowershellサンプル

超ありがちなダメな状況。

IPではSSL使えないし、
非ADユーザでつなぐのもどうか。
**でも動く**

```
$url = "https://111.222.333.444:5986/wsman"
$username = ".\user001" # local user example 
$passwd   = "swordfish"

# Credential オプションに指定するオブジェクトのインスタンス生成
$psc = New-Object System.Management.Automation.PsCredential($username, (ConvertTo-SecureString $passwd -AsPlainText -Force))

# 証明書エラーをごまかす設定
$sessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

# New-PSSession コマンドによるセッションの生成
$sess = New-PSSession -ConnectionURI $url -Credential $psc -SessionOption $sessionOption

## セッションの確認
# Get-PSSession

# 若干のWMIの収集サンプル
$cpu = Invoke-Command -Session $sess -ScriptBlock {Get-WmiObject Win32_Processor}
$mem = Invoke-Command -Session $sess -ScriptBlock {Get-WmiObject Win32_PhysicalMemory}
$sys = Invoke-Command -Session $sess -ScriptBlock {Get-WmiObject Win32_ComputerSystem}

# セッションを削除
Remove-PSSession -Session $sess

# 結果を出力
$cpu | fl *
$mem | fl *
$sys | fl *
```

参考:
* [Not able to remote connect to powershell](https://social.technet.microsoft.com/Forums/en-US/e1aac407-33a1-4d19-988f-8b954d8b5007/not-able-to-remote-connect-to-powershell?forum=Exch2016PS)

# その他参考

これも→ 
[PowerShell リモート処理での次ホップの実行 | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/scripting/setup/ps-remoting-second-hop?view=powershell-6)

* [リモート コンピューターのバッチ操作(Invoke-Command)](http://www.vwnet.jp/windows/powershell/InvokeCommand.htm)

* winrm.cmdのman page : [Winrm -remote - Windows CMD - SS64.com](https://ss64.com/nt/winrm-remote.html)
* [Winrs - Windows CMD - SS64.com](https://ss64.com/nt/winrs.html)

* [Let's Encrpytで発行した証明書をPowerShellリモート接続のHTTPS接続にも使ってみる](https://qiita.com/kazinoue/items/bdd7b783d6742770b2cc)
* [Let's Encryptで発行した証明書をRemote Desktopの証明書にも割り当ててみる](https://qiita.com/kazinoue/items/209846d0204caad46522)

# pywinrmでの例

[diyan/pywinrm: Python library for Windows Remote Management (WinRM)](https://github.com/diyan/pywinrm)
の例をちょっとだけアレンジした例
```
#!/usr/bin/python3
# -*- coding: utf-8 -*-

from winrm.protocol import Protocol

p = Protocol(
    endpoint='https://HOSTXXX:5986/wsman',
    transport='ntlm',
    username=r'x.example.com\foobar',
    password='swordfish',
    server_cert_validation='ignore')
shell_id = p.open_shell()
command_id = p.run_command(shell_id, 'ipconfig', ['/all'])
std_out, std_err, status_code = p.get_command_output(shell_id, command_id)
p.cleanup_command(shell_id, command_id)
p.close_shell(shell_id)

# std_out is binary[]
#print(std_out)
print(std_out.decode('sjis'))
```
