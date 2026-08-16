set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo -e "\e[33mInstalling Maven\e[0m"
dnf install maven unzip mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mCreating roboshop User\e[0m"
id roboshop &>>/tmp/roboshop.log || useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreating /app Directory\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[33mDownloading Shipping Application\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtracting Shipping Application\e[0m"
cd /app
unzip -o /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33mBuilding Shipping Application\e[0m"
cd /app
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log
chown -R roboshop:roboshop /app

echo -e "\e[33mConfiguring Shipping Service\e[0m"
cp "${SCRIPT_DIR}/shipping.service" /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[33mLoading Shipping Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable shipping &>>/tmp/roboshop.log
systemctl start shipping &>>/tmp/roboshop.log

echo -e "\e[33mInitializing Shipping Database\e[0m"
# shipping-v3: schema + app user + countries/cities master data
mysql -h mysql-dev.oneseven.space -uroot -p'RoboShop@1' </app/db/schema.sql &>>/tmp/roboshop.log
mysql -h mysql-dev.oneseven.space -uroot -p'RoboShop@1' </app/db/app-user.sql &>>/tmp/roboshop.log
mysql -h mysql-dev.oneseven.space -uroot -p'RoboShop@1' </app/db/master-data.sql &>>/tmp/roboshop.log

echo -e "\e[33mRestarting Shipping Service\e[0m"
systemctl restart shipping &>>/tmp/roboshop.log
