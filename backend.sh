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
N="\e[30m"

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
    echo -e "$2 .....$R FAILURE $N"
    exit 1
else
    echo -e "$2 .....$G SUCCESS $N"
fi
}

dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "installing nodejs"

useradd expense 
VALIDATE $? "adding user"