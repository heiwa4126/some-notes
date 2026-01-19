AWS のコンソールで
別のアカウントの特定ロールに
切り替えられる。

切り替え先から
さらに別のロールにスイッチはできない。
(一旦戻る)

スイッチ先は「履歴」にのこって
2 回目からはかんたんに切り替えられる。
「履歴」がどこにのこってるのかはよくわからない(ブラウザ側)

```
# スイッチ元
$ aws sts get-caller-identity
{
    "UserId": "AAAAAAAAAAAAAAAAAAAAA",
    "Account": "666666666666",
    "Arn": "arn:aws:iam::666666666666:user/hugahoge"
}

# スイッチ先
$ aws sts get-caller-identity
{
    "UserId": "BBBBBBBBBBBBBBBBBBBBB:hugahoge",
    "Account": "777777777777",
    "Arn": "arn:aws:sts::777777777777:assumed-role/foobar-switch-role/hugahoge"
}
```

ひとの作った

- スイッチ先のロール
- スイッチ元のポリシー

は再利用できるのでちょっと危ない。
スイッチ先のロールで制限かけられれば...

sts:AssumeRole で制限できそう。

自分が見かけたスイッチ先のロールのポリシー例

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::666666666666:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

上の例は

- 信頼されたエンティティはアカウント 666666666666 で
- MFA 必須

参考:

- [【Switch Role】特定のIAMユーザだけに権限を付与するには？信頼済アクセスを編集！│Soy Pocket](https://soypocket.com/it/switchrole-json-user-controle/)
- [【IAM】スイッチロールの運用について考えてみた | DevelopersIO](https://dev.classmethod.jp/articles/switch-role-operation/)

なぜ principal にはグループが設定できないのだろう...
ユーザグループを作ってグループベースで空のロール割り当てればいけるだろうか。

- [AWS JSON ポリシーの要素: Principal - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_principal.html)
- [IAM ユーザーグループ - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_groups.html)
