
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
```して、
[Linux での AWS CLI バージョン 2 のインストール、更新、アンインストール](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html)


`ansible-galaxy collection install community.aws`