component=shipping
source common.sh
mavan


echo -e "${colour}Initializing Shipping Database${nocolour}"
# shipping-v3: schema + app user + countries/cities master data
mysql -h mysql-dev.oneseven.space -uroot -p'RoboShop@1' </app/db/schema.sql &>>${log_file}
mysql -h mysql-dev.oneseven.space -uroot -p'RoboShop@1' </app/db/app-user.sql &>>${log_file}
mysql -h mysql-dev.oneseven.space -uroot -p'RoboShop@1' </app/db/master-data.sql &>>${log_file}

echo -e "${colour}Restarting Shipping Service${nocolour}"
systemctl restart ${component} &>>${log_file}
