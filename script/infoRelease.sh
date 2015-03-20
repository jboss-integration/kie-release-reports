#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT="$(cd $(dirname "$0") && pwd)/$(basename "$0")"
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
logFileDir=$HOME/droolsjbpm


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

# checks if directory where the files are to be stored exists, if not it creates it
cd $scriptDir
cd ../reports/tags
if [ ! -d "$productTag" ]; then
  mkdir $productTag
  cd $productTag
else
  cd $productTag
fi
fileDir=$(pwd)

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
VERSIONS=$(cat versions.properties)
rm repURLS.txt
MAVEN=$(mvn -version)
NOTES=$(cat notes.properties)
# JAVA version as it needs a workaround
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
 
Product Pages: 
https://pp.engineering.redhat.com/pp/product/jbossbrms/overview
https://pp.engineering.redhat.com/pp/product/jbossbpms/overview

Overall community build info:
https://github.com/droolsjbpm/droolsjbpm-build-bootstrap/blob/master/README.md

------------------------------------------------------------------------
                          Build Tools                               
------------------------------------------------------------------------
JAVA: 
$JAVAV

MAVEN: 
$MAVEN

------------------------------------------------------------------------
                        Sources to build                         
------------------------------------------------------------------------
$REPOSITORIES

------------------------------------------------------------------------
                          3rd party  versions
------------------------------------------------------------------------

$VERSIONS

------------------------------------------------------------------------
                          Build Command
------------------------------------------------------------------------

mvn clean install -Dfull -Dprodcutized -DskipTests (building skipping the tests)
mvn clean install -Dfull -Dproductized -Dmaven.test.failure.ignore=true >> testResult.txt (building with test execution)

------------------------------------------------------------------------
                       Environment variables
------------------------------------------------------------------------ 

MAVEN_OPTS:
$MAVEN_OPTS

-----------------------------------------------------------------------  
                     Component owners contacts                           
------------------------------------------------------------------------
$CONTACTS

------------------------------------------------------------------------
                              Notes                                     
------------------------------------------------------------------------
$NOTES



EOF

# copies the build log to the lgo directory
cp $logFileDir/testResult.txt $fileDir/$productTag-$counter.log
gzip $fileDir/$productTag-$counter.log 
# makes missing directories for the dependency:trees
   cd $scriptDir
   cd ../reports/dependencyTree
   mkdir $productTag-$counter
   export dependencyDir=$productTag-$counter
   cd $scriptDir
   rm javaVersion.txt
   mv $fileToWrite $fileDir/
#creates the dependensyTrees
#./dependencyTree.sh
# pushes $fileToWrite to the blessed repository
   git add $fileToWrite
   git commit -m "$productTag"
   # best not to push automatically as it is always possible we need 
   # to fix something locally before pushing
   #git push origin master



