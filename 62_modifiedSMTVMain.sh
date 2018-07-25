#!/bin/bash -x 
#cd /htv_archive/2K18HTV/MSAF_2k18_EU_HTV_M
#repo --trace sync -j8 
#echo "================== MIRRORDONE "

if [ $# -lt 1  ]
then
        echo "Usage : $0 SMTV/Channelapp/RFBasedCloning "
        exit
fi

SCRUM=${1:-SMTV}
DT=`date +%Y%m%d_%H%M` ; export REPO=$(which repo)
LOG=/home/ing01815/LOGS/${SCRUM}_Main_${HOSTNAME}_${DT}.log
MAILIDS="sneha.achar@tpv-tech.com  saugata.das@tpv-tech.com rashmi.topno@tpv-tech.com sayantan.majumder@tpv-tech.com deepak.patil@tpv-tech.com jeevan.gouda@tpv-tech.com kalyan.chakravarty@tpv-tech.com gyana.senapati@tpv-tech.com" 
MAILIDS="sneha.achar@tpvision.com sneha.achar@tpv-tech.com"
TUXHOME="/Android_Reldata/official_product_releases/2K18HTV/Main"
TUXPATH="http://tux.tpvision.com/Android_Releases/official_product_releases/2K18HTV/Main/${SCRUM}/${DT}"
exec  2>${LOG}
exec  1>${LOG}

LASTEXECUTION=1532422512
LASTEXECUTION=1532422512
CURRENTEXECUTION=`date +%s` 
SYNCSTATUS=true ; BLDSTATUS=true ; CONFLICTS=false; COUNT=false
PD=/mnt/localdata/build.pc/Archive/Scrum2SMTV
#PD=/mnt/localdata/localhome/build.pc/Archive/SMTVMain
echo " " > ${PD}/a ; cd $PD

case "$1" in
      Channelapp) echo "channelapp"
	BRANCH="2k18_mtk_msaf_kane_n_devprod_EU_HTV_Scrum_Channelapp"
	MANIFEST="default_Scrum_channelapp.xml"	
        ;;
      SMTV) echo "Smtv"
	BRANCH="2k18_mtk_msaf_kane_n_devprod_EU_HTV_Scrum_SmartTV"
	MANIFEST="default_Scrum_SmartTV.xml"	
        ;;
      RFBasedCloning) echo "RFBasedCloning"
	BRANCH="2k18_mtk_msaf_kane_n_devprod_EU_HTV_Scrum_RFBasedCloning"
	MANIFEST="default_Scrum_RFBasedCloning.xml"	
        ;;
      *) echo "Default smtv "
	BRANCH="2k18_mtk_msaf_kane_n_devprod_EU_HTV_Scrum_SmartTV"
	MANIFEST="default_Scrum_SmartTV.xml"	
        ;;
esac

#${REPO} init  -u ssh://url/tpv/platform/manifest -b 2k18_mtk_msaf_kane_n_devprod_EU_HTV  --reference=/htv_archive/2K18HTV/MSAF_2k18_EU_HTV_M
${REPO} forall -c ' git clean -xfd; git reset --hard  ; git rebase --abort '
${REPO}   --trace sync -d -f -c 
   if [  $? !=  0 ]  ; then
    SYNCSTATUS=false
    /usr/bin/mail -s " $SCRUM Failed in SYNC $HOSTNAME" ${MAILIDS}  < ${PD}/a
     echo ".................1" 
    exit 0
   fi
   echo "Sync done "
filename=`mktemp`
cat ${PD}/.repo/manifests/${MANIFEST} | grep revision | grep -v  "tags" | tr -s " "  "~" | cut -d "~" -f 4 | cut -d "\"" -f 2 >  ${filename}
for item in `cat ${filename} `
do 
  cd ${item} 
  SMTVTIP=`git log --oneline -1 --pretty="%h"  origin/${BRANCH}` 
  echo  " $item  ... $SMTVTIP"
  MERGESTAT=`git merge -m " Merging ${SMTVTIP} on $DT  ${SCRUM}->EU_HTV  " --no-ff ${SMTVTIP}` 
  if [  $? != 0 ]  ; then
     CONFLICTS=true
     echo " Conflicts found in ${item} during ${SMTVTIP} commit pick " >> ${PD}/a
     echo "$MERGESTAT "  >> ${PD}/a  
     git merge --abort 
  else
     echo "$MERGESTAT "  >> ${PD}/a
     if [ ` git log --oneline -10 --pretty="%cn %s" origin/2k18_mtk_msaf_kane_n_devprod_EU_HTV..HEAD  | egrep -vi "sync|build\.pc" | wc -l `  -gt 0  ]  ; then 
     COUNT=true  ; fi 
   fi 
  cd - 
done
 echo " ........... $CONFLICTS  $COUNT " 
  if   $CONFLICTS    ; then
   /usr/bin/mail -s " $SCRUM Conflicts found .. stopping bld process   $HOSTNAME" ${MAILIDS}  < ${PD}/a
   $(which rm) ${filename}
    exit 0
    elif ! $COUNT  ; then
      /usr/bin/mail -s " $SCRUM No commits found .. stopping bld process   $HOSTNAME" ${MAILIDS}  < ${PD}/a
       $(which rm) ${filename}
      exit 0
    else

${REPO}  forall -c '  if [ `git log origin/2k18_mtk_msaf_kane_n_devprod_EU_HTV..HEAD | wc -l` != 0 ] ; then echo "      "  ;  echo "........................................ ${REPO_PATH} ..................  " ;  git log --oneline --pretty=format:"%h | %<(20,trunc)%an |  %<(30,trunc)%cd | %s"  origin/2k18_mtk_msaf_kane_n_devprod_EU_HTV..HEAD ;  fi ' > ${PD}/Commit_${DT}.txt

   echo "================ SYNC DONE =============" 

#   cd android/n-base/
#   cd  prebuilts/sdk/tools
#   ./jack-admin stop-server
#   ./jack-admin kill-server
#   ./jack-admin install-server jack-launcher.jar   jack-server-4.8.ALPHA.jar
#   cd ${PD}/android/n-base/
#   rm -Rf out/ __TP*
#   source ./build/envsetup.sh
#   echo "=================== LUNCH ==============" 
#   lunch PH8M_HE_5596-userdebug
#   export USER=$(whoami)
#   make -j mtk_clean >  make.log 2>&1  ; make -j mtk_build > make.log 2>&1 ;  cd device/tpv/common/sde/upg ; sh generate_upg_lonelyrun_cmdmode.sh 2 ph8m_he_5596; sh generate_upg_lonelyrun_cmdmode.sh 3 ph8m_he_5596 

echo "Hai All,"  > ${PD}/tuxpath
echo "Logs for build is located @ $TUXPATH"  >> ${PD}/tuxpath
echo "..............." >>  ${PD}/tuxpath
   ssh docadmin@tux "mkdir -p ${TUXHOME}/${SCRUM}/${DT}"
   scp -r  ${PD}/android/n-base/make.log docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/
   scp ${PD}/Commit_${DT}.txt  docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/

   if [ -f ${PD}/android/n-base/out/mediatek_linux/output/upgrade_loader_perm_only.pkg   ]
   then
       cd  ${PD}/android/n-base/out/mediatek_linux/output
       ssh docadmin@tux "mkdir -p ${TUXHOME}/${SCRUM}/${DT}"
       scp -r upgrade_loader_perm_only.pkg upgrade_loader_no_perm.pkg  docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/
       cd ${PD}/android/n-base/__TPM181HE_R_Upg_Debug_normal
       scp -r ./upg/*.* docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/
       cd ${PD}
       scp ${PD}/Commit_${DT}.txt  docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/

   else
       BLDSTATUS=false
  fi

if $BLDSTATUS  ; then
  /usr/bin/mail  -s  "${SCRUM}  Mainline New branch   Bld. Passed  $HOSTNAME " ${MAILIDS}  < ${PD}/tuxpath
else
    /usr/bin/mail -s "${SCRUM} Mainline  New branch  Bld.. Failed  $HOSTNAME " ${MAILIDS}  < ${PD}/tuxpath 
fi 

   cd  ${PD}/android/n-base/prebuilts/sdk/tools
   ./jack-admin stop-server
   ./jack-admin kill-server
   rm -f ${PD}/Commit_*.*
fi 
