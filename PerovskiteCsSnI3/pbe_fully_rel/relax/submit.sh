for i in  2 3 4 5 
do
cd $i.kconv
sbatch submit.job
cd ../
done
