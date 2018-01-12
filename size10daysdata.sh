#PD=$(readlink -f  $(dirname $0) )
#!/bin/bash 

if [ $# -lt 1  ]
then
        echo "Usage : $0 PROD/DEV  "
        exit
fi

INPUT=${1:-DEV}
PD=`readlink -f $(dirname $0 )  `
echo $PD
LOG=${PD}/log/logfile_`date +%Y%m%d`

case "$1" in
      PROD) echo "PROD Copying"
	SRCPTH=/Android_Reldata/official_product_releases/Miscellaneous
	DSTPTH=/android_relbkp/official_product_releases/Miscellaneous
	NOOFRELEASES=200
	INFILE="PRODinput"
	;;
   *) echo "Default DEV  "
	SRCPTH=/Android_Reldata/official_product_releases
	DSTPTH=/android_relbkp/official_product_releases
	NOOFRELEASES=10
	INFILE="DEVinput"
	;;
esac
MOV=false
#*************
echo "====================================================================================================================================" >> ${LOG}
echo " Executing on `date +%Y%m%d_%H%M%S`" >> ${LOG}   
echo "====================================================================================================================================" >> ${LOG}

funct() { 
sum=0 ; cnt=0
for l in `cat ${PD}/${INFILE}`
do
   CNT=` $(which find) $SRCPTH/$l -maxdepth 1  -mindepth  1  -type d   |  grep -E "QM|QV|[^R]" | wc -l  | tr -s " " "~" | cut -d "~" -f 1 `   
   if [ $CNT -gt $NOOFRELEASES        ] ; then
      DIFF=`expr $CNT - $NOOFRELEASES    `   
      ls -tr1 $SRCPTH/$l  | grep -E "QM|QV|[^R]|TPM" |  head -${DIFF}  > ${PD}/folderstomov.txt 
      for m in ` cat ${PD}/folderstomov.txt `
      do
	  if [ -d $DSTPTH/$l/$m ] ; then 
             echo "****** Skipping: Dir $DSTPTH/$l/$m already exists: Please check it " >> ${LOG} 
          else
	     siz=`du -ms $SRCPTH/$l/$m   ` ; size=` echo $siz | tr -s " " "~" | cut -d "~" -f 1 ` ; b=`expr $sum + $size ` ; sum=$b ; cnt=$((cnt+1))  
             if $MOV   ; then 
	     	echo "Moving $SRCPTH/$l/$m  To $DSTPTH/$l/$m  => ${size}MB"  
	     	echo "Moving $SRCPTH/$l/$m  To $DSTPTH/$l/$m  => ${size}MB"  >> ${LOG}

	         $(which mv)  $SRCPTH/$l/$m  $DSTPTH/$l/       
		if [ $? != 0 ]  ; then  echo "!!!   Failed to move folder $SRCPTH/$l/$m " >> ${LOG} ; fi 
	     fi	
          fi           	 
      done 
   else
      echo "------ Skipping  $SRCPTH/$l as no of releases found $CNT <=10 "  >> ${LOG}
      echo "------ Skipping  $SRCPTH/$l as no of releases found $CNT <=10 "  
   fi 
done
size1=`df -hm ${DSTPTH}  | awk ' { if (NR == 3  )  print $3 } ' ` 
}

#Call fuciton to check disk space
funct
echo " " >> ${LOG} ; echo "$sum  MB needed to move  $cnt folder :  $size1 MB avialable at destination backup path : Please check and proceed "  >> ${LOG} ; echo " " >> ${LOG} 
echo " " >> ${LOG} ; echo "$sum  MB needed to move  $cnt folder :  $size1 MB avialable at destination backup path : Please check and proceed "  
if [ $size1 -gt $sum ] ; then  MOV=true ;  sleep 10 ; funct 
 else
    echo "$sum  MB needed to move  $cnt folder :  $size1 MB avialable at destination backup path : Please check and proceed "  | /bin/mail   -s "ALERT!! /android_relbkp has less space to copy ; Please check "  sneha.achar@tpvision.com  ;  fi 
exit 0 

















########################## do not execute below one ###############################
for l in `cat input10daysdata`
do
   $(which find) $SRCPTH/$l -maxdepth 1  -mindepth  1  -type d -mtime  +10  > folderstomov.txt
   noreleases=`  cat folderstomov.txt | wc -l `
   if [ $noreleases -gt 10 ] ; then 
   for m in `cat folderstomov.txt`
   do
      dstpath1=`echo $m | cut -d "/" -f 3- ` 
      if [ -d $DSTPTH/$l  ] ; then 
	  #echo " $(which cp) -Rf $m  $DSTPTH/$l/   "  
          siz=`du -ms $m  `   
          size=` echo $siz | tr -s " " "~" | cut -d "~" -f 1 `   
           b=`expr $sum  + $size` ;   sum=$b  
#	  if [  $?  == 0 ] ; then echo " Successful execution " ; fi 
      fi 
   done
echo $sum  $SRCPTH/$l
done 

siz1=` du -ms /android_relbkp` 
size1=`echo $siz1 | tr -s " " "~" | cut -d "~" -f 1 `
echo "relbackup $size1 " 
exit 0 
