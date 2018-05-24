SRC=/Android_Reldata/official_product_releases/msaf_downloads/out_zip
DST=/Android_Reldata/official_product_releases/Miscellaneous/out_zip/
cd ${SRC}
for l in `ls -tr1  | cut -d "_" -f 2-3 | sort | uniq`
do
  echo "....$l "
  $(which mkdir) ${DST}/$l 
  cp ${SRC}/*${l}*.zip ${DST}/$l/
done

