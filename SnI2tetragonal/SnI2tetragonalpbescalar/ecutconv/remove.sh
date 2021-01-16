for i  in 40 50 60 70  80  90 100 
do
cd $i.ecut
cd out/
mv SnI2tetr.xml ../
cd ../
rm -r ./out/
cd ../
done
