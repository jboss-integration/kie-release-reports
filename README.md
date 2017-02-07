kie-release-reports
========

In this repository are stored files that should serve as information of the kie releases
as well as tags for productisation.

    
## How to install this repo and run the script

    1. git clone git@github.com:jboss-integration/kie-release-reports.git
    
    2. cd kie-release-reports/script
    
    3. $ ./infoRelease <communityTag> <productTag> <targetProdBuild> <cutOffDate>
       i.e ./infoRelease 6.2.x sync-6.2.x-2015.05.27 6.1.1.CR2 2015-05-27
    
    
The script runs and stores a file with name **\<productTag\>-*.txt** in kie-release-reports/reports/tags/\<direcory of actual productTag\> <br>
The script gets all information about a productTag from properties-files and from the machine where it is stored the repository.<br>


## Property files

All property files are displayed in the final release-report. 
There are some that should not change with every release/sync, but others should.
The individual property files will be explained here:

#### mails.properties
     In this property file are stored all emails of project leads of the different repositories
     Should be changed only if there are modifications.

#### notes.properties
    The notes properties consist of information about the release/sync-tag.
    This file changes with each release/sync. The information considered to be important should be stored here.

#### repositories.properties
    In this property file all github URLs of all repositories are stored.
    Should be changed only if there are modifications.

#### repositoryList.properties
    This property file lists all repository for the script dependencyTree.sh, that is not yet a part of infoRelease.sh

#### versions.properties
    This property stores the versions of repositories used that have their own life-cycle.
    i.e. Jboss-integration-ip-bom version
       Uberfire version
       dashbuilder version
    This property file will change as version of 3rd party reps change or maybe there have to be added more.
    

**IMPORANT**: Please assure that before you generate a hand over report you pull the latest changes from github and that you push
    only information that should be stored there (i.e some important and permament modifications to property files and
    at least the generated hand-over report).
