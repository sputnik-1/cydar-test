#!/bin/bash

# This script will get the version.txt file from the Nginx server
# 
#-----------------------------------------------------------#

# get the loop wait time from the first command line parameter
# this is the polling time in seconds the script will wait
# before try to get the version.txt file again

if [ "$1" != "" ]; then
   WAIT_TIME="$1"
   echo "WAIT_TIME: $WAIT_TIME"
   echo "WAIT_TIME set to $WAIT_TIME second(s)"
   echo

else
   echo
   WAIT_TIME=5
   echo "WAIT_TIME: $WAIT_TIME"
   echo "WAIT_TIME defaults to 5 seconds"
   echo

fi

# get the name of the file to request from the Nginx server
# as an optional second command line parameter.
# We can use this to request a non-existant file
# to test the script works properly when the correct version.txt
# file is not returned.

if [ "$2" != "" ]; then
   FILENAME="$2"
   echo "FILENAME: $FILENAME"
   echo "FILENAME set to $FILENAME"
   echo

else
   FILENAME="version.txt"
   echo "FILENAME: $FILENAME"
   echo "FILENAME defaults to $FILENAME"
   echo

fi


# infinte loop

while true
do

# look for a previously downloaded version.txt file
ls version.txt

echo

# remove the previous downloaded version.txt file
rm -vf ./version.txt

echo

# get a new copy of the version.txt file from the Nginx server
wget 54.212.247.223/"$FILENAME"

ls version.txt

echo

# get the version number from the downloaded file into a variable
DOWNLOADED_VERSION_NUMBER=`cat ./version.txt`
echo "DOWNLOADED_VERSION_NUMBER: $DOWNLOADED_VERSION_NUMBER"
echo

# the version number we are looking for
EXPECTED_VERSION_NUMBER="version-1.2.3"
echo "EXPECTED_VERSION_NUMBER:   $EXPECTED_VERSION_NUMBER"
echo

# check we have downloaded the expected version number
if [ "$DOWNLOADED_VERSION_NUMBER" == "$EXPECTED_VERSION_NUMBER" ]; then
    echo "The version numbers are identical."
    echo "The server is running OK."
    echo

else
    # here we can create alerts about possible server issues like:
    # play an audio alarm
    # play a pre-recorded alert message
    # send an email alert to the server admin team

    echo "There may be problems with the server."
    echo
fi

echo "Press [CTRL+C] to exit program..."

# wait for x number of seconds
sleep $WAIT_TIME

echo

done

#-----------------------------------------------------------#

exit



<<'COMMENT'

#!/bin/bash

# calculates and saves the md5sum for an apps .ruby-version file.
#
# if the md5sum has changed save the new md5sum to a text file for use next time,
# and then attempt to install the needed version of ruby if this is not already installed.
# using rbenv -s install x.y.z

#================================================================================#

# INSTALLED_RUBY_VERSIONS: is a text file containing all the currently installed
# versions of ruby.

# FILE1: is the file to check if it has changed

# FILE1_GET_PATH: is the full path and name of the file to check if it has changed

# FILE1_SAVED_MD5_SUM: is the file where we are saving the latest md5sum for FILE1

# FILE1_READ_MD5_SUM: is a variable containing the md5sum read from FILE1_SAVED_MD5_SUM

# FILE1_LATEST_MD5_SUM: is the latest md5sum generated for FILE1

#-----------------------------------------------------------#

# set up the jenkins project environment

echo
echo "------------------------------------------------------------------------------------------------------"

JENKINS_CURRENT_ENVIRONMENT=`env | sort`
echo "JENKINS_CURRENT_ENVIRONMENT: $JENKINS_CURRENT_ENVIRONMENT"
echo

echo "END OF JENKINS_CURRENT_ENVIRONMENT"
echo "------------------------------------------------------------------------------------------------------"
echo


# set the new PATH value
PATH=/var/lib/jenkins/.rbenv/shims:/var/lib/jenkins/.rbenv/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/var/lib/jenkins/.local/bin:/var/lib/jenkins/bin:
echo "NEW_PATH: $PATH"
echo


# set the following environment variables for oracle unit tests

export LD_LIBRARY_PATH="/usr/lib/oracle/12.1/client64/lib"

export NLS_LANG="AMERICAN_AMERICA.UTF8"

export ORACLE_HOME="/usr/lib/oracle/12.1/client64/lib"


NEW_JENKINS_SCRIPT_ENVIRONMENT=`env | sort`
echo "NEW_JENKINS_SCRIPT_ENVIRONMENT: $NEW_JENKINS_SCRIPT_ENVIRONMENT"
echo


SCRIPT_DIR=`pwd`
echo "SCRIPT_DIR: $SCRIPT_DIR"
echo


CURRENT_DIR=`pwd`
echo "CURRENT_DIR: $CURRENT_DIR"
echo


PROJECT_DIR="/var/lib/jenkins/workspace/ndtmsv2@script/"
echo "PROJECT_DIR: $PROJECT_DIR"
echo

cd $PROJECT_DIR

CURRENT_DIR=`pwd`
echo "CURRENT_DIR2: $CURRENT_DIR"
echo

LOCAL_RUBY_VERSION=`rbenv local`
echo "LOCAL_RUBY_VERSION: $LOCAL_RUBY_VERSION"
echo

RBENV_VERSIONS=`echo; rbenv versions`
echo "RBENV_VERSIONS: $RBENV_VERSIONS"
echo

echo "------------------------------------------------------------------------------------------------------"
echo


#================================================================================#

# calculates and saves the md5sum for an apps .ruby-version file.
#
# if the md5sum has changed save the new md5sum to a text file for use next time.

#================================================================================#

# FILE1: is the file to check if it has changed

# FILE1_GET_PATH: is the full path and name of the file to check if it has changed

# FILE1_SAVED_MD5_SUM: is the file where we are saving the latest md5sum for FILE1

# FILE1_READ_MD5_SUM: is a variable containing the md5sum read from FILE1_SAVED_MD5_SUM

# FILE1_LATEST_MD5_SUM: is the latest md5sum generated for FILE1

#-----------------------------------------------------------#

# .ruby-version file content md5sum comparison

# apps local .ruby-version to calculate the md5sum check on
FILE1=".ruby-version"
echo "FILE1: $FILE1"
echo


FILE1_GET_PATH="/var/lib/jenkins/workspace/ndtmsv2@script/$FILE1"
echo "FILE1_GET_PATH: $FILE1_GET_PATH"
echo


# persistent filename to store the latest md5sum hash into
FILE1_SAVED_MD5_SUM="/var/lib/jenkins/ci-projects/ndtmsv2/versions/$FILE1.md5"
echo "FILE1_SAVED_MD5_SUM: $FILE1_SAVED_MD5_SUM"
echo


# calculate the files current md5 sum
FILE1_LATEST_MD5_SUM=`md5sum $FILE1_GET_PATH`
echo "FILE1_LATEST_MD5_SUM: $FILE1_LATEST_MD5_SUM"
echo


# get the contents of the $FILE1_SAVED_MD5_SUM from disk into a variable
FILE1_READ_MD5_SUM=`cat "$FILE1_SAVED_MD5_SUM"`
echo "FILE1_READ_MD5_SUM:   $FILE1_READ_MD5_SUM"
echo

#=======================================================#

# compare the contents of $FILE1_READ_MD5_SUM with $FILE1_LATEST_MD5_SUM
# if these are different it means the version of ruby has changed.

if [ "$FILE1_READ_MD5_SUM" == "$FILE1_LATEST_MD5_SUM" ]

then
  echo "md5sum has not changed for $FILE1_GET_PATH"

else
  # save the latest md5sum hash value of FILE1 to file named $FILE1_SAVED_MD5_SUM
  # only if these are different.
  echo "$FILE1_LATEST_MD5_SUM" > "$FILE1_SAVED_MD5_SUM"

  echo "This application is using a different version of ruby"
  echo "Now attempting to install the required ruby version of $LOCAL_RUBY_VERSION"
  echo "Please wait - this could take some time ... 10 mins or more"

  # use rbenv to install the required version of ruby
  # if this is installed already, using the -s flag will
  # tell rbenv NOT to try and re-install the same version.
  rbenv install -s $LOCAL_RUBY_VERSION

fi

echo

#================================================================================#

# exit command needs to follow the thing being tested - as exit will only return the
# result of the last command run.
exit

COMMENT



