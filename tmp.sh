#default_tpvision.xml
#echo "" > project.list1
for l in `cat project.list` 
do
	_NAM=`echo $l | rev | cut -d "/" -f 1 | rev`
	echo $l $_NAM
#	$(which cat) default_tpvision.xml | grep $_NAM\"   >> project.list1     
#        grep -w $_NAM\"  default_tpvision.xml | wc -l
	grep -vE /$_NAM\"  default_tpvision.xml > default_tpvision1.xml
	$(which mv) default_tpvision1.xml default_tpvision.xml
done	
	

