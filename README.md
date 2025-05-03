🛠️ 1. Estrutura Final do Repositório
css
Copiar
Editar
infra-terraform-aws/
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── vpc.tf
│   ├── security_groups.tf
│   ├── ec2_autoscaling.tf
│   ├── alb.tf
│   ├── rds.tf
│   ├── iam.tf
│   ├── terraform.tfvars.example
│   └── .gitignore
├── pipeline/
│   └── Jenkinsfile
└── README.md
🧾 2. Comandos para subir no GitHub
bash
Copiar
Editar
# Inicialize o repositório
git init
git add .
git commit -m "Infraestrutura AWS 3 camadas com Jenkins e Terraform"

# Crie o repositório no GitHub (via interface ou CLI)
# Exemplo usando GitHub CLI:
gh repo create infra-terraform-aws --public --source=. --remote=origin

# Push inicial
git push -u origin main
Se não usar o GitHub CLI, crie o repositório manualmente e siga as instruções de push fornecidas pelo GitHub após a criação.

✅ Dicas
Nunca adicione terraform.tfvars real ao Git – use apenas o .example

Mantenha o Jenkinsfile fora do diretório principal, como feito acima

Use branches para mudanças maiores, e considere adicionar um GitHub Actions para validar o terraform plan
