component=redis
source common.sh

echo -e "${colour}Disabling Redis Module${nocolour}"
dnf module disable ${component} -y &>>${log_file}

echo -e "${colour}Enabling Redis Module${nocolour}"
dnf module enable ${component}:7 -y &>>${log_file}

echo -e "${colour}Installing Redis${nocolour}"
dnf install ${component} -y  &>>${log_file}

echo -e "${colour}Configuring Redis${nocolour}"
sed -i 's|127.0.0.1|0.0.0.0|' /etc/${component}/${component}.conf &>>${log_file}
sudo sed -i 's/protected-mode yes/protected-mode no/' /etc/${component}/${component}.conf &>>${log_file}

echo -e "${colour}Starting Redis Service${nocolour}"
systemctl enable ${component} &>>${log_file}
systemctl start ${component} &>>${log_file}