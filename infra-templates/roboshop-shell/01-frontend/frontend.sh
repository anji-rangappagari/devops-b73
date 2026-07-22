dnf install nginx -y 
rm -rf /usr/share/nginx/html/* 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
# We need to copy the config file to the nginx config directory
systemctl enable nginx 
systemctl restart nginx 