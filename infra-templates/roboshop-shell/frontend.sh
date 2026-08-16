set -e

echo -e "\e[33mInstalling Nginx Server\e[0m"
dnf module disable nginx -y &>>/tmp/roboshop.log
dnf module enable nginx:1.24 -y &>>/tmp/roboshop.log
dnf install nginx unzip -y &>>/tmp/roboshop.log

echo -e "\e[33mStarting Nginx service\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl start nginx &>>/tmp/roboshop.log

echo -e "\e[33mRemoving old app content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[33mDownloading the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>/tmp/roboshop.log

echo -e "\e[33mExtracting the frontend content\e[0m"
cd /usr/share/nginx/html
unzip -o /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[33mConfiguring Nginx reverse proxy\e[0m"
# Avoid empty-glob / duplicate default-server failures on RHEL nginx
mkdir -p /etc/nginx/default.d /etc/nginx/conf.d
rm -f /etc/nginx/conf.d/default.conf
echo '# managed by roboshop' >/etc/nginx/default.d/placeholder.conf

cat >/etc/nginx/nginx.conf <<'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log notice;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }

        location /images/ {
          expires 5s;
          root   /usr/share/nginx/html;
          try_files $uri /images/placeholder.jpg;
        }
        location /api/catalogue/ { proxy_pass http://catalogue-dev.oneseven.space:8080/; }
        location /api/user/ { proxy_pass http://user-dev.oneseven.space:8080/; }
        location /api/cart/ { proxy_pass http://cart-dev.oneseven.space:8080/; }
        location /api/shipping/ { proxy_pass http://shipping-dev.oneseven.space:8080/; }
        location /api/payment/ { proxy_pass http://payment-dev.oneseven.space:8080/; }

        location /health {
          stub_status on;
          access_log off;
        }
    }
}
EOF

echo -e "\e[33mRestarting Nginx service\e[0m"
nginx -t &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log
