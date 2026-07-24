echo -e "\e[33mInstalling MySQL\e[0m"
dnf install mysql-server -y  &>>/tmp/roboshop.log


echo -e "\e[33mStarting MySQL Service\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33m]Update default password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log