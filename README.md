# Desafio Técnico de DevOps
## 📝  Descrição do Projeto
Este projeto é um teste de conhecimento, com toda a aplicação rodando localmente. O objetivo é orquestrar containers com Terraform usando Docker, configurando uma API que executa um script SQL em um banco de dados Postgres 15.8 e um frontend que se comunica com o backend através de um proxy reverso configurado no Nginx.

## 🛠 Tecnologias Utilizadas
- Docker: Contêineres para o frontend, backend e banco de dados.
- Terraform: Orquestração da infraestrutura.
- JavaScript: Desenvolvimento do frontend e backend.

## 📋 Pré-requisitos
- Sistema Operacional: Windows
- Ferramentas: Docker Desktop, Terraform, Git

## Variáveis
Edite o arquivo values.tfvars com os valores das variáveis que desejar:

password_db="sua_senha"
user_db="seu_usuario"
db="sua_base_de_dados"

## Estrutura de Pastas

teste_conhecimento
├── app
│   ├── backend
│   │   └── sql
│   ├── frontend
├── infraestrutura
│   └── terraform
├── scripts

- Backend: Contém a estrutura da API, incluindo dependências, Dockerfile e server.js. Explicação: O backend se comunica com o banco de dados Postgres 15.8 e executa um SQL localizado em backend/sql.
SQL: Diretório onde o arquivo script.sql está localizado para ser executado na API.
- Frontend: Contém a configuração do Nginx e o index.html. Explicação: A configuração do Nginx atua como um proxy reverso para permitir o acesso ao backend no container, através de http://backend:3000/api.
- Infraestrutura/Terraform: Diretório onde estão os arquivos do Terraform. Explicação: Este diretório contém três arquivos: main.tf com toda a estrutura de orquestração dos containers e variáveis de ambiente; variables.tf para definir as variáveis; e values.tfvars onde devem ser configuradas as variáveis de conexão da API com o banco de dados.

# 🚀 Inicialização do Projeto
- Clone o repositório:
`git clone https://github.com/seuusuario/desafio-tecnico.git`

- Configure as variáveis de ambiente: Edite o arquivo infraestrutura/terraform/values.tfvars com as credenciais do banco de dados.

- Execute o script de inicialização na raiz do projeto:
`.\automation.ps1`

# Melhorias de Projeto
A orquestração de containers com Docker é prática e rápida, mas traz limitações de escalabilidade e simplicidade. Para uma solução com maior escalabilidade, disponibilidade e segurança, seria ideal utilizar um cluster Kubernetes. Outras melhorias incluem:

- Utilizar Kubernetes para uma melhor gestão de containers.
- Configurar o uso correto de Secrets e ConfigMaps para maior segurança.
- Implementar um Ingress Controller para gerenciar rotas de endereçamento dentro de um cluster.
- Criar Serviços para API, frontend e banco de dados Postgres.
- Adicionar um Load Balancer para expor o endereço IP externo.
- Configurar um DNS para o IP do Load Balancer, tornando a aplicação acessível via internet.

## Autor: Kollinn Costa Benvenutti
### Data: 04/11/2024