set -e

echo -e "\e[33mInstalling Python 3\e[0m"
dnf install python3 gcc python3-devel unzip -y &>>/tmp/roboshop.log

echo -e "\e[33mCreating roboshop User\e[0m"
id roboshop &>>/tmp/roboshop.log || useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreating /app Directory\e[0m"
mkdir -p /app

echo -e "\e[33mDownloading Payment Application\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtracting Payment Application\e[0m"
cd /app
unzip -o /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[33mInstalling Payment Dependencies\e[0m"
cd /app
pip3 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[33mConfiguring Payment Service\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log

echo -e "\e[33mLoading the service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStarting the service\e[0m"
systemctl enable payment &>>/tmp/roboshop.log
systemctl start payment &>>/tmp/roboshop.log
