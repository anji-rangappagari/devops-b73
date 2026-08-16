set -e

echo -e "\e[33mInstalling MySQL Server\e[0m"
dnf install mysql-server -y &>>/tmp/roboshop.log

echo -e "\e[33mConfiguring MySQL to listen on all interfaces\e[0m"
cat >/etc/my.cnf.d/z-roboshop.cnf <<'EOF'
[mysqld]
bind-address=0.0.0.0
mysqlx-bind-address=0.0.0.0
EOF

echo -e "\e[33mStarting MySQL Service\e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

# Wait until mysqld accepts connections
for i in $(seq 1 30); do
  mysqladmin ping --silent && break
  sleep 2
done

echo -e "\e[33mSetting MySQL root password\e[0m"
# RHEL MySQL 8: set password via SQL (lab flag --set-root-pass is not always available)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1'; FLUSH PRIVILEGES;" &>>/tmp/roboshop.log
mysql_secure_installation --set-root-pass 'RoboShop@1' &>>/tmp/roboshop.log || true

echo -e "\e[33mAllowing remote root access for RoboShop\e[0m"
mysql -uroot -p'RoboShop@1' -e "DROP USER IF EXISTS 'root'@'%';" &>>/tmp/roboshop.log || true
mysql -uroot -p'RoboShop@1' -e "CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" &>>/tmp/roboshop.log

echo -e "\e[33mRestarting MySQL to apply bind-address\e[0m"
systemctl restart mysqld &>>/tmp/roboshop.log
