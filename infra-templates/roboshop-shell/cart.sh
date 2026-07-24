echo -e "\e[33mDisabling Node.js Module\e[0m"
dnf module disable nodejs -y  &>>/tmp/roboshop.log

echo -e "\e[33mEnabling Node.js Module\e[0m"
dnf module enable nodejs:20 -y  &>>/tmp/roboshop.log

echo -e "\e[33mInstalling Node.js\e[0m"
dnf install nodejs -y  &>>/tmp/roboshop.log

echo -e "\e[33mCreating roboshop User\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33mCreating /app Directory\e[0m"
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[33mDownloading Cart Application\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>/tmp/roboshop.log
cd /app 
unzip /tmp/cart.zip &>>/tmp/roboshop.log

echo -e "\e[33mInstalling Cart Application Dependencies\e[0m"
cd /app 
npm install  &>>/tmp/roboshop.log
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/cart.service /etc/systemd/system/cart.service  &>>/tmp/roboshop.log

echo -e "\e[33mLoading the service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStarting the service\e[0m"
systemctl enable cart  &>>/tmp/roboshop.log
systemctl start cart &>>/tmp/roboshop.log