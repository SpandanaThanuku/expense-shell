#log_file=/tmp/expense.log
component=frontend
source common.sh

head "Installing nginx"
dnf install nginx -y &>>$log_file
Stat $?

head "copying config files"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
Stat $?

App_Prereq "/usr/share/nginx/html"

head "enabling nginx"
systemctl enable nginx &>>$log_file

Stat $?

head "restarting nginx"
systemctl restart nginx &>>$log_file
