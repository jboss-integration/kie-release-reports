testRepo
========

In this repository are stored files that should serve as information of
which community release is the base for product tag as well as a script file and property files
that construct these files.
    
    
## How to install this repo and run the script

    1. git clone git@github.com:mbiarnes/testRepo.git
    
    2. cd tesRepo/script
    
    3. $ ./infoRelease.sh <community-releaseTag> <productTag>
    where <community-releaseTag> could be .i.e 6.2.0.Final and <productTag> could be i.e. sync-6.2.x-2015.02.27
    
    
The script runs and stores a file with name **productTag-*.txt** in testRepo/reposrts/tags <br> The * is a number that increments each time the script runs with the same <productTag> as parameter.<br>
The script gets all information about a productTag from properties-files and from the machine where it is stored the repository.<br>
    
