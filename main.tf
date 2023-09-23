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
              set -e  # Exit on error
              LOG_FILE="/var/log/user_data.log"
              hostnamectl set-hostname tryubuntu >> $LOG_FILE 2>&1
              sed -i 's/preserve_hostname: false/preserve_hostname: true/g' /etc/cloud/cloud.cfg >> $LOG_FILE 2>&1
              echo "manage_etc_hosts: false" | tee -a /etc/cloud/cloud.cfg >> $LOG_FILE 2>&1
              apt update -y >> $LOG_FILE 2>&1
              apt upgrade -y >> $LOG_FILE 2>&1
              apt install -y awscli ec2-instance-connect >> $LOG_FILE 2>&1
              shutdown -r +1 >> $LOG_FILE 2>&1
              EOF

  key_name = "tryubuntu"  # Change this to your key pair name

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Additional configurations can go here
}

# Output the instance hostname
output "instance_hostname" {
  value = aws_instance.tryubuntu_instance.tags["Name"]
  description = "The hostname of the deployed EC2 instance."
}

# Output the instance public IP address
output "instance_public_ip" {
  value = aws_instance.tryubuntu_instance.public_ip
  description = "The public IP address of the deployed EC2 instance."
}

# Output the instance private IP address
output "instance_private_ip" {
  value = aws_instance.tryubuntu_instance.private_ip
  description = "The private IP address of the deployed EC2 instance."
}
