for i  in 40 50 60 70  80  90 100
do
cd $i.ecut
rm -r ./out/
rm submit.job
rm scf.in
rm scf.out
cd ../
done
