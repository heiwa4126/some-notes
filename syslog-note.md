syslog(とjouernald)で出るエラーメッセージの対策メモ

- [pam_oddjob_mkhomedir.soが無い](#pamoddjobmkhomedirso%E3%81%8C%E7%84%A1%E3%81%84)
- [ntpd ::1](#ntpd-1)
- [postfix](#postfix)

# pam_oddjob_mkhomedir.soが無い

```
2月 08 14:03:01 XXXXXXX001 crond[476]: PAM unable to dlopen(/usr/lib64/security/pam_oddjob_mkhomedir.so): /usr/lib64/sec
 2月 08 14:03:01 XXXXXXX001 crond[476]: PAM adding faulty module: /usr/lib64/security/pam_oddjob_mkhomedir.so
```

[Why AD user's home directory is not getting created in Atomic host after configuring sssd container ?](https://access.redhat.com/solutions/2946401)


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

