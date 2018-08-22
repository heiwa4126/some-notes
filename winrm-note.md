WinRM(WS-Man)のメモ

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

まず、サーバ・クライアントともに、Ansible提供のスクリプトでWinRMの標準設定をしておくこと。
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
inrm set winrm/config/client @{TrustedHosts="host1, host2, host3"}
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



# その他参考

[PowerShell リモート処理のセキュリティに関する考慮事項 | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/scripting/setup/winrmsecurity?view=powershell-6)
> 使用されているトランスポート プロトコル (HTTP または HTTPS) に関係なく、PowerShell リモート処理では、常にすべての通信が、初期認証後に、セッションごとの AES 256 対称キーを使用して暗号化されます。


