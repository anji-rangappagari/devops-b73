#!/bin/bash
component=catalogue
source common.sh

echo -e "${colour} Configuring NodeJS Repos${noclour}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${log_file}

echo -e "${colour} Installing Node.js${noclour}"
dnf module disable nodejs -y &>>${log_file}
dnf module enable nodejs:20 -y &>>${log_file}
dnf install nodejs -y &>>${log_file}

echo -e "${colour}Add Application User${noclour}"
useradd roboshop    &>>${log_file}

echo -e "${colour}Create Application Directory${noclour}"
rm -rf ${app_path}
mkdir ${app_path} &>>${log_file}

echo -e "${colour}Download Application Content${noclour}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>${log_file}

echo -e "${colour}Extract Application Content${noclour}"
cd ${app_path}
unzip /tmp/${component}.zip &>>${log_file}

echo -e "${colour}Install NodeJS Dependencies${noclour}"
cd ${app_path} 
npm install &>>${log_file}

echo -e "${colour}Setup SystemD Service${noclour}"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

echo -e "${colour}Start ${component} service${noclour}"
systemctl daemon-reload &>>${log_file}
systemctl enable ${component}  &>>${log_file}
systemctl start ${component} &>>${log_file}

echo -e "${colour}Copy MongoDB Repo file${noclour}"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

echo -e "${colour}Install MongoDB Client${noclour}"
dnf install mongodb-org -y &>>${log_file}

echo -e "${colour}Load Schema${noclour}"
mongosh --host mongodb-dev.oneseven.space </app/db/master-data.js &>>${log_file}