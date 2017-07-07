##!/usr/bin/sh

#export TOP=$(dirname $(readlink -f $0)) ;
echo " in mail $TOP $OUT_PATH $ANDIE"

export TOP=$(readlink -f ${ABS_PATH}/../../../../../../)
export TOP=/external/MTKBLD
export OUT_PATH=${TOP}/out/mediatek_linux/output
BRNCH="MTK2K15"
CLSTR="smarttv"
VERSION=`cat $TOP/device/tpvision/common/sde/upg/version.txt | cut -d "_" -f 2` ;
ANDRELLNK="http://tux.tpvision.com/Android_Release/"
BLDLNK="http://tux.tpvision.com/Android_Releases/official_product_releases/Miscellaneous/cluster_builds"
SCPPTH="/Android_Reldata/official_product_releases/Miscellaneous/cluster_builds"
DT=`date +%Y%m%d`
FromMail="SnehaAchar@tpvision.com"
ToMail="sneha.achar@tpvision.com"

export PTH="/Android_Reldata/official_product_releases/Miscellaneous/cluster_builds/$CLSTR/$BRNCH"

d=`cat make_log.txt | grep "make completed successfully" `
if [ $? ==  0 ] 
then
	mails "Successful Build "	
#for l in 9481815366 9620055694 9986851758 9845845066 9535233806 9741099844 9902582949
	mailm "MTK SmartTV Cluster Bld available"
else
	mailf "Failed Build "
	mailm "MTK SmartTV Cluster Bld Failed"
fi  
