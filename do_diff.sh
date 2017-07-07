DATUM=origin/tpvision/2k15_mtk_ldev_14431_asis
FNAME=$(git config remote.origin.projectname|sed -e 's/\//__/g')
BASE=/tmp/
LOGFNAME=${BASE}${FNAME}.log
rm -fv ${LOGFILE}


COUNT=$(git diff HEAD ${DATUM}|wc -l)


if [[ ${COUNT} != 0 ]]
then
  echo  "Entered.."
#  git diff HEAD ${DATUM}
  echo  > ${LOGFNAME} 
  echo  ${FNAME} >> ${LOGFNAME} 
  echo "DOING DIFF" >> ${LOGFNAME} 
  git diff --stat HEAD ${DATUM} >> $LOGFNAME
  echo "== END  DIFF" >> ${LOGFNAME} 

  echo  >> ${LOGFNAME} 
  echo "DOINF LOGS" >> ${LOGFNAME} 
  git log --stat  HEAD...${DATUM} >> ${LOGFNAME}
  echo "== END  LOGS" >> ${LOGFNAME} 


fi 



