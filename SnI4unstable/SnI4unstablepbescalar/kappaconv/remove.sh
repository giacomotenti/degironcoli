for i  in 3 4 5 6 7 8 9 
do
cd $i.kappa
cd out/
mv SnI4un.xml ../.
cd ../
rm -r ./out/
cd ../
done
