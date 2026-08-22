set -e
component=rabbitmq
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source common.sh

echo -e "${colour}Configuring RabbitMQ repositories${nocolour}"
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/rabbitmq-release-signing-key.asc' &>>${log_file}
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key' &>>${log_file}
rpm --import 'https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key' &>>${log_file}
cp "${SCRIPT_DIR}/rabbitmq.repo" /etc/yum.repos.d/rabbitmq.repo &>>${log_file}
status_check $?

echo -e "${colour}Installing RabbitMQ${nocolour}"
dnf install logrotate erlang rabbitmq-server -y &>>${log_file}
status_check $?

echo -e "${colour}Starting RabbitMQ Service${nocolour}"
systemctl enable ${component}-server &>>${log_file}
systemctl start ${component}-server &>>${log_file}
status_check $?

echo -e "${colour}Creating Application User${nocolour}"
rabbitmqctl add_user roboshop $1 &>>${log_file} || true
rabbitmqctl set_user_tags roboshop administrator &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?
