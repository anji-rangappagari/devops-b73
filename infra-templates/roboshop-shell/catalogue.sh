#!/bin/bash

echo -e "\e[33mInstalling Node.js\e[0m"
dnf module list nodejs &>>/tmp/roboshop.log

echo -e "\e[33mEnabling Node.js module\e[0m"
dnf module disable nodejs:18 -y &>>/tmp/roboshop.log
dnf module enable nodejs:16 -y &>>/tmp/roboshop.log

echo -e "\e[33mInstalling Node.js\e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdding the application user\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreating the application directory\e[0m"
mkdir -p /app &>>/tmp/roboshop.log

echo -e "\e[33mDownloading the application content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>/tmp/roboshop.log
cd /app 

echo -e "\e[33mExtracting the application content\e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[33mInstalling the application dependencies\e[0m"
cd /app
npm install &>>/tmp/roboshop.log

cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[33mStarting the catalogue service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log

echo -e "\e[33mCopying the MongoDB repo file\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log 

echo -e "\e[33mInstalling MongoDB Client\e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log

echo -e "\e[33mLoading Schema\e[0m"
mongosh --host mongodb-dev.oneseven.space </app/db/master-data.js &>>/tmp/roboshop.log