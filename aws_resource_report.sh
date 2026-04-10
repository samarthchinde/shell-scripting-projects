#!/bin/bash

################################################
# Author: Samarth Chinde
# version: v1
#
# This script will report the aws resource useage
################################################

Report=aws_resouce_report_document
date=$(date)
echo "This report is of date $date."

echo " "

#list s3 buckets
echo "list of s3 buckets:-"
s3=$(aws s3 ls)
echo "$s3"
echo "$s3" > Report 

echo " "

#list ec2 instances
echo "list of ec2 instances:-"
ec2=$(aws ec2 describe-instances)
#aws ec2 describe-instances
echo "$ec2" | jq '.Reservations[].Instances[].InstanceId'
echo "$ec2" | jq '.Reservations[].Instances[].InstanceId' >> Report

echo " "

#list lambda functions
echo "list of lambda functions:-"
lambda=$(aws lambda list-functions)
echo "$lambda"
echo "$lambda" >> Report

echo " "

#list IAM users
echo "list of iam users:-"
IAM=$(aws iam list-users)
#aws iam list-users
echo "$IAM" | jq '.Users[].UserId'
echo "$IAM" | jq '.Users[].UserId' >> Report

echo " "

echo "File is created check $Report"
