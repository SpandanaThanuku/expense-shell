echo disable default version of NodeJS
dnf module disable nodejs -y

echo enable nodeJS 18 version
dnf module enable nodejs:18 -y

echo installing NodeJS
dnf install nodejs -y

echo configure backend service
cp backend.service /etc/systemd/system/backend.service

echo Adding Application user
useradd expense

echo removing /app content
rm -rf /app

echo creating app directory
mkdir /app

echo download
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip

echo changing directory to /app
cd /app

echo extracting files
unzip /tmp/backend.zip

echo downloading Application dependencies
npm install

echo reloading systemd and starting backend services
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

echo MYSQL client
dnf install mysql -y

echo Load schema
mysql -h mysql-dev.tsdevops25.online -uroot -pExpenseApp@1 < /app/schema/backend.sql