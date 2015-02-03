#!/bin/bash

################################################################################
# backup.sh
################################################################################
#
# ~/.backupsh contains directories for each host you want to be managed
#     ~/.backupsh/desktop/
#     ~/.backupsh/laptop/
#     ~/.backupsh/server/
#
# backup.sh utilizes ssh heavily, so make sure you have passwordless login to
# $TARGET_HOST
#
# Each host directory contains job description files. Jobs are defined by three
# files:
#
#     jobname.path contains the local path to be backed up
#     jobname.excludes contains rsync exclude patterns
#     jobname.target contains the remote target directory for a job
#
# How to create a backup job:
#
#     echo /home/user > ~/.backupsh/myhostname/homedir.path
#
#     cat > ~/.backupsh/myhostname/homedir.excludes <<!
#     - user/.cache
#     - user/Downloads
#     !
#
#     echo myHomeDir > ~/.backupsh/myhostname/homedir.target
#
################################################################################

#################
# CONFIGURATION #
#################

TARGET_HOST=pewter
TARGET_PATH="/media/backups/$(hostname -s)"

######################################
# No configuration beyond this point #
######################################

SCRIPTROOT="$HOME/.backupsh"
LOGROOT="$SCRIPTROOT/logs"
JOBROOT="$SCRIPTROOT/$(hostname -s)"

LAST=$(ssh $TARGET_HOST "touch \"$TARGET_PATH\"/last-successful.txt; cat \"$TARGET_PATH\"/last-successful.txt")
if [[ $? -ne 0 ]]; then
    exit 255
fi

if [ -z "$1" ]; then
    CURRENT=$(date +%Y-%m-%d-%H%M%S)
else
    CURRENT="$1"
fi

CURRENT_PATH="$TARGET_PATH/$CURRENT"
LAST_PATH="$TARGET_PATH/$LAST"

echo "Backup target: $LAST -> $TARGET_HOST:$CURRENT_PATH"

mkdir -p "$LOGROOT/$CURRENT"

for job in "$JOBROOT"/*.path; do
    jobname=$(basename "$job")
    jobname="${jobname%.path}"

    if [ "$jobname" = '*' ]; then
        echo "No jobs defined for $(hostname -s)!"
        exit 1
    fi

    jobpath=$(cat "$JOBROOT/${jobname}.path")
    targetpathcontainer="$(dirname "$jobpath")"
    if [ -f "$JOBROOT/${jobname}.target" ]; then
        targetpathcontainer=$(cat "$JOBROOT/${jobname}.target")
    fi
    jobexcludes="$JOBROOT/${jobname}.excludes"
    if [ ! -f "$jobexcludes" ]; then
        jobexcludes=""
    fi

    ssh $TARGET_HOST "mkdir -p \"$CURRENT_PATH/$targetpathcontainer\""
    if [ -z "$jobexcludes" ]; then
        rsync --log-file=$joblog -aP --link-dest="$LAST_PATH/$targetpathcontainer"                               "$jobpath" "$TARGET_HOST":"$CURRENT_PATH/$targetpathcontainer"
    else
        rsync --log-file=$joblog -aP --link-dest="$LAST_PATH/$targetpathcontainer" --exclude-from "$jobexcludes" "$jobpath" "$TARGET_HOST":"$CURRENT_PATH/$targetpathcontainer"
    fi
    ec=$?
    if [ $ec -eq 255 ]; then
        echo "Stopping..."
        echo "  $CURRENT"
        exit 255
    fi
done

ssh $TARGET_HOST "mv -v $TARGET_PATH/last-successful.txt{,-bak}; echo $CURRENT > $TARGET_PATH/last-successful.txt; ln -fs \"$CURRENT\" \"$TARGET_PATH\"/latest"
echo "Saved last-successful ($CURRENT)"

excludefile="~/.backupsh/$(hostname -s).txt"

ssh $TARGET_HOST "echo $CURRENT > $TARGET_PATH/last-successful.txt"
