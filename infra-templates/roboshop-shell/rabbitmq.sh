
echo -e "\e[33mInstalling Erlang Repository\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>/tmp/roboshop.log

echo -e "\e[33mInstalling RabbitMQ Repository\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[33mInstalling RabbitMQ\e[0m"
dnf install rabbitmq-server -y  &>>/tmp/roboshop.log


echo -e "\e[33mStarting RabbitMQ Service\e[0m"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log