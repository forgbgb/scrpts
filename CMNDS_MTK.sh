#! /bin/bash
PWWD="/external/MTKBLD"
cd ${PWWD}
/bin/mv ${PWWD}/*push*.* ch* ../old

/usr/local/bin/repo forall -c "git clean -xfd; git reset --hard" 
#A=$? ; echo "*********** $A clean ooutput "  A="2" 
/usr/local/bin/repo init -m default.xml -u ssh://gerrit/platform/manifest -b tpvision/2k15_mtk_1446_1_devprod > ${PWWD}/repo.log
#A=$? || $A ; echo  "*********** $A init output " 

if [  $? !=  0 ] ; then 
  /usr/bin/mail -a snehaachar@tpvision.com  -s "2K15 SMTV : Repo init failure !! " sneha.achar@tpvision.com < ${PWWD}/repo.log  
  exit 0
fi
echo "======================== End of Repo init ==============" >> ${PWWD}/repo.log
/usr/local/bin/repo sync -d  >> ${PWWD}/repo.log
if [  $? !=  0 ] ; then 
  /usr/bin/mail -a snehaachar@tpvision.com  -s "2K15 SMTV : Repo sync failure !! " sneha.achar@tpvision.com < ${PWWD}/repo.log  
  exit 0
fi
/home/build.pc/SCM/scripts/work_in_progress/promotion/cherry_promotion.py -f smarttvsoc.json
FILE=`ls -tr1 /external/MTKBLD/change_log_cherry_pick_smarttv_tpvision*`
if [ -z $FILE   ] ; then
  /usr/bin/mail -a snehaachar@tpvision.com  -s "2K15 SMTV : No commits available for build !! " sneha.achar@tpvision.com < ${PWWD}/repo.log
  exit 0	
fi


echo "======================== End of Repo sync  ==============" >> ${PWWD}/repo.log
#cd ${PWWD}/device/tpvision/common/sde/upg
#./build_philipstv.sh -p MTK_5593FHT -b user
#./upgmaker.sh QM152E r r
#cd __QM152E_Upg_Retail/upg
#cd  ${PWWD}
rm -Rf out ; rm -Rf __Q*
cd ${PWWD}/device/tpvision/common/sde/upg
./build_philipstv.sh -p  MTK_5593U+ -b user
./upgmaker.sh QM151E r f 
cd  ${PWWD}
echo "====================================Builds done" 
bash BldNotify.sh
