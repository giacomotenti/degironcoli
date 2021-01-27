for i  in  2 3 4 5 
do
cd $i.kconv
#rm -r ./out/
rm scf.in
rm submit.job
cd ../
done
