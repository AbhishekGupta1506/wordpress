resource "aws_key_pair" "key_pub_name" {
  key_name = "aws_key_wordpress"
  public_key = "${file("${var.public_key_path}")}"
}
