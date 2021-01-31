for i in 20 30 40 50 60 70  80 
do
cd $i.ecut
sbatch submit.job
cd ../
done
