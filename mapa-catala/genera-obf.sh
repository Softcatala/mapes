#!/bin/bash

cd /home/albert/OsmAndMapCreator-main

mv /home/albert/mapa-catala/data-anterior.txt /home/albert/mapa-catala/data-anterior2.txt
mv /home/albert/mapa-catala/data-actualitzat.txt /home/albert/mapa-catala/data-anterior.txt
date +%Y-%m-%d > /home/albert/mapa-catala/data-actualitzat.txt
DATE=`cat /home/albert/mapa-catala/data-actualitzat.txt`
DATE2=`cat /home/albert/mapa-catala/data-anterior.txt`
DATE3=`cat /home/albert/mapa-catala/data-anterior2.txt`

mytime="$(time ( java -Djava.util.logging.config.file=logging.properties -Xms64M -Xmx1000M -cp "./OsmAndMapCreator.jar:lib/OsmAnd-core.jar:./lib/*.jar" net.osmand.data.index.IndexBatchCreator batch.xml ) 2>&1 1>/dev/null )"

echo "-----------------------------------------------------" >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
echo "|            MAPA OBF GENERAT EL $DATE           |" >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
echo "-----------------------------------------------------" >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
echo " " >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
echo "$mytime" >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
cd /home/albert/mapbuild/osmand-pbf
stat -c %n-%s_bytes Territori-catala.osm.pbf >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
cd /home/albert/mapbuild/osmand-obf
stat -c %n-%s_bytes Territori-catala_2.obf >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt

echo " " >> /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt
cat /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt /home/albert/mapbuild/osmand-obf/Territori-catala_2.obf.gen.log > /home/albert/mapbuild/reg/Mapa-obf-$DATE.txt
rm /home/albert/mapbuild/reg/Mapa-obf-$DATE-pre.txt

cp /home/albert/mapbuild/reg/Mapa-obf-$DATE.txt /home/albert/public_html/mapa/registres/darrer-obf.txt

mv /home/albert/mapbuild/osmand-obf/Territori-catala_2.obf /home/albert/public_html/mapa/Territori-catala-$DATE.obf
cd /home/albert/mapbuild/osmand-gen
rm *.*
cd /home/albert/mapbuild/osmand-obf
rm *.*
cd /home/albert/mapbuild/osmand-pbf
rm *.*
rm /home/albert/public_html/mapa/Territori-catala-$DATE3.obf

DISC="/dev/mapper/pirineus-lxc"
GB=`df -h | grep $DISC | cut -c 41-42`
echo "L'actualització del fitxer del dia $DATE2 sembla que s'ha realitzat amb èxit el dia $DATE. S'ha esborrat el fitxer amb data $DATE3, i hi ha $GB GB lliures al servidor. Fitxer: http://gent.softcatala.org/albert/mapa/Territori-catala-$DATE.obf . Fitxer de seguretat: http://gent.softcatala.org/albert/mapa/Territori-catala-$DATE2.obf .Fitxer log:  http://gent.softcatala.org/albert/mapa/registres/darrer-obf.txt . " | mail -s "Actualització fitxer OBF-$DATE" lakonfrariadelavila@gmail.com

cd /home/albert/public_html/mapa/
ls -l *.obf > files.txt

