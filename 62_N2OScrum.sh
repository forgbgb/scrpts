#!/bin/bash -x 
#echo "================== MIRRORDONE "


if [ $# -lt 1  ]
then
        echo "Usage : $0 SMTV/BRDCST/AVL "
        exit
fi
SCRUM=${1:-SMTV}
DT=`date +%Y%m%d_%H%M` ; export REPO=$(which repo)  
LOG=/home/ing01815/LOGS/${SCRUM}_N2OScrum_${HOSTNAME}_${DT}.log
MAILIDS="sneha.achar@tpv-tech.com" 
#MAILIDS="sneha.achar@tpv-tech.com  saugata.das@tpv-tech.com rashmi.topno@tpv-tech.com sayantan.majumder@tpv-tech.com deepak.patil@tpv-tech.com jeevan.gouda@tpv-tech.com kalyan.chakravarty@tpv-tech.com gyana.senapati@tpv-tech.com" 
MAILIDS="sneha.achar@tpvision.com"
#MAILIDS="sneha.achar@tpvision.com sneha.achar@tpv-tech.com"
TUXHOME="/Android_Reldata/official_product_releases/2K18_N2O/Scrum"

exec  2>${LOG}
exec  1>${LOG}

SYNCSTATUS="True" ; BLDSTATUS="True"
PD=/mnt/localdata/localhome/build.pc/Archive/N2OScrum
cd $PD

case "$1" in
      BRDCST) echo "BRDCST"
        ${REPO} init -m default_BRDCST.xml -u ssh://url/tpv/platform/manifest -b 2k18_mtk_msaf_kane_o_devprod  --reference=/htv_archive/2K18HTV/MSAF_2k18_EU_HTV_M
        ;;
      SMTV) echo "Smtv"
        ${REPO} init -m default_SMTV.xml  -u ssh://url/tpv/platform/manifest -b 2k18_mtk_msaf_kane_o_devprod  --reference=/htv_archive/2K18HTV/MSAF_2k18_EU_HTV_M
        ;;
      AVL) echo "AVL"
        ${REPO} init -m default_AVL.xml   -u ssh://url/tpv/platform/manifest -b 2k18_mtk_msaf_kane_o_devprod  --reference=/htv_archive/2K18HTV/MSAF_2k18_EU_HTV_M
        ;;
      *) echo "Default smtv "
        ${REPO} init -m default_SMTV.xml  -u ssh://url/tpv/platform/manifest -b 2k18_mtk_msaf_kane_o_devprod  --reference=/htv_archive/2K18HTV/MSAF_2k18_EU_HTV_M
        ;;
esac

${REPO}  forall -c ' git clean -xfd; git reset --hard  '
${REPO}   --trace sync -d -f 
   if [  $? !=  0 ]  ; then
    SYNCSTATUS="False"
    /usr/bin/mail -s " $SCRUM Failed in SYNC $HOSTNAME" ${MAILIDS}  < ${PD}/a 
    exit 0
   fi

   echo "Sync done " 
##${REPO}  forall -c '  if [ `git log TPM181HE_R.005.000.074.000..HEAD | wc -l` != 0 ] ; then echo "      "  ;  echo "........................................ ${REPO_PATH} ..................  " ;  git log --oneline --pretty=format:"%h | %<(20,trunc)%an |  %<(30,trunc)%cd | %s"  TPM181HE_R.005.000.074.000..HEAD ;  fi ' > ${PD}/Commit_${DT}.txt
${REPO}  forall -c '  if [ `git log origin/2k18_mtk_msaf_kane_o_devprod..HEAD | wc -l` != 0 ] ; then echo "      "  ;  echo "........................................ ${REPO_PATH} ..................  " ;  git log --oneline --pretty=format:"%h | %<(20,trunc)%an |  %<(30,trunc)%cd | %s"  origin/2k18_mtk_msaf_kane_o_devprod..HEAD ;  fi ' > ${PD}/Commit_${DT}.txt
   echo "================ SYNC DONE =============" 

   cd android/o-base/
   cd  prebuilts/sdk/tools
   ./jack-admin stop-server
   ./jack-admin kill-server
   ./jack-admin install-server jack-launcher.jar jack-server-4.11.ALPHA.jar
   cd ${PD}/android/o-base/
#   rm -Rf out/ __TPM181HE_R_Upg_*
   source ./build/envsetup.sh
   echo "=================== LUNCH ==============" 
   lunch PH7M_EU_5596-userdebug
#choose the option of PH7M_EU_5596-userdebug from menu
#cd  device/tpv/PH7M_EU_5596
#git fetch ssh://build.pc@172.16.112.71:29418/tpv/device/tpv/ph7m_eu_5596 refs/changes/96/49096/1 && git cherry-pick FETCH_HEAD
#cd -
  export USER=$(whoami) 
   make -j mtk_clean >  make.log 2>&1  ; make -j mtk_build > make.log 2>&1 ;
   #make -j mtk_clean >  make.log 2>&1  ; make -j mtk_build > make.log 2>&1 ; cd device/tpv/common/sde/upg ; sh generate_upg_lonelyrun_cmdmode.sh 2 ph8m_he_5596 ; sh generate_upg_lonelyrun_cmdmode.sh 3 ph8m_he_5596

TUXPATH="http://tux.tpvision.com/Android_Releases/official_product_releases/2K18_N2O/Scrum/${SCRUM}/${DT}" 
echo "Hai All,"  > ${PD}/tuxpath 
echo "Logs for build is located @ $TUXPATH"  >> ${PD}/tuxpath 
echo "..............." >>  ${PD}/tuxpath
   ssh docadmin@tux "mkdir -p ${TUXHOME}/${SCRUM}/${DT}"
   scp -r  ${PD}/android/o-base/make.log docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/ 
   scp ${PD}/Commit_${DT}.txt docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/

   if [ -f ${PD}/android/o-base/out/mediatek_linux/output/upgrade_loader_perm_only.pkg   ]
   then
       cd  ${PD}/android/o-base/out/mediatek_linux/output
       ssh docadmin@tux "mkdir -p ${TUXHOME}/${SCRUM}/${DT}"
       scp -r upgrade_loader_perm_only.pkg upgrade_loader_no_perm.pkg  docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/
       #cd ${PD}/android/o-base/__TPM181HE_R_Upg_Debug_normal
       #scp -r ./upg/*.* docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/
       cd ${PD}
       scp ${PD}/Commit_${DT}.txt  docadmin@tux:${TUXHOME}/${SCRUM}/${DT}/

   else
       BLDSTATUS="False"
   fi 

if  [  $BLDSTATUS == "True"   ] ; then
    /usr/bin/mail  -s " $SCRUM  N2O Bld Passed   $HOSTNAME " ${MAILIDS}  < ${PD}/tuxpath
else
    /usr/bin/mail -s " $SCRUM N2O  Bld Failed  $HOSTNAME " ${MAILIDS}  < ${PD}/tuxpath 
fi 

   cd  ${PD}/android/o-base/prebuilts/sdk/tools
   ./jack-admin stop-server
   ./jack-admin kill-server
   rm -f ${PD}/Commit_*.*

