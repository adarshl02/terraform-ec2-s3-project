output "terraform-ec2-ip" {
  value = aws_instance.my-ec2.public_ip
}

output "ec2-instance-id" {
  value = aws_instance.my-ec2.id
}

output "vpc-id" {
  value = aws_vpc.my-vpc.id
}

output "public-subnet-id" {
  value = aws_subnet.public-subnet-1.id
}