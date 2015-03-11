#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
cd $scriptDir
# where are the files stored
cd ..
fileDir=$(pwd)


if [ $# != 2 ] ; then
    echo
    echo "Usage:"
    echo "  $0 communityTag productTag"
    echo "For example:"
    echo "  $0 6.2.0.Final sync-6.2.x-2015.02.27"
    echo
    exit 1
fi

echo "The communityTag is: "$1
echo "The prodcutTag is: "$2
echo -n "Is this ok? (Hit control-c if is not): "
read ok


communityTag=$1
productTag=$2
#prefix=`date +%F-%H:%M`

#checks if $productTag is already existing in a filename
cd $fileDir
LIST=$(find . -name "$productTag*.txt")
echo "LIST="$LIST
# all filename containing $productTag are listed. The filename with the highest *.txt is listed as last.
# The LIST is reverted and the value * extracted
counter=$(echo $LIST | rev | cut -c5)
echo "counter"=$counter
oneFile=$productTag-$counter.txt
echo "oneFile="$oneFile

if [ -f $oneFile ];
   then 
   counter=$((counter + 1))
else
   counter=1
fi    

# name of file to be written and pushed  
fileToWrite=$productTag-$counter.txt
 
#extracts the mail of project leads
FILE_TO_READ=$scriptDir/mails.properties
   echo "These are the mails of responsible people" >> $fileToWrite
   echo "-----------------------------------------" >> $fileToWrite
   # Read file in lines
   while read line; do
     if [ -n "$line" ]; then
       echo "$line" >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
# extracts the repositories URL
   echo "These are the repositories" >> $fileToWrite
   echo "--------------------------" >> $fileToWrite
FILE_TO_READ=$scriptDir/repositories.properties
   while read line; do
     if [ -n "$line" ]; then
       echo "$line"/tree/"$communityTag" >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#extracts the TAG name
   echo "The name of community tag is:" $communityTag >> $fileToWrite
   echo "-----------------------------" >> $fileToWrite
   echo " "
   echo "The name of product tag is:" $productTag >> $fileToWrite
   echo "---------------------------" >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#gives the Maven and Java version
   echo "The JAVA version is:" >> $fileToWrite
   echo "--------------------" >> $fileToWrite
   java -version 2>>$fileToWrite
   echo ""  >> $fileToWrite
   echo "The Maven version is:" >> $fileToWrite
   echo "---------------------" >> $fileToWrite
   mvn --version >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#infos
   echo "NOTES:" >> $fileToWrite
   echo "------" >> $fileToWrite
FILE_TO_READ=$scriptDir/notes.properties
   while read line; do
     if [ -n "$line" ]; then
       echo "$line" >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite


#copies the file to the right git repository and pushes to the blessed repository
   cp $fileToWrite $fileDir
   cd $fileDir
   git add .
   git commit -m "$productTag"
   git push origin master
 
