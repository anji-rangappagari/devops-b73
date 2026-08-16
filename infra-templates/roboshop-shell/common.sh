colour="\e[33m"
nocolour="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

node_js(){
    echo -e "${colour} Configuring NodeJS Repos${nocolour}"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> ${log_file}

    echo -e "${colour} Installing Node.js${nocolour}"
    dnf module disable nodejs -y &>> ${log_file}
    dnf module enable nodejs:20 -y &>> ${log_file}
    dnf install nodejs -y &>> ${log_file}

    echo -e "${colour}Add Application User${nocolour}"
    useradd roboshop &>> ${log_file}

    echo -e "${colour}Create Application Directory${nocolour}"
    rm -rf ${app_path}
    mkdir -p ${app_path} &>> ${log_file}

    echo -e "${colour}Download Application Content${nocolour}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>> ${log_file}

    echo -e "${colour}Extract Application Content${nocolour}"
    cd ${app_path}
    unzip /tmp/${component}.zip &>> ${log_file}

    echo -e "${colour}Install NodeJS Dependencies${nocolour}"
    cd ${app_path}
    npm install &>> ${log_file}

    echo -e "${colour}Setup SystemD Service${nocolour}"
    cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>> ${log_file}

    echo -e "${colour}Start ${component} service${nocolour}"
    systemctl daemon-reload &>> ${log_file}
    systemctl enable ${component} &>> ${log_file}
    systemctl start ${component} &>> ${log_file}

}

mongo_schema_setup() {
    echo -e "${colour}Copy MongoDB Repo file${nocolour}"
    cp /home/ec2-user/devops-b73/infra-templates/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>> ${log_file}

    echo -e "${colour}Install MongoDB Client${nocolour}"
    dnf install mongodb-org -y &>> ${log_file}

    echo -e "${colour}Load Schema${nocolour}"
    mongosh --host mongodb-dev.oneseven.space </app/db/master-data.js &>> ${log_file}
}