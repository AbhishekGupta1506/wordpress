resource "aws_security_group" "sec_grp_pub_wordpress" {
  name = "sec_grp_pub"
  vpc_id = "${module.vpc.vpc_id}"
  description = "This a public security group"
  ingress  {
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = ["${var.network_ip_local}"]
  }
  ingress  {
      from_port = "80"
      to_port = "80"
      protocol = "tcp"
      cidr_blocks = ["${var.network_ip_local}"]
  }
  egress  {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "sec_grp_pub_wordpress"
  }
}

resource "aws_security_group" "sec_grp_pri_wordpress" {
  name = "sec_grp_pri"
  vpc_id = "${module.vpc.vpc_id}"
  description = "This a private security group"
  ingress  {
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["${var.public_subnet}","${var.private_subnet}"]
  }
  egress  {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "sec_grp_pri_wordpress"
  }
}
