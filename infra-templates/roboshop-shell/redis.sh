
echo -e "\e[33mDisabling Redis Module\e[0m"
dnf module disable redis -y &>>/tmp/roboshop.log

echo -e "\e[33mEnabling Redis Module\e[0m"
dnf module enable redis:7 -y &>>/tmp/roboshop.log

echo -e "\e[33mInstalling Redis\e[0m"
dnf install redis -y  &>>/tmp/roboshop.log

echo -e "\e[33mConfiguring Redis\e[0m"
sed -i '/s|127.0.0.1|0.0.0.0|'  /etc/redis/redis.conf &>>/tmp/roboshop.log

echo -e "\e[33mStarting Redis Service\e[0m"
systemctl enable redis &>>/tmp/roboshop.log
systemctl start redis &>>/tmp/roboshop.log