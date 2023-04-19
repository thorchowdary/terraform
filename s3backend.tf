resource "aws_instance" "apache" {
  ami           = "ami-0f8ca728008ff5af4"
  instance_type = "t2.micro"
  key_name      = "myServer" #if key name with myserver it will take that or else it wont conider the key name
  vpc_security_group_ids = [
    aws_security_group.admin-securityGroup.id,
    aws_security_group.enduser-securityGroup.id
  ]
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install httpd -y
                systemctl start httpd
                systemctl enable httpd
                EOF

  tags = {
    name = "instance creation with terraform"
  }
}
resource "aws_security_group" "admin-securityGroup" {

  name_prefix = "admin-securityGroup"
  description = "admin security group"
  vpc_id      = "vpc-0cb60141dc3b724db"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "admins security group"
  }

}

resource "aws_security_group" "enduser-securityGroup" {
  name_prefix = "enduer-securityGroup"
  description = "enduser-securityGroup"
  vpc_id      = "vpc-0cb60141dc3b724db"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "end-user security group creation"
  }
}

terraform {
  backend "s3" {
    bucket = "karmaisabitch"
    key    = "app/khyathi/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

