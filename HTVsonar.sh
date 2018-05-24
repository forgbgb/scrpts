#!/bin/bash 
#SONAR_LIST=`cat all_sonar_list`

ANDROID_BASE_FOLDER=$PWD
SONAR_RUNNER=/localhome/sonar/sonarrunner/bin/sonar-runner
PREVIEW_OPT="-Dsonar.analysis.mode=preview -Dsonar.issuesReport.console.enable=true"

VERSION=`cat  android/n-base/device/tpv/PH8M_HE_5596/system.prop  | grep ro.tpvision.product.swversion= | cut -d "="  -f 2`


for l in `cat .repo/project.list | egrep "common\/app|common\/plf" `
do
   echo $l
   prj=${l#android/n-base/*}
   last_dir="${prj##*/}"
   SONAR_LOG=$ANDROID_BASE_FOLDER/sonarlogs/sonar_analyze_$last_dir.log

   if [ "$1" = "preview" ] ; then
     echo "======== Run Sonar analyze for $prj in Preview mode ========" >> $SONAR_LOG
     test -e ${prj}/sonar-project.properties && ($SONAR_RUNNER ${PREVIEW_OPT} -Dproject.settings=${prj}/sonar-project.properties; \
		   echo "========Sonar analysis for  ${prj} is done " >> $SONAR_LOG) || (echo "NO ${prj}/sonar-project.properties" >> $SONAR_LOG)
   else
     cd android/n-base
     echo "======== Run Sonar analyze for $prj in Publish mode ========" >> $SONAR_LOG
     #//=== Sonar autorun command ===/ 
     #sed -i "s/TPM181HE_R.105.000.098.000/TPM181HE_R.005.000.119.000/" ${prj}/sonar-project.properties
     #sed -i "s/sonar.projectVersion = .*/sonar.projectVersion = TPM181HE_R.005.000.134.000/" ${prj}/sonar-project.properties
     test -e ${prj}/sonar-project.properties && sed -i "s/sonar.projectVersion = .*/sonar.projectVersion = $VERSION/" ${prj}/sonar-project.properties && $SONAR_RUNNER  -Dproject.settings=${prj}/sonar-project.properties > $SONAR_LOG 2>&1
     if [ $? != 0 ] ; then
       $(which mv) ${SONAR_LOG}  ${SONAR_LOG}_FAIL
     fi
     #test -e ${prj}/sonar-project.properties && ($SONAR_RUNNER -X -Dproject.settings=${prj}/sonar-project.properties; \
     #echo "========Sonar analysis for  ${prj} is done " >> $SONAR_LOG) || (echo "NO ${prj}/sonar-project.properties" >> $SONAR_LOG)
     sleep 3
     cd - 
   fi
done

