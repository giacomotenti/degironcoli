for i in 40 50 60 70 75 80 85  90 95 100 105 115
do
cd $i.ecut
grep ! vc-relax.out>dati
tail -1 dati>>../conven
cd ../
done
