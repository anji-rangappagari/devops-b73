#!/bin/bash

echo -e "\e[33mDisabling Default MySQL Module\e[0m"
dnf module reset mysql -y &>>/tmp/roboshop.log
dnf module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mCopying MySQL Repository Configuration\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33mCleaning DNF Cache\e[0m"
dnf clean all &>>/tmp/roboshop.log

echo -e "\e[33mInstalling MySQL 5.7 Explicitly\e[0m"
dnf install --enablerepo=mysql57-community --disablerepo=mysql80-community mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[33mStarting MySQL Service\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33mSetting up roboshop password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log

echo -e "\e[33mChecking if the password is working?\e[0m"
mysql -uroot -pRoboShop@1 -e "SELECT VERSION();"