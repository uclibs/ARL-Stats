#!/bin/sh
#put password in .pgpass file

#production
#USERNAME=cdmsql
#dev
HOSTNAME=10.40.2.228
USERNAME=umcmillwh
DATABASE=iii
PORT=1032
THE_TABLE=sierra_view

#physical resources
#begin part 1
part1=$(psql -t "sslmode=require host=$HOSTNAME user=$USERNAME port=$PORT dbname=$DATABASE" << EOF
SELECT COUNT(DISTINCT i.id)

        FROM sierra_view.item_view i

    JOIN sierra_view.bib_record_item_record_link link ON (i.id = link.item_record_id) -- Bib/item linking table
    LEFT JOIN sierra_view.bib_view b ON (b.id = link.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (link.item_record_id = item.record_id)
    LEFT JOIN sierra_view.control_field y006 ON (i.id = y006.record_id AND y006.control_num = 6 AND y006.p00 = 'a')

    WHERE 

    (item.location_code LIKE 'u%'
    --OR item.location_code = 'olink'
    OR item.location_code LIKE 'c%'
    OR (item.location_code LIKE 'r%' AND item.location_code != 'rubj')
    OR (item.location_code LIKE 'tdp%' AND (i.barcode LIKE '404%' OR i.barcode LIKE '407%' OR i.barcode LIKE '418%')))

    
    AND b.bcode3 != 'd' AND b.bcode3 != 's' -- bib record is not suppressed
    
  
    AND b.cataloging_date_gmt <= '2015-06-30' -- cat date falls on or before last day of fiscal year
    AND i.record_creation_date_gmt <= '2015-06-30'-- item record created on or before last day of fiscal year
    
         --item is not withdrawn
    AND i.item_status_code != 'w'
        --item record is not suppressed
    AND i.icode2 != 's'
        --item is olink mono, serial, lrgprnt, score, braille, periodical, news
    AND (i.itype_code_num between 1 and 8
            --item is monoser, mixedmed, other
        OR i.itype_code_num between 24 and 26
            --item is otherbook, otherser, othersco
        OR i.itype_code_num between 33 and 35
            --item is otherarc, 2hr onight res, 1 day res, 3 day res, training mat, 4 hr res, 1 hr onight, 1 hr res, ocas med, gclc mmed, mono, serial/pcirc
        OR i.itype_code_num between 37 and 52
            --item is olink datafile
        --OR i.itype_code_num = 72
            --item is olink mixedmed
        OR i.itype_code_num = 75
            --item is olink otherbook, olink otherser, olink othersco
        OR i.itype_code_num between 83 and 85)

EOF)
#end part 1

#remote electronic resources
#begin part2
part2=$(psql -t "sslmode=require host=$HOSTNAME user=$USERNAME port=$PORT dbname=$DATABASE" << EOF

SELECT COUNT(DISTINCT i.id)

--SELECT COUNT (DISTINCT i.record_num)
FROM sierra_view.item_view i

JOIN sierra_view.bib_record_item_record_link link ON (i.id = link.item_record_id) -- Bib/item linking table
LEFT JOIN sierra_view.bib_view b ON (b.id = link.bib_record_id)
LEFT JOIN sierra_view.control_field y006 ON (i.id = y006.record_id AND y006.control_num = 6 AND y006.p00 = 'a')
INNER JOIN sierra_view.varfield u ON (b.id = u.record_id AND (u.marc_tag = '856' OR u.marc_tag = '956'))


WHERE

i.itype_code_num = 99
AND (b.bcode3 != 'd' OR b.bcode3 != 's')

AND b.cataloging_date_gmt <= '2015-06-30'

AND ((b.bcode2 = 'a' OR b.bcode2 = 't' OR b.bcode2 = 'c' OR b.bcode2 = 's')
OR (b.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 'c')
OR (b.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 'a')
OR (b.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 's')
OR (b.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 't')  )

AND (i.location_code = 'cint'
OR i.location_code = 'rint'
OR i.location_code = 'uint'
OR i.location_code = 'olink'
OR (substring(i.location_code from 1 for 1) BETWEEN 'u' AND 'v'))

EOF)
#end part 2

#looks for e-resources on a physical carrier in U Libraries or SWORD w/ appropriate format codes for content

#begin part 3
part3=$(psql -t "sslmode=require host=$HOSTNAME user=$USERNAME port=$PORT dbname=$DATABASE" << EOF
SELECT COUNT(DISTINCT item.id)

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.item_view itemview ON (item.id = itemview.id)
    LEFT JOIN sierra_view.control_field y006 ON (i.id = y006.record_id AND y006.control_num = 6 AND y006.p00 = 'a')
    JOIN sierra_view.varfield u ON (i.id = u.record_id)

    WHERE 
    (item.location_code LIKE 'u%'
    --OR item.location_code = 'olink'
    OR item.location_code LIKE 'c%'
    OR (item.location_code LIKE 'r%' AND item.location_code != 'rubj')
    -- or location code indicates item at SWORD with a barcode from University libraries, blue ash, clermont, etc.
    OR item.location_code LIKE 'tdp%' AND (itemview.barcode LIKE '404%' OR itemview.barcode LIKE '407%' OR itemview.barcode LIKE '418%')
    OR (item.location_code LIKE 'tdpa%' AND item.item_message_code = 'u'))

    AND i.bcode3 != 'd' AND i.bcode3 != 's' -- bib record is not suppressed
    
  
    AND i.cataloging_date_gmt <= '2015-06-30' -- cat date falls on or before last day of fiscal year
    AND itemview.record_creation_date_gmt <= '2015-06-30'-- item record created on or before last day of fiscal year
    
    AND item.item_status_code != 'w'
    AND item.icode2 != 's'
    AND ((item.itype_code_num = 22) OR (item.itype_code_num = 72))

    AND (bcode2 = 'a'
        OR bcode2 = 's'
        OR bcode2 = 't'
        OR bcode2 = 'c') 
          OR (i.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 'a')
          OR (i.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 's') 
          OR (i.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 't') 


--\g output.txt

EOF)
#end part 3

echo "part 1: " $part1
echo "part 2: " $part2
echo "part 3: " $part3
total=$((part1 + part2 + part3))
echo "total: " $total
echo "Question 2 Total: " $total|mail -s "ARL Question 2 Results" mcmillwh@ucmail.uc.edu