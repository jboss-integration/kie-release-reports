#!/bin/bash -e

# go to script dir
cd $WORKSPACE

# resultant sed extraction files
./droolsjbpm-build-bootstrap/script/git-all.sh log -1 --format=%H  >> sedExtraction_1.txt
sed -e '1d;2d' -e '/Total/d' -e '/====/d' -e 's/Repository: //g' -e 's/^/\"/; s/$/\"/;' -e '/""/d' sedExtraction_1.txt >> sedExtraction_2.txt
sed -e '$!N;s/\n/ /g' -e 's/ / : /g' -e 's/$/ ,/' -e '$ s/.$//' sedExtraction_2.txt >> sedExtraction_3.txt

cat sedExtraction_3.txt

fileToWrite=$tagName.json
commitHash=$(cat sedExtraction_3.txt)


cat <<EOF > int.json

{
   "handover" : {
   "report_date": "$reportDate",
   "cutoff_date": "$cutOffDate",
   "target_product_build": "$targetProdBuild",
   "source_product_tag": "$tagName",
   "repos" : [
      {
         $commitHash
      }
    ]
   }
}

EOF

# indent json
python -m json.tool int.json >> $fileToWrite

# remove sed extraction and int files
rm sedExtraction*
rm int.json
