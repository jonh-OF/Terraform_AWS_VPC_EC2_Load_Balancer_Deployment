data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/*"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "primer_server" {

  name   = "server_primer"
  vpc_id = module.network.vpc_id
  ingress {
    description = "HTTP conexion"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "permitir trafico de salida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "server" {

  name   = "server_primer"
  vpc_id = module.network.vpc_id
  ingress {
    description = "SSH conexion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "permitir trafico de salida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "web" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "web" {
  key_name   = "web key"
  public_key = tls_private_key.web.public_key_openssh

}


resource "aws_instance" "web" {
  count                       = var.server_count
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = var.tipo_de_instancia
  key_name                    = aws_key_pair.web.key_name
  subnet_id                   = module.network.public_subnets[count.index]
  associate_public_ip_address = var.include_ipv4
  vpc_security_group_ids      = [aws_security_group.primer_server.id]
  tags = {
    name = "web-${count.index}"
  }
}


resource "aws_instance" "privstate_web" {
  count                       = var.server_count
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = var.tipo_de_instancia
  key_name                    = aws_key_pair.web.key_name
  subnet_id                   = module.network.private_subnets[count.index]
  associate_public_ip_address = var.include_ipv4
  vpc_security_group_ids      = [aws_security_group.server.id]

  user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install nginx -y
                systemctl start nginx
                systemctl enable nginx
                echo "<h1>¡Hola desde Terraform + Nginx!</h1>" > /var/www/html/index.html
                EOF
  tags = {
    name = "privastate-web${count.index}"
  }
}


resource "aws_lb" "primer_server" {
  name               = local.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.primer_server.id]
  subnets            = module.network.public_subnets

  enable_deletion_protection = false

  tags = {
    name = "${local.lb_name}"
  }
}
resource "aws_lb_target_group" "primer_server" {
  name     = "${local.lb_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
}

resource "aws_lb_listener" "primer_server" {
  load_balancer_arn = aws_lb.primer_server.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primer_server.arn
  }
}

resource "aws_lb_listener_rule" "primer_server" {
  listener_arn = aws_lb_listener.primer_server.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primer_server.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }


}


resource "aws_lb_target_group_attachment" "primer_server" {
  count            = var.server_count
  target_group_arn = aws_lb_target_group.primer_server.arn
  target_id        = aws_instance.privstate_web[count.index].id
  port             = 80
}

output "enpint" {
  value = aws_lb.primer_server.dns_name
  
}