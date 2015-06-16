#!/bin/bash

cd /home/albert/mapa
date >> estat-actualització-mapa.txt

# Actualitza el fitxer actual i el desa com a fitxer -nou
mytime="$(time ( ./osmupdate territori-catala.osm.pbf territori-catala-nou.osm.pbf -B=catala.poly ) 2>&1 1>/dev/null )"
echo "$mytime" >> estat-actualització-mapa.txt
stat -c %n-%s_bytes territori-catala.osm.pbf >> estat-actualització-mapa.txt
stat -c %n-%s_bytes territori-catala-nou.osm.pbf >> estat-actualització-mapa.txt
echo " ---------------------------------- " >> estat-actualització-mapa.txt

# Canvia el nom del fitxer actual a -antic
mv territori-catala.osm.pbf territori-catala-antic.osm.pbf

# Canvia el nom del fitxer -nou a actual
mv  territori-catala-nou.osm.pbf territori-catala.osm.pbf

stat -c %n-%s_bytes territori-catala-antic.osm.pbf >> estat-actualització-mapa.txt
stat -c %n-%s_bytes territori-catala.osm.pbf >> estat-actualització-mapa.txt
echo " ---------------------------------- " >> estat-actualització-mapa.txt
echo " " >> estat-actualització-mapa.txt
cp estat-actualització-mapa.txt /home/albert/public_html/mapa/registres/mapa.txt

