for i in 40 50 60 70 80 90 100
do
cd $i.ecut
grep CELL -3 vc-relax.out>datic
tail -4 datic>>../convcell
cd ../
done
