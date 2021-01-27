for i in  50 60 70  80  90 100 
do
cd $i.ecut
sbatch submit.job
cd ../
done
