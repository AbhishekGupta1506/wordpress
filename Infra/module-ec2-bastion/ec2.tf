variable "AMIS" {}
variable "subnet_id" {}
variable "key_name" {}
variable "sec_grp" {}
variable "file_name" {}
variable "name" {}
variable "instance_type" {}
variable "private_key_path" {
}
resource "aws_instance" "ec2_instance" {
    ami = "${var.AMIS}"
    instance_type = "${var.instance_type}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${var.sec_grp}"]
    tags = {
        Name = "${var.name}"
    }

    provisioner "file" {
        source = "${var.file_name}"
        destination = "~/${var.file_name}"
    }

    connection {
        type = "ssh"
        user = "centos"
        private_key = "${file("${var.private_key_path}")}"
        host = "${self.public_ip}"
    }
}