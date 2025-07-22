log_file=/tmp/expense.log

head() {
  echo -e "\e[35m$1\e[0m"
}

App_Prereq() {
DIR=$1
head "removing /app content"
rm -rf $1 &>>$log_file
echo $?

head "creating app directory"
mkdir $1 &>>$log_file
echo $?

head "download"
curl -o /tmp/${component}zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
echo $?

head "changing directory to /app"
cd $1
echo $?

head "extracting files"
unzip /tmp/${component}.zip &>>$log_file
echo $?
}

Stat() {
  if [ "$1" -eq 0 ]; then
    echo SUCCESS
    else
    echo FAILURE
      exit 1
  fi
}