
[Cloud modules — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/modules/list_of_cloud_modules.html#amazon)
[Amazon Web Services ガイド — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/scenario_guides/guide_aws.html)
[Amazon Web Services Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html)
[Ansible Galaxy](https://galaxy.ansible.com/community/aws)



awscliがv1でper userに入ってたら
```
$PIP3 install --user -U boto boto3 botocore awscli
```
awscli v2はpipでなくなった。
v2に入れ替えたほうが

```
$PIP3 uninstall awscli
```
して、
[Linux での AWS CLI バージョン 2 のインストール、更新、アンインストール](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html)

バージョンがあわなくて
```
pip3 install --user -U requests
```
がいる場合もあり。↓みたいな警告が出る
> /usr/lib/python3/dist-packages/requests/__init__.py:80: RequestsDependencyWarning: urllib3 (1.26.4) or chardet (3.0.4) doesn't
 match a supported version!
  RequestsDependencyWarning)



`ansible-galaxy collection install community.aws`


[How To Create A VPC In AWS using Ansible](https://www.infinitypp.com/ansible/create-vpc-ansible-aws/)

どうもVPCとサブネットの関係がわかってないことに気がついた。
[VPC とサブネット \- Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/VPC_Subnets.html)
VPCがCIDR複数持てるし。
