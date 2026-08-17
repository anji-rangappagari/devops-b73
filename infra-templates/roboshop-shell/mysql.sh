set -e
component=mysql
source common.sh

echo -e "${colour}Installing MySQL Server${nocolour}"
dnf install mysql-server -y &>>${log_file}
status_check $?

echo -e "${colour}Configuring MySQL to listen on all interfaces${nocolour}"
cat >/etc/my.cnf.d/z-roboshop.cnf <<'EOF'
[mysqld]
bind-address=0.0.0.0
mysqlx-bind-address=0.0.0.0
EOF
status_check $?

echo -e "${colour}Starting MySQL Service${nocolour}"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
status_check $?

# Wait until mysqld accepts connections
for i in $(seq 1 30); do
  mysqladmin ping --silent && break
  sleep 2
done
status_check $?
echo -e "${colour}Setting MySQL root password${nocolour}"
# RHEL MySQL 8: set password via SQL (lab flag --set-root-pass is not always available)
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY $1; FLUSH PRIVILEGES;" &>>${log_file}
mysql_secure_installation --set-root-pass $1 &>>${log_file} || true
status_check $?
echo -e "${colour}Allowing remote root access for RoboShop${nocolour}"
mysql -uroot -p $1 -e "DROP USER IF EXISTS 'root'@'%';" &>>${log_file} || true
mysql -uroot -p $1 -e "CREATE USER 'root'@'%' IDENTIFIED BY 'RoboShop@1'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" &>>${log_file}
status_check $?

echo -e "${colour}Restarting MySQL to apply bind-address${nocolour}"
systemctl restart mysqld &>>${log_file}
status_check $?