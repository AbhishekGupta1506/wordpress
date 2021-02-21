variable "AMIS" {}
variable "subnet_id" {}
variable "key_name" {}
variable "sec_grp" {}
variable "file_name" {}
variable "compose_file_name" {}
variable "instance_type" {}
variable "private_key_path" {}
variable "name" {}

data "template_file" "script" {
    template = "${file("${var.file_name}")}"
}

data "template_cloudinit_config" "config" {
    gzip = false
    base64_encode = false
    part {
        filename = "config.sh"
        content_type = "text/x-shellscript"
        content = "${data.template_file.script.rendered}"
    }
}
resource "aws_instance" "ec2_instance" {
    ami = "${var.AMIS}"
    instance_type = "${var.instance_type}"
    subnet_id = "${var.subnet_id}"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${var.sec_grp}"]
    user_data = "${data.template_cloudinit_config.config.rendered}"

    tags = {
        Name = "${var.name}"
    }

    provisioner "file" {
        source = "${var.compose_file_name}"
        destination = "~/docker-compose.yml"
    }

    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = "${file("${var.private_key_path}")}"
        host = "${self.public_ip}"
    }
}