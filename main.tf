provider "aws" {
    region = "eu-central-1"  # Change this to your desired AWS region
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

  security_groups = ["launch-wizard-1"]  # Change this to your security group

  # Additional configurations can go here
}


