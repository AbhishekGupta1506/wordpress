variable "region" {
  default = "ap-south-1"
}

variable "azs" {
  type = "list"
  default = ["ap-south-1a","ap-south-1b"]
}


variable "public_key_path" {
  default = "./key/aws.pub"
}

variable "private_key_path" {
  default = "./key/aws"
}
variable "secret_key" {}

variable "access_key" {}

variable "AMIS" {
  type = "map"
  default = {
    ap-south-1 = "ami-08e0ca9924195beba"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-0d729a60"
  }
}

variable "vpc-cidr" {
  default = "10.127.0.0/24"
}

variable "public_subnet" {
  default = "10.127.0.0/26"
}

variable "private_subnet" {
  default = "10.127.0.128/26"
}

variable "network_ip_local" {
  default = "XXX.XXX.XXX.XXX/32"
}

variable "instance_type" {
  default = "t2.micro"
}