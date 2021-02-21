module "vpc" {
  source = "./module-vpc"
  region = "${var.region}"
  azs_list = "${var.azs}"
  vpc-cidr = "${var.vpc-cidr}"
  public_subnet = "${var.public_subnet}"
  private_subnet = "${var.private_subnet}"
}

# module "aws_instance_bastion" {
#   source = "./module-ec2-bastion"
#   AMIS = "${lookup(var.AMIS, var.region)}"
#   subnet_id = "${module.vpc.subnet-pub-abg_id}"
#   key_name = "aws_key_wordpress"
#   sec_grp = "${aws_security_group.sec_grp_pub_wordpress.id}"
#   file_name = "aws.pem"
#   instance_type = "${var.instance_type}"
#   private_key_path = "${var.private_key_path}"
#   name = "bastion"
# }

# module "aws_instance_private_wordpress" {
#   source = "./module-ec2-common"
#   AMIS = "${lookup(var.AMIS, var.region)}"
#   subnet_id = "${module.vpc.subnet-pri-abg_id}"
#   key_name = "aws_key_wordpress"
#   sec_grp = "${aws_security_group.sec_grp_pri_wordpress.id}"
#   file_name = "./scripts/wordpress.sh"
#   instance_type = "${var.instance_type}"
#   name = "wordpress"
# }

 module "aws_instance_wordpress" {
   source = "./module-ec2-common"
   AMIS = "${lookup(var.AMIS, var.region)}"
   subnet_id = "${module.vpc.subnet-pub-abg_id}"
   key_name = "aws_key_wordpress"
   sec_grp = "${aws_security_group.sec_grp_pub_wordpress.id}"
   file_name = "./scripts/wordpress.sh"
   compose_file_name = "./scripts/docker-compose.yml"
   instance_type = "${var.instance_type}"
   private_key_path = "${var.private_key_path}"
   name = "wordpress"
 }

