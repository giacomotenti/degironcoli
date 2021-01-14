for i in 40 50 60 70 80 90 100
do
cd $i.ecut
echo $(grep ! vc-relax.out | tail -1) $i >> datien
cd ../
done
