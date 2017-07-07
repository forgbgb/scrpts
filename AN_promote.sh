echo "*************************************************************************************************`date `"
   branch="androidn_2k16_mtk_mainline"
   scrum="20170622"

for l in `cat AN_input.txt`
do
   proj=`echo $l | cut -d ":" -f 1 `
   COMMIT=`echo $l | cut -d ":" -f 2 `
   cd  $proj ; source  ~/.tpvisionrc 
   git clean -xfd  ; git reset --hard
   git checkout -b `date  +%Y%m%d_%H%M%S` 
   git branch -l | xargs git branch -D 
   topic.make $branch  tpvision/$branch
#   git checkout topic_$branch
#   git fetch ; git pull --rebase origin tpvision/$branch
   git merge -m "Merge commit '$scrum  $COMMIT into $branch '" --no-ff $COMMIT
   echo "================================================================"
   cd -
done



