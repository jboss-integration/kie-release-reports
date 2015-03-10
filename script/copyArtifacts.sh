#!/bin/bash
#
###################################################################
#                                                                 #
#      copies all created artifacts to /tmp/<releaseVersion>      #     
#                                                                 #
###################################################################

JBPM_ARTIFACTS=/var/jbpm-artifacts

echo ""
echo "DEFINITION OF SCRIPT VARIABLES"
echo ""
echo "Target path where the artifacts will be copied to"
echo "1) /var/jbpm-artifacts/master (default)"
echo "2) /var/jbpm-artifacts/6.2.x"
echo ""
echo "Select 1 or 2"
read whichBranch
branch=master
echo " "
case "$whichBranch" in
     2) branch=6.2.x
     ;;
esac
echo ""
echo "Name of directory where release artifacts will reside in"
echo "i.e. 6.2.0.CR2"
read releaseVersion
echo " "
echo "Directory of /var/jbpm-artifacts/"$branch"/ to be deleted"
echo "(if there is no directory ignore this step by pressing enter)"
read oldDir
echo ""
echo "Source of created artifacts "
echo "1) master (default)"
echo "2) 6.1.x"
echo "3) 6.2.x"
echo "4) sync"
echo ""
echo "Select 1,2,3 or 4"
read USR_DIR
dir=droolsjbpm/master
case "$USR_DIR" in
  2) dir=droolsjbpm/6.1.x
  ;;
  3) dir=droolsjbpm/6.2.x
  ;;
  4) dir=sync/6.x.x
  ;;
esac
echo ""
echo "The target path will be: "$JBPM_ARTIFACTS/$branch
if [ -z "$oldDir" ]; then
   echo "There is no directory to delete!"
else
   echo "The old directory to delete is: " $JBPM_ARTIFACTS/$branch/$oldDir
fi
echo "The artifacts will be copied to : "$JBPM_ARTIFACTS/$branch/$releaseVersion
echo "The sources are located in: " $HOME/$dir
echo ""
echo -n "Is this ok? (Hit control-c if is not): "
read ok

# removes the old directory only if it is available
if [ -z "$oldDir" ]; then
  :
else
  rm -rf $JBPM_ARTIFACTS/$branch/$oldDir
fi

mkdir $JBPM_ARTIFACTS/$branch/$releaseVersion

REPO_DIR=$HOME/$dir
ARTIFACT_DIR=$JBPM_ARTIFACTS/$branch/$releaseVersion

# dashboard-builder
cp $REPO_DIR/dashboard-builder/builder/target/dashbuilder-*-jboss-as7.war $ARTIFACT_DIR
cp $REPO_DIR/dashboard-builder/builder/target/dashbuilder-*-tomcat7.war $ARTIFACT_DIR
cp $REPO_DIR/dashboard-builder/builder/target/dashbuilder-*-was8.war $ARTIFACT_DIR
cp $REPO_DIR/dashboard-builder/builder/target/dashbuilder-*-wildfly8.war $ARTIFACT_DIR
cp $REPO_DIR/dashboard-builder/builder/target/dashbuilder-*-eap6_4.war $ARTIFACT_DIR
cp $REPO_DIR/dashboard-builder/builder/target/dashbuilder-*-weblogic12.war $ARTIFACT_DIR

# jbpm-dashboard
cp $REPO_DIR/jbpm-dashboard/jbpm-dashboard-distributions/target/jbpm-dashbuilder-*-jboss-as7.war $ARTIFACT_DIR
cp $REPO_DIR/jbpm-dashboard/jbpm-dashboard-distributions/target/jbpm-dashbuilder-*-tomcat7.war $ARTIFACT_DIR
cp $REPO_DIR/jbpm-dashboard/jbpm-dashboard-distributions/target/jbpm-dashbuilder-*-was8.war $ARTIFACT_DIR
cp $REPO_DIR/jbpm-dashboard/jbpm-dashboard-distributions/target/jbpm-dashbuilder-*-wildfly8.war $ARTIFACT_DIR
cp $REPO_DIR/jbpm-dashboard/jbpm-dashboard-distributions/target/jbpm-dashbuilder-*-eap6_4.war $ARTIFACT_DIR
cp $REPO_DIR/jbpm-dashboard/jbpm-dashboard-distributions/target/jbpm-dashbuilder-*-weblogic12.war $ARTIFACT_DIR

# JBPM & droolsjbpm-tools & Optaplanner
cp $REPO_DIR/jbpm/jbpm-distribution/target/jbpm-*-bin.zip $ARTIFACT_DIR
cp $REPO_DIR/droolsjbpm-tools/drools-eclipse/org.drools.updatesite/target/org.drools.updatesite-*.zip $ARTIFACT_DIR
cp $REPO_DIR/optaplanner/optaplanner-distribution/target/optaplanner-distribution-*.zip $ARTIFACT_DIR

# BRMS
cp $REPO_DIR/kie-wb-distributions/kie-drools-wb/kie-drools-wb-distribution-wars/target/kie-drools-wb-*-wildfly8.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-drools-wb/kie-drools-wb-distribution-wars/target/kie-drools-wb-*-was8.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-drools-wb/kie-drools-wb-distribution-wars/target/kie-drools-wb-*-weblogic12.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-drools-wb/kie-drools-wb-distribution-wars/target/kie-drools-wb-*-eap6_4.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-drools-wb/kie-drools-wb-distribution-wars/target/kie-drools-wb-*-jboss-as7.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-drools-wb/kie-drools-wb-distribution-wars/target/kie-drools-wb-*-tomcat7.war $ARTIFACT_DIR

# BPMS  
cp $REPO_DIR/kie-wb-distributions/kie-wb/kie-wb-distribution-wars/target/kie-wb-*-wildfly8.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-wb/kie-wb-distribution-wars/target/kie-wb-*-weblogic12.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-wb/kie-wb-distribution-wars/target/kie-wb-*-was8.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-wb/kie-wb-distribution-wars/target/kie-wb-*-eap6_4.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-wb/kie-wb-distribution-wars/target/kie-wb-*-jboss-as7.war $ARTIFACT_DIR
cp $REPO_DIR/kie-wb-distributions/kie-wb/kie-wb-distribution-wars/target/kie-wb-*-tomcat7.war $ARTIFACT_DIR  
  
# BRMS $ BPMS modules
#cp $REPO_DIR/kie-wb-distributions/kie-eap-integration/kie-eap-distributions/kie-eap-distributions-bpms-layer/target/kie-eap-distributions-bpms-layer-*.zip $ARTIFACT_DIR
#cp $REPO_DIR/kie-wb-distributions/kie-eap-integration/kie-eap-distributions/kie-eap-distributions-bpms-webapp/target/kie-eap-distributions-bpms-webapp-*-jbpm-dashbuilder.war $ARTIFACT_DIR
#cp $REPO_DIR/kie-wb-distributions/kie-eap-integration/kie-eap-distributions/kie-eap-distributions-bpms-webapp/target/kie-eap-distributions-bpms-webapp-*-kie-wb.war $ARTIFACT_DIR
#cp $REPO_DIR/kie-wb-distributions/kie-eap-integration/kie-eap-distributions/kie-eap-distributions-brms-layer/target/kie-eap-distributions-brms-layer-*.zip $ARTIFACT_DIR
#cp $REPO_DIR/kie-wb-distributions/kie-eap-integration/kie-eap-distributions/kie-eap-distributions-brms-webapp/target/kie-eap-distributions-brms-webapp-*-kie-drools-wb.war $ARTIFACT_DIR  

# drools examples
mkdir $ARTIFACT_DIR/examples
cp -r $REPO_DIR/droolsjbpm-build-distribution/droolsjbpm-uber-distribution/target/droolsjbpm-uber-distribution-*/download_jboss_org/ $ARTIFACT_DIR/examples
rm -rf $ARTIFACT_DIR/examples/download_jboss_org/latest

# kie-server-services-*.jar
cp $REPO_DIR/droolsjbpm-integration/kie-server/kie-server-services/target/kie-server-services-*.jar $ARTIFACT_DIR
rm $ARTIFACT_DIR/kie-server-services-*-javadoc.jar
rm $ARTIFACT_DIR/kie-server-services-*-sources.jar
rm $ARTIFACT_DIR/kie-server-services-*-tests.jar

#kie-server*.war
cp $REPO_DIR/droolsjbpm-integration/kie-server/kie-server-distribution-wars/target/*.war $ARTIFACT_DIR

# copy documentation to $ARTIFACT_DIR/doc
mkdir $ARTIFACT_DIR/docs

mkdir $ARTIFACT_DIR/docs/drools-docs
cp -r $REPO_DIR/droolsjbpm-knowledge/kie-docs/drools-docs/target/docbook/publish/en-US/* $ARTIFACT_DIR/docs/drools-docs
mkdir $ARTIFACT_DIR/docs/jbpm-docs
cp -r $REPO_DIR/droolsjbpm-knowledge/kie-docs/jbpm-docs/target/docbook/publish/en-US/* $ARTIFACT_DIR/docs/jbpm-docs
mkdir $ARTIFACT_DIR/docs/dashbuilder-docs
cp -r $REPO_DIR/droolsjbpm-knowledge/kie-docs/dashbuilder-docs/target/docbook/publish/en-US/* $ARTIFACT_DIR/docs/dashbuilder-docs
mkdir $ARTIFACT_DIR/docs/optaplanner-docs
cp -r $REPO_DIR/optaplanner/optaplanner-docs/target/docbook/publish/en-US/* $ARTIFACT_DIR/docs/optaplanner-docs
mkdir $ARTIFACT_DIR/docs/optaplanner-javadoc
cp -r $REPO_DIR/droolsjbpm-build-distribution/droolsjbpm-uber-distribution/target/droolsjbpm-uber-distribution-*/docs_htdocs/optaplanner/release/*/optaplanner-javadoc/* $ARTIFACT_DIR/docs/optaplanner-javadoc
mkdir $ARTIFACT_DIR/docs/kie-api-javadoc
cp -r $REPO_DIR/droolsjbpm-build-distribution/droolsjbpm-uber-distribution/target/droolsjbpm-uber-distribution-*/docs_htdocs/drools/release/*/kie-api-javadoc/* $ARTIFACT_DIR/docs/kie-api-javadoc
mkdir $ARTIFACT_DIR/examples
cp -r $REPO_DIR/droolsjbpm-build-distribution/droolsjbpm-uber-distribution/target/droolsjbpm-uber-distribution-*/downloads_htdocs/optaplanner/release/*/optaplanner-distribution-*.zip $ARTIFACT_DIR/examples
cp -r $REPO_DIR/droolsjbpm-build-distribution/droolsjbpm-uber-distribution/target/droolsjbpm-uber-distribution-*/downloads_htdocs/drools/release/*/droolsjbpm-integration-distribution-*.zip $ARTIFACT_DIR/examples
cp -r $REPO_DIR/droolsjbpm-build-distribution/droolsjbpm-uber-distribution/target/droolsjbpm-uber-distribution-*/downloads_htdocs/drools/release/*/drools-distribution-*.zip $ARTIFACT_DIR/examples

mkdir $ARTIFACT_DIR/failedUnitTests

