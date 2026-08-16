set -e
component=mongodb
source common.sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo -e "${colour}Copying the ${component} repo file${nocolour}"
cp "${SCRIPT_DIR}/${component}.repo" /etc/yum.repos.d/${component}.repo &>>${log_file}

echo -e "${colour}Installing ${component}${nocolour}"
dnf install ${component}-org -y &>>${log_file}

echo -e "${colour}Modifying the ${component} configuration file to listen on all interfaces${nocolour}"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/${component}.conf &>>${log_file}

echo -e "${colour}Starting & Enabling ${component} Service${nocolour}"
systemctl enable ${component} &>>${log_file}
systemctl start ${component} &>>${log_file}
