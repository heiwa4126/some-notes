# AWS Managed Microsoft AD などのメモ

## AWS Managed Microsoft AD って AWS ポータルからユーザ追加できますか?

できません。

[Manage users and groups in AWS Managed Microsoft AD - AWS Directory Service](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/ms_ad_manage_users_groups.html)

AWS Directory Service のディレクトリにユーザーとグループを作成するには、AWS Directory Service のディレクトリに参加しているインスタンス（オンプレミスまたは EC2）を使用し、ユーザーとグループを作成する権限を持つユーザーとしてログインする必要がある。また、Active Directory Users and Computers スナップインを使用してユーザーとグループを追加できるように、EC2 インスタンスに Active Directory Tools をインストールする必要がある。

AWS Directory Service の管理コンソールから、Active Directory 管理ツールがあらかじめインストールされた EC2 インスタンスをデプロイできる。
詳細については、
[AWS Managed Microsoft AD Active Directory のディレクトリ管理インスタンスの起動](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/console_instance.html)を参照してください。

## AWS Managed Microsoft AD って「停止」がありませんよね?

はい。

## Cognito を Windows AD のかわりに使えますか?

つかえるみたいね。

[【AWS】Cognito ユーザプールを Azure AD を IdP として構築する(後編) #AWS - Qiita](https://qiita.com/kei1-dev/items/c8ae68e975dccb2902be)
