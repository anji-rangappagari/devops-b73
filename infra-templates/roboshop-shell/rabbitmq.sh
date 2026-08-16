set -e
component=rabbitmq
source common.sh
echo -e "${colour}Installing Erlang Repository${nocolour}"
curl -s https://packagecloud.io/install/repositories/${component}/erlang/script.rpm.sh | bash  &>>${log_file}

echo -e "${colour}Installing RabbitMQ Repository${nocolour}"
curl -s https://packagecloud.io/install/repositories/${component}/${component}-server/script.rpm.sh | bash &>>${log_file}

echo -e "${colour}Installing RabbitMQ${nocolour}"
dnf install ${component}-server -y  &>>${log_file}


echo -e "${colour}Starting RabbitMQ Service${nocolour}"
systemctl enable ${component}-server &>>${log_file}
systemctl start ${component}-server &>>${log_file}