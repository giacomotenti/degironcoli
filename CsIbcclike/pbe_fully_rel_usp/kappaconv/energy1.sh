for k in  2 3 4 5 6
do
cd $k.conv
echo $(grep ! scf.out | tail -1) $k >> ../datien
cd ../
done
