kie-release-reports
========

In this repository are stored files that should serve as information of the kie releases
as well as tags for productisation.

    
## How to install this repo and run the script

    1. git clone git@github.com:jboss-integration/kie-release-reports.git
    
    2. cd kie-release-reports/script
    
    3. $ ./infoRelease <communityTag> <productTag> <targetProdBuild> <cutOffDate>
    where <communityTag> i.e. 6.2.0.Final
          <productTag> i.e. sync-6.2.x-2015.03.20
          <targetProdBuild> i.e 6.1.0.CR1
          <cutOffDate> i.e. 2015-03-19
    
    
The script runs and stores a file with name **productTag-*.txt** in kie-release-reports/reports/tags/<direcory of actual productTag> <br>
The script gets all information about a productTag from properties-files and from the machine where it is stored the repository.<br>
    
