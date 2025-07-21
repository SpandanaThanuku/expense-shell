MYSQL_PASSWORD=$1 # declaring special Variable
###log_file=/tmp/expense.log
source common.sh

head "disable default version of NodeJS"
dnf module disable nodejs -y &>>$log_file
echo $?

head "enable nodeJS 18 version"
dnf module enable nodejs:18 -y &>>$log_file
echo $?

head "installing NodeJS"
dnf install nodejs -y &>>$log_file
echo $?

head "configure backend service"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

head "Adding Application user"
useradd expense &>>$log_file
echo $?

head "removing /app content"
rm -rf /app &>>$log_file
echo $?

head "creating app directory"
mkdir /app &>>$log_file
echo $?

head "download"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
echo $?

head "changing directory to /app"
cd /app
echo $?

head "extracting files"
unzip /tmp/backend.zip &>>$log_file
echo $?

head "downloading Application dependencies"
npm install &>>$log_file
echo $?

head "reloading systemd and starting backend services"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
echo $?

head "MYSQL client"
dnf install mysql -y &>>$log_file
echo $?

head "Load_schema"
mysql -h mysql-dev.tsdevops25.online -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>>$log_file