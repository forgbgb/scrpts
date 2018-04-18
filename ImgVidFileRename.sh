
clear

############# For VID/IMG-<dt>-WA*.ext type of files  and  IMG_<dt>_<time>.ext 
for l in `/bin/cat a.txt`
do
   echo "1. $l " 
   name=`echo $l | /usr/bin/cut -d "-" -f 2- | /usr/bin/cut -d "." -f 1 `
   type=`echo $l | /usr/bin/cut -d "-" -f 1`
   ext=`echo $l | /usr/bin/cut -d "." -f 2`
                newname="${name}_${type}.${ext}" 
   echo "2.  $name $type $ext : $newname " 

#   /bin/mv $l $newname
   if [ $? != 0 ] ; then
      exit 0
      echo "out..."
   fi

done








exit 0 
###################################### compare dates 

for l in `/usr/bin/cat a.txt`
do
   echo "1. $l " 
   epoccrtime=`/usr/bin/stat -c %X $l` 
   echo "Createtime : "`/usr/bin/stat -c %X $l `" :: "`/usr/bin/stat -c %x $l`
   epocmdtime=`/usr/bin/stat -c %Y $l ` 
   echo "Modifytime : "`/usr/bin/stat -c %Y $l `" :: "`/usr/bin/stat -c %y $l`
   let diff=$epocmdtime-$epoccrtime
   if [ $epocmdtime -gt $epoccrtime  ] ; then
      echo "Create time is older "
      echo "Modifytime : "`/usr/bin/stat -c %x $l`
      DT=`/usr/bin/stat -c %x $l`
   else
      echo "Modify time is older "
      echo Modifytime" : "`/usr/bin/stat -c %y $l`
      DT=`/usr/bin/stat -c %y $l`
   fi
echo $DT |  cut -d "." -f 1  | tr '\n' ' ' | sed  -e 's/[^0-9]/ /g'  -e 's/^*//g' -e 's/ *$//g' | tr -s ' '  | sed  's/ //g'
echo ""
done


exit 0
############# For VID_<dt>_<time>.ext type of files  and  IMG_<dt>_<time>.ext 
for l in `/usr/bin/cat a.txt`
do
   echo "1. $l " 
   name=`echo $l | /usr/bin/cut -d "_" -f 2- | /usr/bin/cut -d "." -f 1 `
   type=`echo $l | /usr/bin/cut -d "_" -f 1`
   ext=`echo $l | /usr/bin/cut -d "." -f 2`
                newname="${name}_${type}.${ext}" 
   echo "2.  $name $type $ext : $newname " 

   /usr/bin/mv $l $newname
   if [ $? != 0 ] ; then
      exit 0
      echo "out..."
   fi

done

