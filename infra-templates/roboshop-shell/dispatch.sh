set -e

echo -e "\e[33mInstalling GoLang\e[0m"
dnf install golang unzip -y &>>/tmp/roboshop.log

echo -e "\e[33mCreating roboshop User\e[0m"
id roboshop &>>/tmp/roboshop.log || useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreating /app Directory\e[0m"
mkdir -p /app

echo -e "\e[33mDownloading Dispatch Application\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtracting Dispatch Application\e[0m"
cd /app
unzip -o /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[33mBuilding Dispatch Application\e[0m"
cd /app
go mod init dispatch &>>/tmp/roboshop.log || true
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log
chown -R roboshop:roboshop /app

echo -e "\e[33mConfiguring Dispatch Service\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log

echo -e "\e[33mLoading the service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStarting the service\e[0m"
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl start dispatch &>>/tmp/roboshop.log
