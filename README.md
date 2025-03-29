# eks-3tier_terraform_gitactions
Sample project of terraform ecs_ecr_eks services with github actions

Three-Tier Application on AWS EKS with Terraform + GitHub Actions
🚀 Architecture Overview
Frontend: Node.js React app (Dockerized)

Backend: Python Flask app (Dockerized)

Database: MySQL container

Deployment: AWS EKS

Ingress: AWS ALB Ingress Controller

Autoscaling: Horizontal Pod Autoscaler for backend

CI/CD: GitHub Actions

🔥 Pre-requisites
AWS CLI configured

Terraform CLI installed

kubectl installed

AWS ECR access

GitHub repository secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

🪄 How it works
✅ Push code → Automatically builds images → Push to ECR → Deploy Infra & Apps → Create Ingress → Apply Autoscaler

⚙️ Deployment Steps
Clone Repository

bash
Copy
Edit
git clone https://github.com/your-repo.git
cd project-root
Update Variables In terraform/terraform.tfvars, update:

h
Copy
Edit
aws_region      = "us-west-2"
cluster_name    = "my-cluster"
frontend_image  = "<your-aws-account>.dkr.ecr.us-west-2.amazonaws.com/my-frontend:latest"
backend_image   = "<your-aws-account>.dkr.ecr.us-west-2.amazonaws.com/my-backend:latest"
database_image  = "<your-aws-account>.dkr.ecr.us-west-2.amazonaws.com/my-database:latest"
Add AWS Secrets In your GitHub repo → Settings → Secrets → Actions:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

Push Code to Main Branch

bash
Copy
Edit
git add .
git commit -m "Initial infra setup"
git push origin main
✅ After GitHub Action Runs
You will get:

EKS Cluster ready

Frontend, Backend, Database pods deployed

HPA enabled for backend

ALB Ingress URL

Check resources:

bash
Copy
Edit
kubectl get all
kubectl get ingress
🌐 Access Application
ALB Ingress URL will be visible in:

bash
Copy
Edit
kubectl get ingress
Frontend → http://<alb-dns-name>/
Backend API → http://<alb-dns-name>/api

