#!/bin/bash

################################################
# Author: Samarth Chinde
# version: v2
#
# This script will report the aws resource useage.
# ec2,s3,lambda functions,IAM users.
################################################

# exit immediately if any command fails 
set -e

#validation for the aws cli configuration
if ! aws sts get-caller-identity &>/dev/null; then
    echo "ERROR: AWS CLI not configured. Run 'aws configure' first."
    exit 1
fi

Report="aws_resource_report_$(date +%Y-%m-%d_%H-%M-%S).txt"
date=$(date)
echo "This report is of date $date." | tee $Report

echo " " | tee -a $Report

#list s3 buckets
echo "list of s3 buckets:-" | tee -a $Report
s3=$(aws s3 ls)
echo "$s3" | tee -a $Report 

echo " " | tee -a $Report

#list ec2 instances
echo "list of ec2 instances:-" | tee -a $Report
ec2=$(aws ec2 describe-instances)
#aws ec2 describe-instances
echo "$ec2" | jq '.Reservations[].Instances[].InstanceId' | tee -a $Report

echo " " | tee -a $Report

#list lambda functions
echo "list of lambda functions:-" | tee -a $Report 
lambda=$(aws lambda list-functions)
echo "$lambda" | tee -a $Report

echo " " | tee -a $Report

#list IAM users
echo "list of iam users:-" | tee -a $Report
IAM=$(aws iam list-users)
#aws iam list-users
echo "$IAM" | jq '.Users[].UserId' | tee -a $Report

echo " " | tee -a $Report

echo "File is created check $Report . In $(pwd) ."
