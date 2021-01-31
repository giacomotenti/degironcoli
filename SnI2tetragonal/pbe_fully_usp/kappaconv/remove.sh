for k  in  2 3 4 5 6 
do
cd $k.conv
rm -r ./out/
rm scf.in
rm submit.job
cd ../
done
