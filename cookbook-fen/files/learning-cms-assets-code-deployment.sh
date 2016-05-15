#!/bin/bash
#This script will pull data from and will push the data to s3
#Syntax to run script
## " 
## Author : prashant.sharma@tothenew.com
##
#####################################################################3

aws=/usr/local/bin/aws
code_path=/home/monitor/learning-cms-assets/
cd $code_path
git_origin=`git remote add origin ssh://git@vc.fen.com/learning-cms-assets`
git_pull=`git pull origin master`
if [ $? -eq 0 ];then
        ls
  $aws s3 sync styleguide-factmonster/dist s3://styleguide-factmonster/
  $aws s3 sync styleguide-teachervision/dist s3://styleguide-teachervision/
  $aws s3 sync styleguide-familyeducation/dist s3://styleguide-familyeducation/

else
        echo "Git pull is not working"
        exit 0
fi
