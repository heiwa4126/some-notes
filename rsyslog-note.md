# rsyslogメモ

re_match()はPOSIX ERE。ereregexと同じ表記

[re_match() — rsyslog 9c4fd0b docs](https://www.rsyslog.com/doc/master/rainerscript/functions/rs-re_match.html)

POSIXのregexについては [正規表現メモ](http://www.kt.rim.or.jp/~kbk/regex/regex.html#POSIX)

文字列リテラルは、
シングルクォートでもダブルクォートでも
`\`はエスケープ文字(意外)。
「ダブルクォートの場合$をエスケープしなければならない」と書いてあるがなんだそれ。

[String Constants — rsyslog v8.1910.0 documentation](https://www.rsyslog.com/doc/v8-stable/rainerscript/constant_strings.html)

172.31.*.*から来るメッセージをトラップする例
```
if re_match($fromhost-ip, '^172\\.31\\.') then {
    -/var/log/from-interal
    stop
}
```
↑BSD-style Blocks式。[Filter Conditions — rsyslog v8.1910.0 documentation](https://www.rsyslog.com/doc/v8-stable/configuration/filters.html)

ログ名の前の'-'は、「syncしない」。デバッグ時ははずすとtail -Fしやすい。

omはoutput moduleの略
[omfile: File Output Module — rsyslog v8.1910.0 documentation](https://www.rsyslog.com/doc/v8-stable/configuration/modules/omfile.html)

`-/var/log/from-interal` のかわりに
`action(type="omfile" dirCreateMode="0700" FileCreateMode="0644" asyncWriting="off" File="/var/log/from-interal")`と書いてもOK。

socket経由でもfromhost-ipは"127.0.0.1"になるみたい。

```
:fromhost-ip, !isequal, "127.0.0.1", /var/log/non-local
```
でローカルでないものを全部ログできる。

ただ
[Multiple Rulesets in rsyslog — rsyslog v8.1910.0 documentation](https://www.rsyslog.com/doc/v8-stable/concepts/multi_ruleset.html)
を使ったほうがいいと思う。

```
# Provides UDP syslog reception
# $ModLoad imudp
# $UDPServerRun 514
module(load="imudp") # needs to be done just once
input(type="imudp" port="514" rcvbufSize="1m" ruleset="nonlocal")
...
ruleset(name="nonlocal"){
    -/var/log/nonlocal
    stop
}
```
こんな感じ。
最初から外部から受けるものを、デフォルトルールセット以外で処理する。

[imudp: UDP Syslog Input Module — rsyslog v8.1910.0 documentation](https://www.rsyslog.com/doc/v8-stable/configuration/modules/imudp.html#rcvbufsize)

rcvbufSize=を設定するとOSによる自動チューニングが無効になるので、
考えてから設定すること。いま不具合がなければ設定しない。




# テスト用

`logger -n r1 -d test`を毎回タイプするのも面倒なので、
0.5秒ごとにUDPで現在時刻を送りつけるperlのコード
``` perl
#!/usr/bin/env perl
# -*- coding: utf-8 -*-
use strict;
use warnings;
use Sys::Syslog qw(:standard setlogsock);
use Time::HiRes qw(gettimeofday usleep);
use POSIX qw(strftime);
use constant TARGET => 'r1';
setlogsock('udp');
$Sys::Syslog::host = TARGET;
openlog('test', 'ndelay', 'user');
for(;;) {
  my ($sec, $usec) = gettimeofday();
  syslog('info',sprintf('%s.%03d',strftime('%Y-%m-%d %H:%M:%S',localtime $sec),$usec/1000));
  usleep(500000);
}
closelog();
0;
```

Red Hat系だと`sudo yum install perl-Sys-Syslog`が要る。