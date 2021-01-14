for i in 40 50 60 70 80 90 100
do
cd $i.ecut
grep ! vc-relax.out>datien
tail -1 datien>>../conven
cd ../
done
