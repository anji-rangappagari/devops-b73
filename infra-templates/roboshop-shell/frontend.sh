echo -e "\e[33mInstalling Nginx Server\e[0m"
dnf install nginx -y &>>/tmp/roboshop.log

echo -e "\e[33mRemoving old app content\e[0m"
rm -rf /usr/share/nginx/html/*  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading the front end content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/roboshop.log

echo -e "\e[33m exatracting the front end content\e[0m"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[33m Copying the roboshop.conf file\e[0m"
cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell
roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>/tmp/roboshop.log
echo -e "\e[33m Starting Nginx service\e[0m"
systemctl enable nginx  &>>/tmp/roboshop.log
systemctl restart nginx  &>>/tmp/roboshop.log