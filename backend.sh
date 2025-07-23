MYSQL_PASSWORD=$1 # declaring special Variable
###log_file=/tmp/expense.log

if [ -z "MYSQL_PASSWORD" ]; then
  echo Input MYSQL_PASSWORD is missing
  exit 1
fi
component=backend

source common.sh

head "disable default version of NodeJS"
dnf module disable nodejs -y &>>$log_file
Stat $?

head "enable nodeJS 18 version"
dnf module enable nodejs:18 -y &>>$log_file
Stat $?

head "installing NodeJS"
dnf install nodejs -y &>>$log_file
Stat $?

head "configure backend service"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
Stat $?

head "Adding Application user"

id expense &>>$log_file
if [ "$?" -ne 0 ]; then
  useradd expense &>>$log_file
fi
Stat $?

App_Prereq /add

head "downloading Application dependencies"
npm install &>>$log_file
Stat $?

head "reloading systemd and starting backend services"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
Stat $?

head "MYSQL client"
dnf install mysql -y &>>$log_file
Stat $?

head "Load_schema"
mysql -h mysql-dev.tsdevops25.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file