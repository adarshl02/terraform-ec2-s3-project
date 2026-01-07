resource "aws_instance" "my-ec2" {
  ami                         = "ami-068c0051b15cdb816"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.allow-tls.id]
  associate_public_ip_address = true

  key_name             = "my-terraform-key"
  iam_instance_profile = aws_iam_instance_profile.connect-ec2-s3-profile.name
  tags = {
    Name = "terraform-my-ec2"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
                echo "<html><body><h1>Hello from Terraform!</h1></body></html>" > /usr/share/nginx/html/index.html
                EOF 
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "my-terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_ec2_instance_state" "my-ec2-state" {
  instance_id = aws_instance.my-ec2.id
  state       = "running"
}

