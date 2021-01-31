for k in  2 3 4 5 6
do
cd $k.conv
sbatch submit.job
cd ../
done
