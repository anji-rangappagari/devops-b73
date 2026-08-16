#!/bin/bash
component=catalogue
source common.sh

node_js

echo -e "${colour}Copy MongoDB Repo file${noclour}"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}

echo -e "${colour}Install MongoDB Client${noclour}"
dnf install mongodb-org -y &>>${log_file}

echo -e "${colour}Load Schema${noclour}"
mongosh --host mongodb-dev.oneseven.space </app/db/master-data.js &>>${log_file}