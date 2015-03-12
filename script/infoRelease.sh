#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
cd $scriptDir
# where are the files stored
cd ../reports/tags
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
pwd

CONTACTS=$(cat mails.properties)
REPOSITORIES=$(cat repositories.properties)
MAVEN=$(mvn -version)
NOTES=$(cat notes.properties)
# JAVA version as it neds a workaround
java -version 2>>javaVersion.txt
JAVAV=$(cat javaVersion.txt)


cat <<EOF >$fileToWrite
 
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
$JAVAV
________________________________________________________________________

$MAVEN


------------------------------------------------------------------------
                              Notes                                     
------------------------------------------------------------------------
$NOTES



EOF

# pushes $fileToWrite to the blessed repository
   rm javaVersion.txt
   
   git add .
   git commit -m "$productTag"
   git push origin master
   
