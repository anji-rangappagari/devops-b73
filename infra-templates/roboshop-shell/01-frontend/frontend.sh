echo -e "\e[33mInstalling Nginx Server\e[0m"
dnf install nginx -y 
echo -e "\e[33mRemoving old app content\e[0m"
rm -rf /usr/share/nginx/html/* 

echo -e "\e[33m Downloading the front end content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

echo -e "\e[33m exatracting the front end content\e[0m"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

# We need to copy the config file to the nginx config directory

echo -e "\e[33m Starting Nginx service\e[0m"
systemctl enable nginx 
systemctl restart nginx 