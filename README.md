# diana-project
This is repo for terraform project. Basic goal of the project is to test the opportunities for automated deployment and CI/CD Pipeline in Amazon Web Services in amazon micro service. Next goal is every step to be accomplished applying IaC concept using a tool for creating the code - in this case Terraform.
Description:
All configuration files and folders are created on a local VM (OS – Ubuntu 20.04 Server). After creation the project folder is pushed in the Diana-project repository. 
Prerequisites:  
1. AWS Cli installed;
2. Terraform v1.3.7 installed;
3. Vim editor. 

Project content   
I. Python Flask App. Name of the App – The big cat.

Description:
Containerized Python flask web application, stored in GitHub repository Diana-project. This app is the object for deployment in AWS cluster. The process of deployment will be carried out with CodeBuild Pipeline. The image of the application is created via Docker.

Prerequisites:  
1. Vim editor;
2. Python 3.8.10;
3. Docker 20.10.21.

The files for the web app are puted in flask-app folder, which contains a Makefile too. 

II. Infrastructure deployed in AWS - VPC, ECS Cluster (ECR, EC Services, Fargate), CI/CD Pipeline accomplished with CodeBuild in AWS.
Configuration files for the infrastructure are in ecr_ecs folder and this folder is the first part of project code that is deployed in AWS. 
Inftastructure elements.
  1. VPC - Name of VPC – diana-vpc. Virtual Private Cloud with CIDR block 10.0.0.0/16; Provider – Amazon Web Services; Default region – eu-central-1; Availability Zones – eu-central-1a & eu-central-1b. Contains 4 subnets – 2 public subnets with CIDR block 10.0.1.0/24 & 10.0.2.0/24 and 2 private subnets with CIDR block 10.0.3.0/24 & 10.0.4.0/24. Allowed ports in the VPC – 80; 443; 22; 8080.
  2. S3 backend - Name of the bucket - dianabucket1-demo. This resource is used for storing the tfstate file of the deployement.
  3. ECR Reporisory - Name of repo - flask-app-repo. This resource is created to store the docker images for the project.
  4. ECS Cluster - name of the cluster - demo-cluster. The cluster consists of Application Load Balancer to enable user traffic to the subnets in the VPC and its resources; defined ecs service and ECS task definition. 
  5. Codebuild - used for starting codebuild job whitch start automatically.

Project folders
  flask-app - this folder contains all the files for creating the docker image;
  ecsr_ecs - this folder contains all the files for the infrastructure; 
  codebuild - here is the terraform configuration for codebuild project;
  buildspec.yml - for codebuild project in AWS;
  secrets.tf - file with secret info for the project. This file is added to .gitignore so it is not in the project repo in GitHub.


