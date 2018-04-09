#!/bin/bash +vx 
ABS=$(dirname $(readlink -f $0))
if [[ ${ABS} =~ "android/n-base" ]] ; then 
  PREVREV=`cat ${ABS}/$0 | tail -2 | head -1` ; DT=`date +%Y%m%d_%H%M`
  $(which cat) $ABS/$0 | awk '(NR>=18) ' | while read item
  do
     if [[ $item =~ "device" ]] ; then
       cd  ${item}  ; echo "Executing on $item... "
       git fetch --tags -q
       export LATESTREV=${LATESTREV:-`git tag -l | grep TPM171E_R.105.000.*.000 | tail -1`} 
       echo "  " >> ${ABS}/${PREVREV}To${LATESTREV}_${DT}.txt 
       echo ".............. $item................." >> ${ABS}/${PREVREV}To${LATESTREV}_${DT}.txt
       git log --oneline --pretty=format:"%h | %<(20,trunc)%an |  %<(30,trunc)%cd | %s " ${PREVREV}..${LATESTREV}  >> ${ABS}/${PREVREV}To${LATESTREV}_${DT}.txt
       sed -i "s/^${PREVREV}/${LATESTREV}/"  ${ABS}/$0
       cd -
     fi
  done
else
   echo "Usage is : execute this  from android/n-base path "
   exit 0
fi 
<<GITS
device/tpv/common/app/icp
device/tpv/common/app/userlogging
device/tpv/common/app/nettvadvert
device/tpv/common/app/ipepgclient
device/tpv/common/app/nettvappgallery
device/tpv/common/app/nettvrecommender
device/tpv/common/app/nettvbrowser
device/tpv/common/app/nettvregistration
device/tpv/common/app/nettvlauncher
device/tpv/common/app/nettvapps
TPM171E_R.105.000.200.000
GITS
