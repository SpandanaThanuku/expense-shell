#log_file=/tmp/expense.log

source common.sh

head "Installing nginx"
dnf install nginx -y &>>$log_file
echo $?

head "copying config files"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?


head "removing old/default content"
rm -rf /usr/share/nginx/html/* &>>$log_file
echo $?

head "downloading frontend code"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
echo $?

cd /usr/share/nginx/html &>>$log_file
echo $?


head "extracting the code"
unzip /tmp/frontend.zip &>>$log_file

echo $?

head "enabling nginx"
systemctl enable nginx &>>$log_file

echo $?

head "restarting nginx"
systemctl restart nginx &>>$log_file
