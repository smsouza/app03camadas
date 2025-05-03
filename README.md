# Terraform AWS 3-Tier- Arquitetura com 03 camadas

Este projeto cria uma infraestrutura completa em 3 camadas (Web, App e Banco de Dados) na AWS usando Terraform. Inclui integração com Jenkins para automação da entrega de infraestrutura.

## ✅ Componentes

- VPC com sub-redes públicas e privadas
- NAT Gateway e Internet Gateway
- Auto Scaling Group com Launch Template (EC2)
- Application Load Balancer (ALB)
- Banco de Dados RDS (MySQL)
- Grupos de Segurança personalizados
- IAM Role para EC2 com SSM
- Pipeline Jenkins com Terraform

---

## 📁 Estrutura do Projeto

```
terraform-aws-3tier/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── vpc.tf
├── security_groups.tf
├── ec2_autoscaling.tf
├── alb.tf
├── rds.tf
└── iam.tf
```

Pipeline separado:
```
jenkinsfile_terraform_pipeline/
└── Jenkinsfile
```

---

## 🚀 Como usar

### 1. Pré-requisitos

- AWS CLI configurado ou credenciais exportadas via ambiente
- Terraform instalado
- Jenkins com plugins:
  - Pipeline
  - AWS Credentials

### 2. Comandos Terraform (local)

```bash
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
```
### 3. Comandos para subir no GITHUB

```bash
# Inicialize o repositório
git init
git add .
git commit -m "Infraestrutura AWS 3 camadas com Jenkins e Terraform"

# Crie o repositório no GitHub (via interface ou CLI)
# Exemplo usando GitHub CLI:
gh repo create infra-terraform-aws --public --source=. --remote=origin

# Push inicial
git push -u origin main

### 4. Comandos para subir no GITHUB

- Crie credenciais AWS no Jenkins com ID `aws-creds`
- Adicione o `Jenkinsfile` no repositório ou configure manualmente o pipeline apontando para ele
- A pipeline executará: `init`, `plan` e aguardará confirmação antes do `apply`

---

## 🔐 Segurança

- As senhas (como do RDS) estão em variáveis Terraform — ideal movê-las para o `terraform.tfvars` ou usar secrets externos

---

## 📦 Saídas (Outputs)

- ALB DNS
- Endpoint do RDS

---

## 📄 Licença

MIT
