clear

############# For VID/IMG-<dt>-WA*.ext type of files  and  IMG_<dt>_<time>.ext 
Folder=Photos_Videos/photo_udupi_n_old_Jan13
newfolder=SortedPhotos_Videos
$(which find) $Folder -name \*.*  | egrep -v "THM|Thumb"   > $newfolder/a.txt 
  
for l in `$(which cat) ${newfolder}/a.txt`
do
    name="${l##*/}" 
    ext=`echo $name | $(which cut) -d "."  -f 2 ` 
    pth=${l%/*} 
#    echo "$l --- $pth --- $name $ext " 


   epoccrtime=`$(which stat) -c %X $l`
#   echo "Createtime : "`$(which stat) -c %X $l `" :: "`/usr/bin/stat -c %x $l`
   epocmdtime=`$(which stat) -c %Y $l `
#   echo "Modifytime : "`$(which stat) -c %Y $l `" :: "`/usr/bin/stat -c %y $l`
   let diff=$epocmdtime-$epoccrtime
   if [ $epocmdtime -gt $epoccrtime  ] ; then
#      echo "Create time is older "
#      echo "Modifytime : "`$(which stat) -c %x $l`
      DT=`$(which stat) -c %x $l`
   else
#      echo "Modify time is older "
#      echo Modifytime" : "`$(which stat) -c %y $l`
      DT=`$(which stat) -c %y $l`
   fi
   newname=`echo $DT |  $(which cut) -d "." -f 1  | $(which tr) '\n' ' ' | $(which sed)  -e 's/[^0-9]/ /g'  -e 's/^*//g' -e 's/ *$//g' | tr -s ' '  | $(which sed)  's/ //g'` 
   newname1=`$(which date) +%N`
#   echo ***********"time considered is ${newname}_${newname1}"
   newpath=${newfolder}/${newname}_${newname1}.${ext}
   echo ".............${l} ${newpath}" 
   if [  -e ${newpath}  ]  ;  then
       echo "Skipping ${l} "
   else
	$(which mv)  $l ${newpath}
   	if [ $? != 0 ] ; then
      	  echo "Failed Moving ${l}  to ${newpath} ..."
   	fi
   fi 
done
