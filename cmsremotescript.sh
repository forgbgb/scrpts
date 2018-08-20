#!/bin/bash 
PD=$(dirname $(readlink -f $0)) ; cd ${PD}
DT=`date -d '-1 day' '+%Y-%m-%d %H:%M'` ; $(which rm) -f archive.tar.gz  ; $(which rm) archive.tar
cd cms ; git fetch --all ; git checkout scrum/initialbranch ;  git pull --rebase origin scrum/initialbranch
#git log --oneline --since="${DT}" --pretty="%h %<(20,trunc)%cn %<(25,trunc)%ci   %s"  > Commit_list.txt
git log --oneline  --pretty="%h %<(20,trunc)%cn %<(25,trunc)%ci   %s"  > Commit_list.txt
rsync -e ssh Commit_*.txt  ubuntu@aws:cmsgit ; rm Commit_*.txt
#$(which scp) -i ~/.ssh/xibocms-m5dxlarge.pem  Commit_*.txt  ubuntu@34.252.215.158:cmsgit ; rm Commit_*.txt ; 
for l in "delta/shared/cms/lib" "delta/shared/cms/install"  "delta/shared/cms/locale"   "delta/shared/cms/modules" "delta/shared/cms/web/theme/custom/aoc_theme"
do 
#  $(which scp) -ri ~/.ssh/xibocms-m5dxlarge.pem $l ubuntu@34.252.215.158:cmsgit 
       $(which tar)  -rvf ../archive.tar $l
echo " ...." 
#  rsync -re ssh $l  ubuntu@aws:cmsgit
done   
  gzip ../archive.tar ../archive.tar.gz
  rsync -re ssh ../archive.tar.gz ubuntu@aws:cmsgit
ssh -i ~/.ssh/xibocms-m5dxlarge.pem ubuntu@34.252.215.158   ' [ -d cms ]  || mkdir -p  cms'
ssh -i ~/.ssh/xibocms-m5dxlarge.pem ubuntu@34.252.215.158   ' $(which tar) -xvzf  ./cmsgit/archive.tar.gz  -C ./cms/'
$(which rm) -Rf  ../archive.tar.gz  ../archive.tar
cd -
