
[Cloud modules — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/modules/list_of_cloud_modules.html#amazon)
[Amazon Web Services ガイド — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/scenario_guides/guide_aws.html)
[Amazon Web Services Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html)
[Ansible Galaxy](https://galaxy.ansible.com/community/aws)


pythonは3.8以上おすすめ (2021-05)

RHEL8だったら 
```sh
sudo yum install python39 python39-setuptools python39-pip
```
あと他のバージョンのpython3を消す。

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

`amazon.aws`と`community.aws`の2つがある。

```sh
ansible-galaxy collection install amazon.aws -f
ansible-galaxy collection install community.aws -f
```

[How To Create A VPC In AWS using Ansible](https://www.infinitypp.com/ansible/create-vpc-ansible-aws/)

どうもVPCとサブネットの関係がわかってないことに気がついた。
[VPC とサブネット \- Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/VPC_Subnets.html)
VPCがCIDR複数持てるし。


# amazon.aws.ec2

`exact_count`
で指定した数だけインスタンスが立つようにする。

インスタンスの同一性は
`count_tag`
で指定したタグの一致で見る。

`instance_tags`
は、ほかの`tags:`と同じ。

例えば
```yaml
        instance_tags:
          Name: "test1"
          Owner: "{{ owner }}"
        count_tag:
          Name: "test1"
        exact_count: 2
```

Name = test1というタグのついたインスタンスがすでに2つあれば何もしない。


- [amazon\.aws\.ec2 – create, terminate, start or stop an instance in ec2 — Ansible Documentation](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_module.html)
- [AnsibleによるEC2インスタンスの構築 \| DevelopersIO](https://dev.classmethod.jp/articles/ec2_using_ansible/#toc-4)



タグの一致以外にタグの存在も条件に指定できる。参考:
[instances with tags foo & bar & baz=bang](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_module.html#examples)


