#!/bin/bash
# This script have been created by Jacob Ouellette.

#################################################################
#							 CONFIGURATION 						#
#################################################################
# Place all folders you want to backup followed by the backup folder name. DON'T put * to select many folders.
TOBACKUP=(
	"/folder1" "fold1"
	"/folder2/folder" "folders"
)

# Destination
DESTINATION="/backup"

# Log folder
LOGFOLDER="/var/log/backup"

# Mailx (heirloom-mail) configuration
FROMMAIL="source@mail.com"
SMTPSERVER="smtp.mail.com"
SMTPPORT="587"
PASSWORD=""
DESTINATOR="destinator@mail.com"

#################################################################
#				PROCESSING (don't edit this part)				#
#################################################################
mBody="Backup start time: $(date +%H:%M)"
for ((i=0; i<${#TOBACKUP[@]}; i++)) do
	if [ $(( $i % 2 )) == 0 ];then
		nameNum=$((i + 1))
		if [ ! -f $DESTINATION/${TOBACKUP[$nameNum]} ];then
			mkdir -p $DESTINATION/${TOBACKUP[$nameNum]}
		fi
		echo '['$(date +%H:%M)']' Starting backup folder ${TOBACKUP[$i]} &>> $LOGFOLDER/$(date +%F).txt
		cp -pruv ${TOBACKUP[$i]} $DESTINATION/${TOBACKUP[$nameNum]} >> $LOGFOLDER/$(date +%F).txt
	fi
done
smtpSP=$SMTPSERVER:$SMTPPORT
mSubject="Backup Summary - $(date +%F)"
mAttache=$LOGFOLDER/$(date +%F).txt
mBody="$mBody
Backup end time: $(date +%H:%M)"
echo "$mBody" | heirloom-mailx -r $FROMMAIL -a $mAttache -s $mSubject -S smtp=$smtpSP -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$FROMMAIL -S smtp-auth-password=$PASSWORD -S ssl-verify=ignore $DESTINATOR
