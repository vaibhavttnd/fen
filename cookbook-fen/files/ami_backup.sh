#!/bin/bash

REGION=us-east-1
File_location=/home/monitor/ami_list.txt
DATE=$(date +%Y-%m-%d-%H:%M)
DATE1=$(date +%Y-%m-%d)
echo "======================================================D A T E :- $DATE ================================================="





        for i in `cat $File_location`
        do
                name=`/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$i" "Name=key,Values=Name" --query 'Tags[].Value'  --output text --region $REGION `

                img_id=`/usr/local/bin/aws ec2 create-image --instance-id $i --no-reboot --name "AMI-$name-$DATE1" --description "Automated_AMI-$name-$DATE"  --output text --region $REGION `

                        if [ $? == 0 ]
                                then
                                echo "success"
                 keys=($(/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$i"  --query 'Tags[].[Key]' --output text --region $REGION))

                                for j in "${keys[@]}"
                                do

                        value=`/usr/local/bin/aws ec2 describe-tags --filters "Name=resource-id,Values=$i" "Name=key,Values=$j" --query 'Tags[].Value' --output text --region $REGION`
                        if [ $j == "Name" ]
                        then
                       /usr/local/bin/aws ec2 create-tags --resources $img_id --tags Key=$j,Value="$value-automated-$DATE" --output text --region $REGION
                        else
                        /usr/local/bin/aws ec2 create-tags --resources $img_id --tags Key=$j,Value="$value" --output text --region $REGION
                        fi

                                done
                        else
                        echo "AMIs Creation Error !! ....Please Check and Resolve" | /usr/sbin/sendmail -F AMI CREATION prashant.sharam@tothenew.com
                        fi

        done
        echo "***********************Job executed successfully*********************************"                                                                           
