set -e
component=rabbitmq
source common.sh
echo -e "${colour}Installing Erlang Repository${nocolour}"
curl -s https://packagecloud.io/install/repositories/${component}/erlang/script.rpm.sh | bash  &>>${log_file}
status_check $?
echo -e "${colour}Installing RabbitMQ Repository${nocolour}"
curl -s https://packagecloud.io/install/repositories/${component}/${component}-server/script.rpm.sh | bash &>>${log_file}
status_check $?

echo -e "${colour}Installing RabbitMQ${nocolour}"
dnf install ${component}-server -y  &>>${log_file}
status_check $?


echo -e "${colour}Starting RabbitMQ Service${nocolour}"
systemctl enable ${component}-server &>>${log_file}
systemctl start ${component}-server &>>${log_file}
status_check $?

echo -e "${colour}Creating Application User${nocolour}"
rabbitmqctl add_user roboshop $1 &>>${log_file}
rabbitmqctl set_user_tags roboshop administrator &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?