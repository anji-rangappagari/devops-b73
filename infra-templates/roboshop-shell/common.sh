colour="\e[33m"
nocolour="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

status_check() {
    if [ $1 -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
        echo -e "${colour}Refer the log file for more information: ${log_file}${nocolour}"
        exit 1
    fi
}

app_presetup() {
    echo -e "${colour}Creating roboshop User${nocolour}"

    if [ $? -eq 1 ]; then
        id roboshop &>>${log_file} || useradd roboshop &>>${log_file}
    fi

    status_check $?

    echo -e "${colour}Creating ${app_path} Directory${nocolour}"
    rm -rf ${app_path}
    mkdir -p ${app_path} &>>${log_file}
    status_check $?

    echo -e "${colour}Download Application Content${nocolour}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>> ${log_file}
    status_check $?

    echo -e "${colour}Extract Application Content${nocolour}"
    cd ${app_path}
    unzip /tmp/${component}.zip &>> ${log_file}
    status_check $?

}

systemd_setup() {
    echo -e "${colour}Configuring ${component} Service${nocolour}"
    cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    echo -e "${colour}Starting ${component} Service${nocolour}"
    systemctl daemon-reload &>>${log_file}
    systemctl enable ${component} &>>${log_file}
    systemctl restart ${component} &>>${log_file}
    status_check $?
}

node_js(){
    echo -e "${colour} Configuring NodeJS Repos${nocolour}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_file}
    status_check $?
    echo -e "${colour} Installing Node.js${nocolour}"
    dnf module disable nodejs -y &>> ${log_file}
    dnf module enable nodejs:20 -y &>> ${log_file}
    dnf install nodejs -y &>> ${log_file}
    status_check $?

    app_presetup

    echo -e "${colour}Install NodeJS Dependencies${nocolour}"
    cd ${app_path}
    npm install &>> ${log_file}
    status_check $?
    systemd_setup

}

mongo_schema_setup() {
    echo -e "${colour}Copy MongoDB Repo file${nocolour}"
    cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>> ${log_file}
    status_check $?

    echo -e "${colour}Install MongoDB Client${nocolour}"
    dnf install mongodb-org -y &>> ${log_file}
    status_check $?

    echo -e "${colour}Load Schema${nocolour}"
    mongosh --host mongodb-dev.oneseven.space <${app_path}/db/master-data.js &>> ${log_file}
    status_check $?
        echo FAILURE
    fi
}

mysql_schema_setup() {
    echo -e "${colour}Install MySQL Client${nocolour}"
    dnf install mysql -y &>> ${log_file}
    status_check $?

    echo -e "${colour}Load Schema${nocolour}"
    mysql -h mysql-dev.oneseven.space -uroot -pRoboShop@1 <${app_path}/db/schema.sql &>> ${log_file}
    if [ $? -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
    fi
}

mavan() {
    set -e

    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

    echo -e "${colour}Installing Maven${nocolour}"
    dnf install maven unzip mysql -y &>>${log_file}
    status_check $?

    echo -e "${colour}Creating roboshop User${nocolour}"
    id roboshop &>>${log_file} || useradd roboshop &>>${log_file}
    status_check $?

    echo -e "${colour}Creating ${app_path} Directory${nocolour}"
    rm -rf ${app_path}
    mkdir ${app_path}
    status_check $?


    echo -e "${colour}Creating ${app_path} Directory${nocolour}"
    rm -rf ${app_path}
    mkdir ${app_path}
    status_check $?

    echo -e "${colour}Downloading Shipping Application${nocolour}"
    curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>>${log_file}
    if [ $? -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
    fi

    echo -e "${colour}Extracting Shipping Application${nocolour}"
    cd ${app_path}
    unzip -o /tmp/shipping.zip &>>${log_file}
    if [ $? -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
    fi

    echo -e "${colour}Building Shipping Application${nocolour}"
    cd ${app_path}
    mvn clean package &>>${log_file}
    mv target/shipping-1.0.jar shipping.jar &>>${log_file}
    chown -R roboshop:roboshop ${app_path}
    if [ $? -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
    fi

    echo -e "${colour}Configuring Shipping Service${nocolour}"
    cp "${SCRIPT_DIR}/shipping.service" /etc/systemd/system/shipping.service &>>${log_file}
    if [ $? -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
    fi

    echo -e "${colour}Loading Shipping Service${nocolour}"
    systemctl daemon-reload &>>${log_file}
    systemctl enable ${component} &>>${log_file}
    systemctl start ${component} &>>${log_file}
    if [ $? -eq 0 ]; then
        echo SUCCESS
    else
        echo FAILURE
    fi
}

python() {
    echo -e "${colour}Installing Python 3${nocolour}"
    dnf install python3 gcc python3-devel unzip -y &>>${log_file}
    stsatus_check $?

    app_presetup

    echo -e "${colour}Installing Python Dependencies${nocolour}"
    cd ${app_path}
    pip3 install -r requirements.txt &>>${log_file}
    status_check $?

    systemd_setup
}