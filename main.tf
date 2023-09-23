provider "aws" {
    region = "eu-central-1"  # Change this to your desired AWS region
}

# Allow SSH traffic from local IP and from the IP range of the EC2_INSTANCE_CONNECT
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["85.144.249.55/32", "3.120.181.40/29"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "tryubuntu_instance" {
    ami           = "ami-04e601abe3e1a910f"  # ubuntu-jammy-22.04-amd64-server-20230516
    instance_type = "t2.micro"

  tags = {
    Name = "tryubuntu"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname tryubuntu
              EOF

  key_name = "tryubuntu"  # Change this to your key pair name

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Additional configurations can go here
}