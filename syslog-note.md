syslog(とjouernald)で出るエラーメッセージの対策メモ

- [pam_oddjob_mkhomedir.soが無い](#pamoddjobmkhomedirso%E3%81%8C%E7%84%A1%E3%81%84)
- [ntpd ::1](#ntpd-1)
- [postfix](#postfix)
- [syslogのテスト用コード](#syslog%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E7%94%A8%E3%82%B3%E3%83%BC%E3%83%89)
- [出力フォーマットを変えてみる](#%E5%87%BA%E5%8A%9B%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88%E3%82%92%E5%A4%89%E3%81%88%E3%81%A6%E3%81%BF%E3%82%8B)

# pam_oddjob_mkhomedir.soが無い

```
journalctl -exlp err
```
で

```
2月 08 14:03:01 XXXXXXX001 crond[476]: PAM unable to dlopen(/usr/lib64/security/pam_oddjob_mkhomedir.so): /usr/lib64/sec
2月 08 14:03:01 XXXXXXX001 crond[476]: PAM adding faulty module: /usr/lib64/security/pam_oddjob_mkhomedir.so
```
が毎分出ているとき。

```
yum install oddjob-mkhomedir
```
でとりあえず消せる。影響がわからない。

```
journalctl -f -p err
```
で見張る。

# ntpd ::1

```
messages:Feb  4 19:12:24 XXXXXXX001 ntpd[6363]: restrict: error in address '::1' on line 15. Ignoring...
```

対策
```
        path: /etc/ntp.conf
        regexp: '^restrict ::1$'
        replace: '# restrict ::1'
```

`restrict -6 ::1`もあるらしい。

# postfix

```
 2月 06 22:53:25 XXXXXX001 postfix/pickup[24937]: warning: inet_protocols: disabling IPv6 name/address support: Address
```

対策
```
inet_protocols = all
```
から
```
inet_protocols = ipv4
```

小文字なのがミソ


# syslogのテスト用コード

``` bash
#!/bin/sh
# -*- coding: utf-8 -*-
logger -p 0 "emerg:システムが落ちるような状態"
logger -p 1 "alert:緊急に対処すべきエラー"
logger -p 2 "crit:致命的なエラー"
logger -p 3 "err:一般的なエラー"
logger -p 4 "warn:警告"
logger -p 5 "notice:通知"
logger -p 6 "info:情報"
logger -p 7 "debug:デバッグ情報"
```

`-p0`するとbeepが鳴るのが面白い。(端末によっては画面フラッシュ)

こんなのが出ます。
```
Jun  7 17:46:24 r1 user01: emerg:システムが落ちるような状態
Jun  7 17:46:24 r1 user01: alert:緊急に対処すべきエラー
Jun  7 17:46:24 r1 user01: crit:致命的なエラー
Jun  7 17:46:24 r1 user01: err:一般的なエラー
Jun  7 17:46:24 r1 user01: warn:警告
Jun  7 17:46:24 r1 user01: notice:通知
Jun  7 17:46:24 r1 user01: info:情報
```
(RHEL7のrsyslog(デフォルト設定値)で/var/log/message)


# 出力フォーマットを変えてみる

プライオリティ文字列を追加してみる。

/etc/rsyslog.confの、この部分を
```
# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none                /var/log/messages
```
このように変更
```
# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
$template TraditionalFormatP1,"%timegenerated% %HOSTNAME% %syslogtag% %msg:::drop-last-lf% <%syslogpriority-text%>\n"
*.info;mail.none;authpriv.none;cron.none                /var/log/messages;TraditionalFormatP1
```

シンタックスチェック
``` bash
rsyslogd -N 1 -c /etc/rsyslog.conf
```
`-c /etc/rsyslog.conf`はデフォルト値なので省略可能

rsyslogd再起動(reloadはなくなった模様)
``` bash
systemctl restart rsyslog
```

こんな出力になります。
```
Jun  7 18:19:14 r1 user01: emerg:システムが落ちるような状態 <emerg>
Jun  7 18:19:14 r1 user01: alert:緊急に対処すべきエラー <alert>
Jun  7 18:19:14 r1 user01: crit:致命的なエラー <crit>
Jun  7 18:19:14 r1 user01: err:一般的なエラー <err>
Jun  7 18:19:14 r1 user01: warn:警告 <warning>
Jun  7 18:19:14 r1 user01: notice:通知 <notice>
Jun  7 18:19:14 r1 user01: info:情報 <info>
```







