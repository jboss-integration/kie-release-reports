#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
cd $scriptDir
# where are the files stored
cd ../reports/tags
fileDir=$(pwd)


if [ $# != 4 ] ; then
    echo
    echo "Usage:"
    echo "  $0 communityTag productTag targetProdBuild cutOffDate"
    echo "For example:"
    echo "  $0 6.2.0.Final sync-6.2.x-2015.02.27 ER6 2015-02-27"
    echo
    exit 1
fi

echo "The communityTag is: "$1
echo "The prodcutTag is: "$2
echo "The target product build is: "$3
echo "The cutoff date is: " $4
echo -n "Is this ok? (Hit control-c if is not): "
read ok


communityTag=$1
productTag=$2
targetProdBuild=$3
cutOffDate=$4

#checks if $productTag is already existing in a filename
cd $fileDir
LIST=$(find . -name "$productTag*.txt" | sort)

# all filename containing $productTag are listed. The filename with the highest *.txt is listed as last.
# The LIST is reverted and the value * extracted
counter=$(echo $LIST | rev | cut -c5)
oneFile=$productTag-$counter.txt

if [ -f $oneFile ];
   then 
   counter=$((counter + 1))
 else
   counter=1
fi    

# name of file to be written and pushed  
fileToWrite=$productTag-$counter.txt


cd $scriptDir

CONTACTS=$(cat mails.properties)
# add to URL in repository.properties /tree/$communityTag
FILE_TO_READ=$scriptDir/repositories.properties
   while read line; do
     if [ -n "$line" ]; then
       echo "$line"/tree/"$communityTag" >> repURLS.txt
     fi
   done < $FILE_TO_READ
REPOSITORIES=$(cat repURLS.txt)
rm repURLS.txt
MAVEN=$(mvn -version)
NOTES=$(cat notes.properties)
# JAVA version as it neds a workaround
java -version 2>>javaVersion.txt
JAVAV=$(cat javaVersion.txt)
DATETIME=`date +%F-%H:%M`


cat <<EOF >$fileToWrite

------------------------------------------------------------------------
           Engineering to Productization Handoff Report
------------------------------------------------------------------------
Report Date: $DATETIME
Code Cutoff Date: $cutOffDate
Target Product Build: $targetProdBuild
Source Product Tag: $productTag
Community Tag (if available): $communityTag
 

------------------------------------------------------------------------   
                     Component owner contacts                           
------------------------------------------------------------------------
$CONTACTS


------------------------------------------------------------------------
                    Used repositories for build                         
------------------------------------------------------------------------
$REPOSITORIES


------------------------------------------------------------------------
                        Software versions                               
------------------------------------------------------------------------
JAVA: $JAVAV
________________________________________________________________________

MAVEN: $MAVEN


------------------------------------------------------------------------
                              Notes                                     
------------------------------------------------------------------------
$NOTES



EOF

# pushes $fileToWrite to the blessed repository
   rm javaVersion.txt
   mv $fileToWrite $fileDir/
   cd $fileDir
   git add $fileToWrite
   git commit -m "$productTag"
   git push origin master
   
