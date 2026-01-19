AWS, Azure and GCP
共通のメモ

- [rsyncっぽいもの](#rsyncっぽいもの)

# rsyncっぽいもの

S3 だったら `aws s3 sync` か?

- [AWS Command Line Interface での高レベルの S3 コマンドの使用 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/using-s3-commands.html)

Azure では `blobxfer` よさそうなので使ってみる。

- [CLI Commands and Usage - blobxfer](https://blobxfer.readthedocs.io/en/latest/10-cli-usage/)
- [Azure/blobxfer: Azure Storage transfer tool and data movement library](https://github.com/Azure/blobxfer)
- [blobxfer | Read the Docs](https://readthedocs.org/projects/blobxfer/)
- [blobxferでAzure Blob Storageにファイルを一括転送する - Qiita](https://qiita.com/takebayashi/items/5554dab2e0c1728c1f0d)

そもそも python2/3 のせいで、`az`や`aws`がちゃんと動くかややこしい。
いきなり pip 使うとわけがわからなくなるので、公式ドキュメントに従う。

- [apt を使用して Linux に Azure CLI をインストールする | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli-apt?view=azure-cli-latest)
- [AWS CLI のインストールと設定 - Amazon Kinesis Data Streams](https://docs.aws.amazon.com/ja_jp/streams/latest/dev/kinesis-tutorial-cli-installation.html)
