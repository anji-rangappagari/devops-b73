echo -e "\e[33mDisabling MySQL Module\e[0m"
dnf module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mCopying MySQL Repository Configuration\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33mInstalling MySQL\e[0m"
dnf install mysql-server -y  &>>/tmp/roboshop.log


echo -e "\e[33mStarting MySQL Service\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33m]Update default password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log