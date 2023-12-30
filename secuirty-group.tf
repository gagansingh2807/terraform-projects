# create security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "alb-security-group"
  description = "Enable HTTP/HTTPS access on port 80/443"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# create security group for the bastion host aka jump box
resource "aws_security_group" "ssh_security_group" {
  name        = "ssh-security-group"
  description = "Enable SSH access on port 22"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_location]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-security-group"
  }
}

# create security group for the web server
resource "aws_security_group" "webserver_security_group" {
  name        = "webserver-security-group"
  description = "Enable HTTP/HTTPS access on port 80/443 via ALB SG and access on port 22 via SSH SG"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "HTTP access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "HTTPS access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver-security-group"
  }
}

# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = "database-security-group"
  description = "Enable MySQL/Aurora access on port 3306"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "MySQL/Aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-security-group"
  }
}
