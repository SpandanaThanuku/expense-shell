echo -e "\e[35m disable default version of NodeJS\e[0m"
dnf module disable nodejs -y

echo -e "\e[35m enable nodeJS 18 version\e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[35m installing NodeJS\e[0m"
dnf install nodejs -y

echo -e "\e[35m configure backend service\e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[35m Adding Application user\e[0m"
useradd expense

echo -e "\e[35m removing /app content\e[0m"
rm -rf /app

echo -e "\e[35m creating app directory\e[0m"
mkdir /app

echo -e "\e[35m download\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip

echo -e "\e[35m changing directory to /app\e[0m"
cd /app

echo -e "\e[35m extracting files\e[0m"
unzip /tmp/backend.zip

echo -e "\e[35m downloading Application dependencies\e[0m"
npm install

echo -e "\e[35m reloading systemd and starting backend services\e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

echo -e "\e[35m MYSQL client\e[0m"
dnf install mysql -y

echo -e "\e[35m Load schema\e[0m"
mysql -h mysql-dev.tsdevops25.online -uroot -pExpenseApp@1 < /app/schema/backend.sql