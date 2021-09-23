variable "aws_config" {
  type = map(string)
  default = {
    profile = "default"
    region  = "ap-northeast-1"
  }
}

variable "project" {
  type    = string
  default = "sample"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/sample.pub"
}

variable "ec2_ingress_allowed_ip" {
  type = map(list(string))
  default = {
    http = ["0.0.0.0/0"]
    ssh  = ["0.0.0.0/0"]
  }
}

variable "db_config" {
  default = {
    "username" = "foo"
    "password" = "foobarbaz"
  }
}