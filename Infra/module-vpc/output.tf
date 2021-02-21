output "subnet-pri-abg_id" {
    value = "${aws_subnet.subnet-pri-wordpress.id}"
}

output "subnet-pub-abg_id" {
    value = "${aws_subnet.subnet-pub-wordpress.id}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc-wordpress.id}"
}
