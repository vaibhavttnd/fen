#!/bin/bash

#storing ami-ids in an array
ami_id=$(aws ec2 describe-images --owners 129158100003 --query "Images[*].ImageId" --output text)


#iterating over ami-ids
for image_id in $ami_id 
do 

description_ami=$(aws ec2 describe-images --image-id $image_id --query "Images[*].Description" --output text)



for description in $description_ami
do

echo $description | grep "Automated"

if [ $? == 0 ]
then

	#fetching date from Name of Image
	creation_date=$(aws ec2 describe-images --image-id $image_id --profile fen --query "Images[*].Name" --output text | rev | cut -c"1-10" | rev)
	echo "creation_date : $creation_date"


	creation_date_epoch=`date --date="$creation_date" '+%s'`

	echo "creation_date_epoch : $creation_date_epoch"


	todays_date=$(date +%s)

	echo "todays_date : $todays_date"

	diff_dates=$(echo `expr $todays_date - $creation_date_epoch`)
	#calculated difference in todays date and date of ami creation

	echo "diff_dates : $diff_dates"


	days=$((diff_dates/60/60/24))
	#seconds to days

	echo "days: $days"

	if [ $days -gt "15" ]
	then
	#storing snapshot_ids in list 
	`aws ec2 describe-images --image-id $image_id --profile fen --query "Images[*].BlockDeviceMappings[*].Ebs[*].SnapshotId" --output text >> /home/monitoring/snapshot_list.txt`

	echo "$image_id will be deleted"
	`aws ec2 deregister-image --image-id $image_id`
	fi
fi
done
done


# Iterating over snapshots and deleting them one by one
for snapshot in `cat /home/monitoring/snapshot_list.txt`
do
echo "$snapshot - This snapshot will be deleted"
`aws ec2 delete-snapshot --snapshot-id $snapshot`
done

`rm -rf /home/monitoring/snapshot_list.txt`
#removing the snapshot_list.txt, so that in cron next time, old snapshot_ids gets removed
