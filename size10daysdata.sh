#PD=$(readlink -f  $(dirname $0) )
#!/bin/bash 

LOG=logfile_`date +%Y%m%d`
SRCPTH=/Android_Reldata
DSTPTH=/android_relbkp
MOV=false
#*************
echo "====================================================================================================================================" >> ${LOG}
echo " Executing on `date +%Y%m%d_%H%M%S`" >> ${LOG}   
echo "====================================================================================================================================" >> ${LOG}

funct() { 
sum=0 ; cnt=0
for l in `cat input10daysdata`
do
   CNT=` $(which find) $SRCPTH/official_product_releases/$l -maxdepth 1  -mindepth  1  -type d   | wc -l  | tr -s " " "~" | cut -d "~" -f 1 `   
   if [ $CNT -gt   15 ] ; then
      DIFF=`expr $CNT - 15 ` ;  
      ls -tr1 $SRCPTH/official_product_releases/$l  |  head -${DIFF}  > folderstomov.txt 
      for m in ` cat folderstomov.txt `
      do
	  if [ -d $DSTPTH/official_product_releases/$l/$m ] ; then 
             echo "****** Skipping: Dir $DSTPTH/official_product_releases/$l/$m already exists: Please check it " >> ${LOG} 
          else
             if $MOV   ; then 
	     	siz=`du -ms $SRCPTH/official_product_releases/$l/$m   ` ; size=` echo $siz | tr -s " " "~" | cut -d "~" -f 1 ` ; b=`expr $sum + $size ` ; sum=$b ; cnt=$((cnt+1))  
	     	echo "Moving $SRCPTH/official_product_releases/$l/$m  To $DSTPTH/official_product_releases/$l/ => ${size}MB"  >> ${LOG}
	        echo "	$(which mv)  $SRCPTH/official_product_releases/$l/$m  $DSTPTH/official_product_releases/$l/      " 
		if [ $? != 0 ]  ; then  echo "!!!   Failed to moved folder $SRCPTH/official_product_releases/$l/$m " >> ${LOG} ; fi 
	     fi	
          fi           	 
      done 
   else
      echo "------ Skipping  $SRCPTH/official_product_releases/$l as no of releases found $CNT <=10 "  >> ${LOG}
   fi 
done
size1=`df -hm ${DSTPTH}  | awk ' { if (NR == 3  )  print $3 } ' ` 
}

#Call fuciton to check disk space
funct
echo " " >> ${LOG} ; echo "$sum  MB needed to move  $cnt folder :  $size1 MB avialable at destination backup path : Please check and proceed "  >> ${LOG} ; echo " " >> ${LOG} 
if [ $size1 -gt $sum ] ; then  MOV=true ;  sleep 10 ; funct ;  fi 
exit 0 

########################## do not execute below one ###############################
for l in `cat input10daysdata`
do
   $(which find) $SRCPTH/official_product_releases/$l -maxdepth 1  -mindepth  1  -type d -mtime  +10  > folderstomov.txt
   noreleases=`  cat folderstomov.txt | wc -l `
   if [ $noreleases -gt 10 ] ; then 
   for m in `cat folderstomov.txt`
   do
      dstpath1=`echo $m | cut -d "/" -f 3- ` 
      if [ -d $DSTPTH/official_product_releases/$l  ] ; then 
	  #echo " $(which cp) -Rf $m  $DSTPTH/official_product_releases/$l/   "  
          siz=`du -ms $m  `   
          size=` echo $siz | tr -s " " "~" | cut -d "~" -f 1 `   
           b=`expr $sum  + $size` ;   sum=$b  
#	  if [  $?  == 0 ] ; then echo " Successful execution " ; fi 
      fi 
   done
echo $sum  $SRCPTH/official_product_releases/$l
done 

siz1=` du -ms /android_relbkp` 
size1=`echo $siz1 | tr -s " " "~" | cut -d "~" -f 1 `
echo "relbackup $size1 " 
exit 0 
