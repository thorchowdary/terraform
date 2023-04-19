resource "aws_security_group" "prometheus-sg" {

  name        = "promgrafana-sg"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http from VPC"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "promgrafana-sg"
  }

}

resource "aws_security_group" "grafana-sg" {
  name        = "grafana-sg"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "promgrafana-sg"
  }

}

resource "aws_security_group" "apache-sg" {
  name        = "apache-sg"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "prom to apache"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = ["${aws_security_group.prometheus-sg.id}"]
  }

  ingress {
    description     = "node exported to prom"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = ["${aws_security_group.prometheus-sg.id}"]

  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache-sg"
  }


}

resource "aws_instance" "prometheus" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.id
  vpc_security_group_ids = ["${aws_security_group.prometheus-sg.id}"]
  user_data              = data.template_file.prom.rendered
  tags = {
    Name = "prometheus"
  }
}

resource "aws_instance" "grafana" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.id
  vpc_security_group_ids = ["${aws_security_group.grafana-sg.id}"]
  user_data              = data.template_file.grafana.rendered

  tags = {
    Name = "grafana"
  }
}

resource "aws_instance" "apache" {

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.id
  vpc_security_group_ids = ["${aws_security_group.apache-sg.id}"]
  user_data              = data.template_file.apache.rendered
  tags = {
    "Name" = "apache"
  }

}

terraform {
  backend "s3" {

    bucket = "ktkt07"
    region = "ap-south-1"
    key    = "tf_state/terraform.tfstate"


  }
}
