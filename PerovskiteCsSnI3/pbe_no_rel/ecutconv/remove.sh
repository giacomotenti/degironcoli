for i  in 40 50 60 70  80  90 
do
cd $i.ecut
cd out/
mv CsSnI3.xml ../
cd ../
rm -r ./out/
cd ../
done
