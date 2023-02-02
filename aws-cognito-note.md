# CLIでユーザ

アプリにもよるけど、おおむねこんな感じ

```bash
aws cognito-idp sign-up \
  --client-id <client-id> \
  --username <username> \
  --password <password> \
  --user-attributes '[{"Name": "email", "Value": "<email-address>"}]' \
  --user-pool-id <user-pool-id>
```
(user-attributesは必須項目にあわせて追加)

で、これだとメールが「認証済み」にならない(email_verifiedがいっぺんに設定できない)ので、

```bash
aws cognito-idp admin-update-user-attributes \
  --user-pool-id <user-pool-id> \
  --username <username> \
  --user-attributes '[{"Name": "email_verified", "Value": "true"}]'
```

sign-up はアプリケーションクライアントIDが引数なのに、
admin-update-user-attributes はプールIDが引数。
変だけど本当。

* [sign-up — AWS CLI 2.1.29 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/2.1.29/reference/cognito-idp/sign-up.html)
* [admin-update-user-attributes — AWS CLI 2.9.19 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/admin-update-user-attributes.html)
