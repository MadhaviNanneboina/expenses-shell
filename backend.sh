#!/bin/bash

#implementing mysql DB using shell script

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPTNAME.log

#colors
N="\e[0m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"

echo "enter DB password:"
read db_password


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



dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "installing nodejs"

id expense -y
if [ $? -ne 0 ]
then 
    useradd expense 
    VALIDATE $? "creating expenses user"
else
    echo -e "user already exists...$Y SKIPPING $N"


