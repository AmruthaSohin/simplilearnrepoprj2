provider "aws" {
  region = "us-east--1"
}

resource "aws_security_group" "dev_sg" {
  name = "dev-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "dev_server" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t2.micro"
  key_name      = "simplilearnjenkinkp"
  security_groups = [aws_security_group.dev_sg.name]

  tags = {
    Name = "Developer-VM"
  }

  provisioner "local-exec" {
    command = <<EOT
echo "[web]" > ../ansible/inventory
echo "${self.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=../ansible/key.pem" >> ../ansible/inventory
EOT
  }
}
