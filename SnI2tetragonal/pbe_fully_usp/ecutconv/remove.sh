for i  in 20 30 40  50 60 70  80 
do
cd $i.ecut
#rm -r ./out/
rm scf.in
rm submit.job
cd ../
done
