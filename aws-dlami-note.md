# AWS DLAMI (Deep Learning AMI)

## issues

ログインした時に出るメッセージをコピペしておく

```text
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1021-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Thu Jan 16 05:45:08 UTC 2025

  System load:  0.04                Processes:             541
  Usage of /:   35.2% of 387.48GB   Users logged in:       0
  Memory usage: 0%                  IPv4 address for eth0: 10.0.150.62
  Swap usage:   0%

 * Ubuntu Pro delivers the most comprehensive open source security and
   compliance features.

   https://ubuntu.com/aws/pro

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

26 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm

New release '24.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


1 updates could not be installed automatically. For more details,
see /var/log/unattended-upgrades/unattended-upgrades.log

=============================================================================
AMI Name: Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.5.1 (Ubuntu 22.04)
Supported EC2 instances: G4dn, G5, G6, Gr6, G6e, P4, P4de, P5, P5e
* To activate pre-built pytorch environment, run: 'source activate pytorch'
NVIDIA driver version: 550.127.05
CUDA versions available: cuda-12.4
Default CUDA version is 12.4

Release notes: https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html
AWS Deep Learning AMI Homepage: https://aws.amazon.com/machine-learning/amis/
Developer Guide and Release Notes: https://docs.aws.amazon.com/dlami/latest/devguide/what-is-dlami.html
Support: https://forums.aws.amazon.com/forum.jspa?forumID=263
For a fully managed experience, check out Amazon SageMaker at https://aws.amazon.com/sagemaker
=============================================================================
Last login: Thu Jan 16 05:10:21 2025 from 127.0.0.1
```

なんで 22.04?
