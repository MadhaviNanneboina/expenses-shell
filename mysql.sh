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
N="\e[0m"
echo "enter DB password:"
read -s db_root_password


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
    echo -e "$2 ..... $R FAILURE $N"
    exit 1
else
    echo -e "$2 ..... $G SUCCESS $N"
    fi
    }

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting mysql"

#shell is not idempotency by default if we exicute this script it will faile
# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting up password"

# implementing idempotency
mysql -h db.vishruth.online -uroot -p${db_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
mysql_secure_installation --set-root-pass ${db_root_password} &>>$LOGFILE
VALIDATE $? "settingup root password"
else
echo -e "root password already setup...$Y skipping $N"
fi

