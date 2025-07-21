log_file=/tmp/expense.log

#declaring function
head() {
  echo -e "\e[35m$1\e[0m"
}

head "Installing nginx"
dnf install nginx -y &>>$log_file

head "copying config files"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file

head "removing old/default content"
rm -rf /usr/share/nginx/html/* &>>$log_file
head "downloading frontend code"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
cd /usr/share/nginx/html &>>$log_file

head "extracting the code"
unzip /tmp/frontend.zip &>>$log_file

head "enabling nginx"
systemctl enable nginx &>>$log_file

head "restarting nginx"
systemctl restart nginx &>>$log_file