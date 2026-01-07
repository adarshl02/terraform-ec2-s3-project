resource "aws_security_group" "allow-tls" {
  name        = "my-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.my-vpc.id
  tags = {
    Name = "terraform-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-tls-ssh" {
  security_group_id = aws_security_group.allow-tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow-tls-http" {
  security_group_id = aws_security_group.allow-tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "allow-tls-all" {
  security_group_id = aws_security_group.allow-tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}