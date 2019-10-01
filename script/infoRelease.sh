#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT="$(cd $(dirname "$0") && pwd)/$(basename "$0")"
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")



if [ $# != 4 ] ; then
    echo
    echo "Usage:"
    echo "  $0 communityBranch productTag targetProdBuild cutOffDate"
    echo "For example:"
    echo "  $0 7.26.x sync-6.2.x-2015.02.27 RHDM_7.5.0.CR1 2015-02-27"
    echo
    exit 1
fi

echo "The communityBranch is: "$1
echo "The productTag is: "$2
echo "The target product build is: "$3
echo "The cutoff date is: " $4
echo -n "Is this ok? (Hit control-c if is not): "
read ok


communityBranch=$1
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

# name of file to be written and pushed
fileToWrite=$productTag.txt

cd $scriptDir

cat notes.properties log.txt >> reportNotes.txt

CONTACTS=$(cat mails.properties)
NOTES=$(cat reportNotes.txt)
DATETIME=`date +%F-%H:%M`


cat <<EOF >$fileToWrite

------------------------------------------------------------------------
           Engineering to Productization Handoff Report
------------------------------------------------------------------------
Report Date: $DATETIME
Code Cutoff Date: $cutOffDate
Target Product Build: $targetProdBuild
Prod Tag: $productTag
based on branch: community $communityBranch


Product Pages: 
https://pp.engineering.redhat.com/pp/product/jbossbrms/overview
https://pp.engineering.redhat.com/pp/product/jbossbpms/overview

Overall community build info:
https://github.com/droolsjbpm/droolsjbpm-build-bootstrap/blob/master/README.md

------------------------------------------------------------------------
                          Build Tools                               
------------------------------------------------------------------------
JAVA:
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
java version "1.8.0_201"
Java(TM) SE Runtime Environment (build 1.8.0_201-b09)
Java HotSpot(TM) 64-Bit Server VM (build 25.201-b09, mixed mode)

MAVEN:
Picked up JAVA_TOOL_OPTIONS: -Dfile.encoding=UTF-8
Apache Maven 3.5.2 (138edd61fd100ec658bfa2d307c43b76940a5d7d; 2017-10-18T09:58:13+02:00)
Maven home: /opt/tools/mavenVer
Java version: 1.8.0_201, vendor: Oracle Corporation
Java home: /opt/tools/jdk1.8.0_201/jre
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-514.el7.x86_64", arch: "amd64", family: "unix"
------------------------------------------------------------------------
                        Sources to build                         
------------------------------------------------------------------------
All tags $productTag are on Gerrit

------------------------------------------------------------------------
                          component  versions
------------------------------------------------------------------------

kie=$kieVersion

------------------------------------------------------------------------
                          Build Command
------------------------------------------------------------------------

mvn -B -e -U clean install -Dfull -Dproductized -Drelease -Dmaven.test.failure.ignore=true -Dgwt.memory.settings="-Xmx10g"

------------------------------------------------------------------------
                       Environment variables
------------------------------------------------------------------------ 

MAVEN_OPTS:
-Xms1g -Xmx3g

-----------------------------------------------------------------------  
                     Component owners contacts                           
------------------------------------------------------------------------
$CONTACTS

------------------------------------------------------------------------
                              Notes                                     
------------------------------------------------------------------------
$NOTES



EOF


# copy file to /tags
cp $fileToWrite ../reports/tags/$productTag

# remove files to prevent pushing them in automatic report generation & pipeline
rm $fileToWrite
rm reportNotes.txt
rm log.txt







