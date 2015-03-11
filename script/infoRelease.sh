#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
cd $scriptDir
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

#checks if file-name is already existing
cd $fileDir
LIST=$(find . -name "$productTag*.txt")
echo "LIST="$LIST
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
  
fileToWrite=$productTag-$counter.txt
repoDir=testRepo
 
#extracts the mail of project leads
FILE_TO_READ=$scriptDir/mails.properties
   echo  "These are the mails of responsible people" >> $fileToWrite
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
FILE_TO_READ=$scriptDir/repositories.properties
   while read line; do
     if [ -n "$line" ]; then
       echo "$line"/tree/$communityTAG >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#extracts the TAG name
   echo "The name of community tag is:" $communityTag >> $fileToWrite
   echo "The name of product tag is:" $productTag >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#gives the Maven and Java version
   echo "The JAVA version is:" >> $fileToWrite
   java -version 2>>$fileToWrite
   echo ""  >> $fileToWrite
   echo "The Maven version is:" >> $fileToWrite
   mvn --version >> $fileToWrite
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite
#infos
   echo "NOTES:" >> $fileToWrite
FILE_TO_READ=$scriptDir/notes.properties
   while read line; do
     if [ -n "$line" ]; then
       echo "$line" >> $fileToWrite
     fi
   done < $FILE_TO_READ
   echo "" >> $fileToWrite
   echo "" >> $fileToWrite


#copies the file to the right git repository
   TARGET_REPO=$scriptDir/../../../$repoDir
   cp $fileToWrite $TARGET_REPO
   cd $TARGET_REPO
   #chmod 755 $fileToWrite
   git add .
   git commit -m "$productTag"
   git push origin master
 
