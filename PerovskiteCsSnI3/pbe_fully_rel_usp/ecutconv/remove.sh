for i  in  50 60 70  80  90 100 
do
cd $i.ecut
#rm -r ./out/
rm scf.in
rm submit.job
cd ../
done
