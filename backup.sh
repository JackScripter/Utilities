#!/bin/bash
# This script have been created by Jacob Ouellette.

#################################################################
#			 CONFIGURATION 				#
#################################################################
# Sendmail path:
SENDMAIL='/usr/sbin/sendmail'

# Place all folders you want to backup followed by the destination folder name. DON'T put * to select many folders.
TOBACKUP=(
	"/folder1" "fold1"
	"/folder2/folder" "folders"
)
# Destination path
DESTINATION="/backup"

# Log folder
LOGFOLDER="/var/log/backup"

# Email configuration
FROMMAIL="source@mail.com"
DESTINATOR="destination@mail.com"

#################################################################
#		PROCESSING (don't edit this part)		#
#################################################################
mBody="Backup start time: $(date +%H:%M)"
for ((i=0; i<${#TOBACKUP[@]}; i++)); do
	if [ $(( $i % 2 )) == 0 ];then
		nameNum=$((i + 1))
		if [ ! -f $DESTINATION/${TOBACKUP[$nameNum]} ];then mkdir -p $DESTINATION/${TOBACKUP[$nameNum]}; fi # Create destination folder if don't exist.
		echo '['$(date +%H:%M)']' Starting backup folder ${TOBACKUP[$i]} &>> $LOGFOLDER/$(date +%F).txt
		cp -pruv ${TOBACKUP[$i]} $DESTINATION/${TOBACKUP[$nameNum]} >> $LOGFOLDER/$(date +%F).txt
	fi
done
echo "Backup end time: $(date +%H:%M)" &>> $LOGFOLDER/$(date +%F).txt
mSubject="Backup Summary - $(date +%F)"
mAttache=$LOGFOLDER/$(date +%F).txt
mBody="$mBody
#Backup end time: $(date +%H:%M)"
(printf "%s\n" \
	"From: $FROMMAIL" \
	"To: $DESTINATOR" \
	"Subject: $mSubject" \
	"`cat $mAttache`";) | $SENDMAIL "$DESTINATOR"
