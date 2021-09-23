provider "aws" {
  profile = var.aws_config["profile"]
  region  = var.aws_config["region"]
}
