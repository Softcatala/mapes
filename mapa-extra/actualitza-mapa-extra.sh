#!/bin/bash

cd /home/albert/mapa-extra
date >> estat-actualització-mapa-extra.txt

# Actualitza el fitxer actual i el desa com a fitxer -nou
mytime="$(time ( ./osmupdate territori-catala-extra.osm.pbf territori-catala-extra-nou.osm.pbf -B=catala-extra.poly ) 2>&1 1>/dev/null )"
echo "$mytime" >> estat-actualització-mapa-extra.txt
stat -c %n-%s_bytes territori-catala-extra.osm.pbf >> estat-actualització-mapa-extra.txt
stat -c %n-%s_bytes territori-catala-extra-nou.osm.pbf >> estat-actualització-mapa-extra.txt
echo " ---------------------------------- " >> estat-actualització-mapa-extra.txt

# Canvia el nom del fitxer actual a -antic
mv territori-catala-extra.osm.pbf territori-catala-extra-antic.osm.pbf

# Canvia el nom del fitxer -nou a actual
mv  territori-catala-extra-nou.osm.pbf territori-catala-extra.osm.pbf

stat -c %n-%s_bytes territori-catala-extra-antic.osm.pbf >> estat-actualització-mapa-extra.txt
stat -c %n-%s_bytes territori-catala-extra.osm.pbf >> estat-actualització-mapa-extra.txt
echo " ---------------------------------- " >> estat-actualització-mapa-extra.txt
echo " " >> estat-actualització-mapa-extra.txt
cp estat-actualització-mapa-extra.txt /home/albert/public_html/mapa/registres/extra.txt

