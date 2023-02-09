# diana-project
This is repo for terraform project
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
Configuration files for the infrastructure are in ecr_ecs folder and 



