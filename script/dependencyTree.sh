#!/bin/bash

# Absolute path to this script, e.g. /home/user/xxx/infoRlease.sh
SCRIPT="$(cd $(dirname "$0") && pwd)/$(basename "$0")"
# Absolute path this script is in, thus /home/user/xxx
scriptDir=$(dirname "$SCRIPT")
cd ..
rootDir=$(pwd)
targetDir=$rootDir/reports/dependencyTree
cd ../

FILE_TO_READ=$scriptDir/repositoryList.properties
   while read line; do
     if [ -n "$line" ]; then
       cd $line
       pwd   
       repository=$line
       echo "repository="$repository
       mvn dependency:tree | grep "^\[INFO\]" > $repository.txt
       mv $repository.txt $targetDir/$dependencyDir
       cd ..
     fi
   done < $FILE_TO_READ

