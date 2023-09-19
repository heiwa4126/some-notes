# CodeCommitで驚いたこと

レポジトリにリージョンがある。

# HTTPS (GRC)で驚いたこと

認証はAWS IAMユーザの「アクセスキー」の方で行う。
「AWS CodeCommit の HTTPS Git 認証情報」の方は使わない。

```sh
pip3 install --user -U git-remote-codecommit
```

でインストール。

.git/configはこんな感じ

```
(略)
[remote "codecommit1"]
    url = codecommit::us-east-1://sam-hello-py
    fetch = +refs/heads/*:refs/remotes/origin/*
(略)
```

んで

```sh
AWS_PROFILE=codecommit1 git push codecommit1
```

みたいに使う。
