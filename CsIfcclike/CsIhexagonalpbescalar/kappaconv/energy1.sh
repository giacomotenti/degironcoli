for i in 3 4 5 6 7 8 9
do
cd $i.kappa
echo $(grep ! scf.out | tail -1) $i >> ../datienkappa
cd ../
done
