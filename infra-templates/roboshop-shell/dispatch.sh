set -e
component=dispatch
source common.sh

echo -e "${colour}Installing GoLang${nocolour}"
dnf install golang unzip -y &>>${log_file}

echo -e "${colour}Creating roboshop User${nocolour}"
id roboshop &>>${log_file} || useradd roboshop &>>${log_file}

echo -e "${colour}Creating /app Directory${nocolour}"
mkdir -p /app

echo -e "${colour}Downloading ${component} Application${nocolour}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>${log_file}

echo -e "${colour}Extracting ${component} Application${nocolour}"
cd /app
unzip -o /tmp/${component}.zip &>>${log_file}

echo -e "${colour}Building ${component} Application${nocolour}"
cd /app
go mod init ${component} &>>${log_file} || true
go get &>>${log_file}
go build &>>${log_file}
chown -R roboshop:roboshop /app

echo -e "${colour}Configuring ${component} Service${nocolour}"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

echo -e "${colour}Loading the service${nocolour}"
systemctl daemon-reload &>>${log_file}

echo -e "${colour}Starting the service${nocolour}"
systemctl enable ${component} &>>${log_file}
systemctl start ${component} &>>${log_file}
