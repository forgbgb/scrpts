PD=/msaf_downloads

for l in  TPM PH8M_HE_5596 CR
do
        if [ $l ==  "CR" ] ; then
                CNT=`$(which find) $PD/HTV2K18  -maxdepth 1 -mindepth 1 -type d | grep $l | wc -l`
        else
                CNT=`$(which find) $PD/HTV2K18  -maxdepth 1 -mindepth 1 -type d | grep -v CR | grep $l | wc -l`
        fi
                if [ $CNT  -gt 6 ] ; then
                       echo "$CNT greater  for $l "
                       DIFF=`expr $CNT - 6 `
                       if [ $l ==  "CR" ] ; then
                           ls -tr1 $PD/HTV2K18 |   grep $l | head -${DIFF}  | xargs  -I fil  rm  -Rf  $PD/$l/fil
                       else
                           ls -tr1 $PD/HTV2K18 | grep -v CR |  grep $l | head -${DIFF}  | xargs  -I fil  rm  -Rf  $PD/$l/fil
                       fi
                fi
done





exit 0


for l in  HTV2K18
do
        CNT=`$(which find) $PD/$l -maxdepth 1 -mindepth 1 -type d | grep -v CR | grep PH8M_HE_5596 | wc -l`
        if [ $CNT  -gt 6 ] ; then
               echo "$CNT greater  for $l "
               DIFF=`expr $CNT - 6  `
               ls -tr1 $PD/$l | grep PH8M_HE_5596 | head -${DIFF}  | xargs  -I fil  rm  -Rf  $PD/$l/fil
        fi
done



for l in  HTV2K18
do
        CNT=`$(which find) $PD/$l -maxdepth 1 -mindepth 1 -type d | grep -v CR |  grep TPM | wc -l`
        if [ $CNT  -gt 6  ] ; then
               echo "$CNT greater  for $l "
               DIFF=`expr $CNT - 6 `
               ls -tr1 $PD/$l | grep TPM | head -${DIFF}  | xargs  -I fil  rm  -Rf  $PD/$l/fil
        fi
done
rm -Rf ${PD}/out_zip/*.*

