#!/bin/bash

cd /home/albert/mapa-catala
date >> osm-name_ca-pbf.txt

# Actualitza el fitxer actual i el desa com a fitxer -nou
mytime="$(time ( ./osmconvert /home/albert/mapa/territori-catala.osm.pbf > territori-catala-catalanitzat.osm ) 2>&1 1>/dev/null )"
echo "$mytime" >> osm-name_ca-pbf.txt
cd /home/albert/mapa
stat -c %n-%s_bytes territori-catala.osm.pbf >> /home/albert/mapa-catala/osm-name_ca-pbf.txt
cd /home/albert/mapa-catala
stat -c %n-%s_bytes territori-catala-catalanitzat.osm >> osm-name_ca-pbf.txt
echo " ---------------------------------- " >> osm-name_ca-pbf.txt
echo " Aquí aniria l'script per catalanitzar el mapa " >> osm-name_ca-pbf.txt
echo " ---------------------------------- " >> osm-name_ca-pbf.txt
mytime2="$(time ( ./osmconvert territori-catala-catalanitzat.osm --out-pbf > /home/albert/mapbuild/osmand-pbf/Territori-catala.osm.pbf ) 2>&1 1>/dev/null )"
echo "$mytime2" >> osm-name_ca-pbf.txt
stat -c %n-%s_bytes territori-catala-catalanitzat.osm >> osm-name_ca-pbf.txt
cd /home/albert/mapbuild/osmand-pbf
stat -c %n-%s_bytes Territori-catala.osm.pbf >> /home/albert/mapa-catala/osm-name_ca-pbf.txt
cd /home/albert/mapa-catala
rm territori-catala-catalanitzat.osm
echo " ---------------------------------- " >> osm-name_ca-pbf.txt
echo " " >> osm-name_ca-pbf.txt
cp osm-name_ca-pbf.txt /home/albert/public_html/mapa/registres/pbf-catalanitzat.txt

