# GPU

## クラウド上の GPU

価格・性能などをまとめてるサイトがあって

- [AWS・Azure・Cudo などが提供するクラウド GPU が 1 時間あたり何ドルで利用できてどういう構成なのかの一覧表 - GIGAZINE](https://gigazine.net/news/20230528-cloud-gpus/)
- [Cloud GPUs - The Full Stack](https://fullstackdeeplearning.com/cloud-gpus/)

CSV も GitHub 上にある(というかサイトのソースが GitHub 管理)。

[website/docs/cloud-gpus/cloud-gpus.csv at main · the-full-stack/website](https://github.com/the-full-stack/website/blob/main/docs/cloud-gpus/cloud-gpus.csv)

## Ampere Volta Turing Kepler

NVIDIA(最近は全部大文字)の世代。

- [NVIDIA GPU の NVIDIA architectures のまとめ #CUDA - Qiita](https://qiita.com/k_ikasumipowder/items/1142dadba01b42ac6012)
- [List of Nvidia graphics processing units - Wikipedia](https://en.wikipedia.org/wiki/List_of_Nvidia_graphics_processing_units)

## AWS EC2 で CUDA

一番安いモデルは g4dn.xlarge
次に [Linux インスタンスへの NVIDIA ドライバーのインストール - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/install-nvidia-driver.html)

「NVIDIA ドライバーがインストールされた AMI」はろくなものがない。
[Tesla ドライバーを使用した Marketplace 製品: Search Results](https://aws.amazon.com/marketplace/search/results?searchTerms=tesla+driver&CREATOR=e6a5002c-6dd0-4d1e-8196-0a1d1857229b%2Cc568fe05-e33b-411c-b0ab-047218431da9&filters=CREATOR)
YUM がいいなら Amazon Linux 2... いやとてもおすすめできん。

次は
[1. Introduction — Installation Guide for Linux 12.3 documentation](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/)
