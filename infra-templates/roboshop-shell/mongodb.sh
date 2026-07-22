#!/bin/bash

echo -e "\e[33mCopying the MongoDB repo file\e[0m"
cp mongodb.repo /etc/yum.repos.d/mongodb.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstalling MongoDB\e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log

## Modify the MongoDB configuration file to listen on all interfaces
echo -e "\e[33mModifying the MongoDB configuration file to listen on all interfaces\e[0m"
sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/' /etc/mongod.conf &>>/tmp/roboshop.log

echo -e "\e[33mStarting & Enabling MongoDB Service\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl start mongod &>>/tmp/roboshop.log