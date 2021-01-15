for i in 2 3 4 5 6 7 8 9
do
cd $i.kappa
sbatch submit.job
cd ../
done
