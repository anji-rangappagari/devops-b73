#!/bin/bash

dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
useradd roboshop
mkdir /app 
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip
cd /app 
npm install 
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue

cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
dnf install mongodb-org -y
mongosh --host mongodb-dev.oneseven.space </app/db/master-data.js