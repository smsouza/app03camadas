#####################
# variables.tf
#####################
variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "MySecurePass123!"
}


# Região da AWS onde os recursos serão criados
variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

# Bloco CIDR da VPC principal
variable "vpc_cidr_block" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Sub-redes públicas para Load Balancer e NAT Gateway
variable "public_subnets" {
  description = "Sub-redes públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Sub-redes privadas para instâncias EC2 e banco de dados
variable "private_subnets" {
  description = "Sub-redes privadas"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Zonas de disponibilidade onde os recursos serão distribuídos
variable "availability_zones" {
  description = "Zonas de disponibilidade"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Nome do par de chaves SSH para acesso às instâncias EC2
variable "key_name" {
  description = "Nome da chave SSH para EC2"
  type        = string
  default     = "minha-chave-ec2"
}

# Tipo de instância EC2
variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

# Tamanhos para o Auto Scaling Group
variable "autoscaling_min_size" {
  description = "Capacidade mínima do ASG"
  type        = number
  default     = 1
}

variable "autoscaling_max_size" {
  description = "Capacidade máxima do ASG"
  type        = number
  default     = 3
}

variable "autoscaling_desired_capacity" {
  description = "Capacidade desejada do ASG"
  type        = number
  default     = 2
}

# Configurações do banco de dados RDS
variable "rds_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Armazenamento alocado para o RDS (GB)"
  type        = number
  default     = 20
}

variable "rds_db_name" {
  description = "Nome do banco de dados RDS"
  type        = string
  default     = "appdb"
}

variable "rds_username" {
  description = "Usuário administrador do RDS"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Senha do RDS"
  type        = string
  sensitive   = true
  default     = "senha-segura123"
}
