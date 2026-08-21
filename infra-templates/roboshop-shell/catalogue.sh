#!/bin/bash
echo -e "\e[33m Configuring NodeJS Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Node.js\e[0m"
dnf module disable nodejs -y &>>/tmp/roboshop.log
dnf module enable nodejs:20 -y &>>/tmp/roboshop.log
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd Application User\e[0m"
useradd roboshop    &>>/tmp/roboshop.log

echo -e "\e[33mCreate Application Directory\e[0m]"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownload Application Content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtract Application Content\e[0m"
cd /app 
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[33mInstall NodeJS Dependencies\e[0m"
cd /app 
npm install &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD Service\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[33mStart catalogue service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue  &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log

echo -e "\e[33mCopy MongoDB Repo file\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstall MongoDB Client\e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema\e[0m"
mongosh --host mongodb-dev.oneseven.space </app/db/master-data.js &>>/tmp/roboshop.log