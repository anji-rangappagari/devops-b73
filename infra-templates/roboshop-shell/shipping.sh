echo -e "\e[33mInstalling Maven\e[0m"
dnf install maven -y  &>>/tmp/roboshp.log

echo -e "\e[33mCreating roboshop User\e[0m"
useradd roboshop &>>/tmp/roboshp.log

echo -e "\e[33mCreating /app Directory\e[0m"
mkdir /app  &>>/tmp/roboshp.log

echo -e "\e[33mDownloading Shipping Application\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>/tmp/roboshp.log

echo -e "\e[33mExtracting Shipping Application\e[0m"
cd /app 
unzip /tmp/shipping.zip &>>/tmp/roboshp.log

echo -e "\e[33mBuilding Shipping Application\e[0m"
cd /app 
mvn clean package &>>/tmp/roboshp.log
mv target/shipping-1.0.jar shipping.jar  &>>/tmp/roboshp.log

echo -e "\e[33mConfiguring Shipping Service\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshp.log

echo -e "\e[33mReloading Systemd Daemon and starting Shipping Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshp.log
systemctl enable shipping  &>>/tmp/roboshp.log
systemctl start shipping &>>/tmp/roboshp.log

echo -e "\e[33mInstalling MySQL\e[0m"
dnf install mysql -y &>>/tmp/roboshp.log

echo -e "\e[33mInitializing Shipping Database\e[0m"
mysql -h mysql-dev.oneseven.space.oneseven.space -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshp.log

echo -e "\e[33mRestarting Shipping Service\e[0m"
systemctl restart shipping &>>/tmp/roboshp.log