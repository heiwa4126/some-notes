syslog(とjouernald)で出るエラーメッセージの対策メモ

- [pam_oddjob_mkhomedir.soが無い](#pamoddjobmkhomedirso%E3%81%8C%E7%84%A1%E3%81%84)

# pam_oddjob_mkhomedir.soが無い

```
2月 08 14:03:01 NVMWEB001 crond[476]: PAM unable to dlopen(/usr/lib64/security/pam_oddjob_mkhomedir.so): /usr/lib64/sec
 2月 08 14:03:01 NVMWEB001 crond[476]: PAM adding faulty module: /usr/lib64/security/pam_oddjob_mkhomedir.so
```

[Why AD user's home directory is not getting created in Atomic host after configuring sssd container ?](https://access.redhat.com/solutions/2946401)