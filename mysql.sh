#!/bin/bash

#implementing mysql DB using shell script

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPTNAME.log

#colors
B="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
echo "enter DB password:"
read -s DB_ROOT_PASSWORD
show databases;


if [ $USERID -ne 0 ]
then
    echo "please login with super user"
    exit 1
else
    echo "your super user"
fi

VALIDATE(){
if [ $1 -ne 0 ]
then
    echo "$2 .....FAILURE"
    exit 1
else
    echo "$2 .....SUCCESS"
    fi
    }

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

#shell is not idempotency by default if we exicute this script it will faile
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "setting up password"

# implementing idempotency
# mysql -h db.vishruth.online -uroot -p${DB_ROOT_PASSWORD}  -e 'show databases;' &>>$LOGFILE
# if [ $? -ne 0 ]
# then
# mysql_secure_installation --set-root-pass ${DB_ROOT_PASSWORD} &>>$LOGFILE
# VALIDATE $? "settingup root password"
# else
#  echo "root password already setup...skipping"
#  fi
#  mysql_secure_installation --set-root-pass ExpenseApp@1