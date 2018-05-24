PD=/msaf_downloads
for l in  2K17_release/jenkins 2K17_ARCHER_Cluster_Promote 2K17_KANE_Cluster_Promote HTV2K18
do
	CNT=`$(which find) $PD/$l -maxdepth 1 -mindepth 1 -type d | wc -l`
        if [ $CNT  -gt 6  ] ; then
               echo "$CNT greater  for $l "
	       DIFF=`expr $CNT - 6 `
	       ls -tr1 $PD/$l | grep TPM | head -${DIFF}  | xargs  -I fil  rm  -Rf  $PD/$l/fil
	fi 
done
rm -Rf ${PD}/out_zip/*.*
