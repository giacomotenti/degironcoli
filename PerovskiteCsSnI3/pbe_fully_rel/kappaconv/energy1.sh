for i in 2 3 4 5
do
cd $i.kconv
echo $(grep ! scf.out | tail -1) $i >> ../datien
cd ../
done
