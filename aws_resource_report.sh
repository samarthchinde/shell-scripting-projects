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
#aws ec2 describe-instances
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> aws_resouce_report_document

echo " "

#list lambda functions
echo "list of lambda functions:-"
aws lambda list-functions
aws lambda list-functions >> aws_resouce_report_document

echo " "

#list IAM users
echo "list of iam users:-"
#aws iam list-users
aws iam list-users | jq '.Users[].UserId'
aws iam list-users | jq '.Users[].UserId' >> aws_resouce_report_document

echo " "

echo "File is created check aws_resouce_report_document."
