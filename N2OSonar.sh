#!/bin/bash 
#SONAR_LIST=`cat all_sonar_list`

ANDROID_BASE_FOLDER=$PWD
SONAR_RUNNER=/mnt/localdata/localhome/sonar/sonar-runner/bin/sonar-runner
PREVIEW_OPT="-Dsonar.analysis.mode=preview -Dsonar.issuesReport.console.enable=true"

VERSION=`cat  android/o-base/device/tpv/PH7M_EU_5596/system.prop  | grep ro.tpvision.product.swversion= | cut -d "="  -f 2`


for l in `cat .repo/project.list | egrep "common\/app|common\/plf" `
do
   prj=${l#android/o-base/*}
   last_dir="${prj##*/}"
   SONAR_LOG=$ANDROID_BASE_FOLDER/sonarlogs/sonar_analyze_$last_dir.log

   if [ "$1" = "preview" ] ; then
     echo "======== Run Sonar analyze for $prj in Preview mode ========" >> $SONAR_LOG
     test -e ${prj}/sonar-project.properties && ($SONAR_RUNNER ${PREVIEW_OPT} -Dproject.settings=${prj}/sonar-project.properties; \
		   echo "========Sonar analysis for  ${prj} is done " >> $SONAR_LOG) || (echo "NO ${prj}/sonar-project.properties" >> $SONAR_LOG)
   else
     if [ -e ${l}/sonar-project.properties ]  
     then
        cd android/o-base
	echo "======== Run Sonar analyze for $prj in Publish mode ========" >> $SONAR_LOG
	#//=== Sonar autorun command ===/ 
	D=N2O_`cat ${prj}/sonar-project.properties   | grep ^sonar.projectName | tr  -s " " "~" | cut -d "~" -f 3- | tr -s "~" " "`

	test -e ${prj}/sonar-project.properties && sed -i "s/^sonar.projectName = .*/sonar.projectName = $D/" ${prj}/sonar-project.properties &&  sed -i "s/sonar.projectVersion = .*/sonar.projectVersion = $VERSION/" ${prj}/sonar-project.properties && $SONAR_RUNNER  -Dproject.settings=${prj}/sonar-project.properties > $SONAR_LOG 2>&1
	if [ $? != 0 ] ; then
   	    $(which mv) ${SONAR_LOG}  ${SONAR_LOG}_FAIL
	fi
	sleep 3
	cd -
     fi  
   fi
done

