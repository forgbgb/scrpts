cat .repo/project.list | egrep -v "tpvision|marvell" | while read item
do 
   cd ${item} 
	#FNAME=$(git config remote.origin.projectname|sed -e 's/\//__/g')
	BASE=/external/MRVLDLNA
	LOGFNAME=${BASE}/AOSP_ChangesByTPV_InMRVL.log

	
	COUNT=$(git --no-pager log  --oneline --author tpv | wc -l)
	#COUNT=$(git diff --stat  --left-right   --cherry-pick --oneline $DEST..$FROM | wc -l)
	#COUNT=$(git log --left-right   --cherry-pick --oneline $FROM..$DEST | wc -l)
	
	if [[ ${COUNT} != 0 ]]
	then
	echo "=============== $(git rev-parse --show-toplevel) " >> ${LOGFNAME}
	 git --no-pager log  --oneline --author tpv  >> ${LOGFNAME}

#	git diff --stat --left-right   --cherry-pick --oneline $DEST..$FROM >> ${LOGFNAME} 
	#git log --left-right --graph  --cherry-pick --oneline $DEST..$FROM >> ${LOGFNAME} 
	echo >> ${LOGFNAME}
	echo >> ${LOGFNAME}
	
	#  git log   HEAD...${DATUM} >> ${LOGFNAME}
	fi
  cd -
done

