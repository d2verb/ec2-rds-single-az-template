# ec2-rds-single-az-template

## なにこれ
Single-AZ 構成で EC2, RDS を構築する terraform テンプレート

## 前提
- terraform のインストール
  - see: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started
- aws cli のインストールおよび何かしらの aws profile の設定
  - see: https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-quickstart.html

## 構築方法
### 1. 鍵の生成

EC2 インスタンスに ssh アクセスするための秘密鍵・公開鍵を作成する。鍵の名前は `variables.tf` 内の設定と一致させないといけない

```
$ cd ~/.ssh
$ ssh-keygen -t rsa -f sample
$ ls ~/.ssh | grep sample
sample
sample.pub
```

### 2. 設定の変更

自身の環境や使い方に合わせて `variables.tf` 内の値を変更する


### 3. terraform apply の実行

terraform apply を実行して、yes を入力する
```
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:
...
Plan: 19 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + public_ip    = (known after apply)
  + rds_endpoint = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```
リソースの作成が完了すると、以下が出力される

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

ec2_endpoint = "ec2-*-***-**-**.ap-northeast-1.compute.amazonaws.com"
rds_endpoint = "terraform-********************.***********.ap-northeast-1.rds.amazonaws.com:3306"```

```

## 動作確認
### 1. EC2 の疎通確認
```
$ ssh -i ~/.ssh/sample ec2-user@ec2-*-***-**-**.ap-northeast-1.compute.amazonaws.com
...

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
11 package(s) needed for security, out of 35 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-0-1-8 ~]$
```

### 2. RDS の疎通確認
```
[ec2-user@ip-10-0-1-8 ~]$ sudo yum install -y mysql
[ec2-user@ip-10-0-1-8 ~]$ mysql -h terraform-********************.***********.ap-northeast-1.rds.amazonaws.com -u foo -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 5.7.33 Source distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> 
```