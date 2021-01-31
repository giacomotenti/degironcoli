for i in 20 30 40 50 60 70 80
do
cd $i.ecut
echo $(grep ! scf.out | tail -1) $i >> ../datien
cd ../
done
