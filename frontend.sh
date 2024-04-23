#!/bin/bash

#implementing frontend using shell script

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPTNAME.log

#colors
N="\e[0m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"

VALIDATE(){

if [ $1 -ne 0 ]
then
    echo -e "$2 ...$R FAILURE $N"
    exit 1
else
    echo -e "$2 ...$G SUCCESS $N"
fi
}

if [ $USERID -ne 0 ]
then
    echo "please login with super user"
    exit 1
else
    echo "your super user"
fi

dnf install nginx -y &>>LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>LOGFILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>LOGFILE
VALIDATE $? "removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
VALIDATE $? "downloading frontend code"

cd /usr/share/nginx/html &>>LOGFILE
unzip /tmp/frontend.zip &>>LOGFILE
VALIDATE $? "extracting frontend code"

cp /home/ec2-user/expenses-shell/expense.conf /etc/nginx/default.d/expense.conf &>>LOGFILE
VALIDATE $? "copied expense conf"

systemctl restart nginx &>>LOGFILE
VALIDATE $? "restarting nginx"
