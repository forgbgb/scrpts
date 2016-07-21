#PD=$(readlink -f  $(dirname $0) )
#!/bin/bash 

PD=`readlink -f $(dirname $0 )  `
echo $PD
LOG=${PD}/log/logfile_`date +%Y%m%d`
SRCPTH=/Android_Reldata/official_product_releases/Miscellaneous
DSTPTH=/android_relbkp/official_product_releases/Miscellaneous

MOV=false
#*************
echo "====================================================================================================================================" >> ${LOG}
echo " Executing on `date +%Y%m%d_%H%M%S`" >> ${LOG}   
echo "====================================================================================================================================" >> ${LOG}

funct() { 
sum=0 ; cnt=0
for l in `cat input10daysdata`
do
   CNT=` $(which find) $SRCPTH/$l -maxdepth 1  -mindepth  1  -type d   |  grep -E "QM|QV" | wc -l  | tr -s " " "~" | cut -d "~" -f 1 `   
   if [ $CNT -gt   300 ] ; then
      DIFF=`expr $CNT - 300  ` ;  
      ls -tr1 $SRCPTH/$l  | grep -E "QM|QV" |  head -${DIFF}  > folderstomov.txt 
      for m in ` cat folderstomov.txt `
      do
	  if [ -d $DSTPTH/$l/$m ] ; then 
             echo "****** Skipping: Dir $DSTPTH/$l/$m already exists: Please check it " >> ${LOG} 
          else
	     siz=`du -ms $SRCPTH/$l/$m   ` ; size=` echo $siz | tr -s " " "~" | cut -d "~" -f 1 ` ; b=`expr $sum + $size ` ; sum=$b ; cnt=$((cnt+1))  
             if $MOV   ; then 
	     	echo "Moving $SRCPTH/$l/$m  To $DSTPTH/$l/$m  => ${size}MB"  
	     	echo "Moving $SRCPTH/$l/$m  To $DSTPTH/$l/$m  => ${size}MB"  >> ${LOG}
	  #      $(which mv)  $SRCPTH/$l/$m  $DSTPTH/$l/       
		if [ $? != 0 ]  ; then  echo "!!!   Failed to moved folder $SRCPTH/$l/$m " >> ${LOG} ; fi 
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
if [ $size1 -gt $sum ] ; then  MOV=true ;  sleep 10 ; funct ;  fi 
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
