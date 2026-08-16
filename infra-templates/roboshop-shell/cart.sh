component=cart
source common.sh
echo -e "${colour}Disabling Node.js Module${nocolour}"
dnf module disable nodejs -y  &>>${log_file}

echo -e "${colour}Enabling Node.js Module${nocolour}"
dnf module enable nodejs:20 -y  &>>${log_file}

echo -e "${colour}Installing Node.js${nocolour}"
dnf install nodejs -y  &>>${log_file}

echo -e "${colour}Creating roboshop User${nocolour}"
useradd roboshop &>>${log_file}

echo -e "${colour}Creating ${app_path}Directory${nocolour}"
mkdir ${app_path} &>>${log_file}

echo -e "${colour}Downloading Cart Application${nocolour}"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>${log_file}
cd ${app_path}
unzip /tmp/cart.zip &>>${log_file}

echo -e "${colour}Installing Cart Application Dependencies${nocolour}"
cd ${app_path}
npm install  &>>${log_file}
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/cart.service /etc/systemd/system/cart.service  &>>${log_file}

echo -e "${colour}Loading the service${nocolour}"
systemctl daemon-reload &>>${log_file}

echo -e "${colour}Starting the service${nocolour}"
systemctl enable cart  &>>${log_file}
systemctl start cart &>>${log_file}