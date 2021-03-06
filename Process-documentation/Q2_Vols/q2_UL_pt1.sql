﻿-- Executing query:
/*

2015-2016 ARL Q2 - TEST STRATEGY for University Libraries, including Clermont & UC Blue Ash count of Vols. Held
This strategy collects the I Types which have typically been included in Vols Held, defined as Monographs, Serials, and Scores.

*/

SELECT distinct ON (item.id) item.id, itemview.record_num

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id)
    JOIN sierra_view.item_view itemview ON (item.id = itemview.id)

    WHERE 

    item.location_code LIKE 'u%'
        OR item.location_code = 'olink'
	OR item.location_code LIKE 'c%'
	OR item.location_code LIKE 'r%' AND item.location_code != 'rubj'
	OR item.location_code LIKE 'tdp%' AND (itemview.barcode LIKE '404%' OR itemview.barcode LIKE '407%' OR itemview.barcode LIKE '418%')
	-- OR (item.location_code LIKE 'tdpa%' AND item.item_message_code = 'u' (possibly double counting)

    
    AND i.bcode3 != 'd' AND i.bcode3 != 's' -- bib record is not suppressed
    
  
    AND i.cataloging_date_gmt <= '2015-06-30' -- cat date falls on or before last day of fiscal year
    AND itemview.record_creation_date_gmt <= '2015-06-30'-- item record created on or before last day of fiscal year
    
    AND item.item_status_code != 'w'
    AND (item.icode2 != 's'
	AND (item.itype_code_num between 1 and 8
		OR item.itype_code_num between 24 and 26
		OR item.itype_code_num between 33 and 35
		OR item.itype_code_num between 37 and 52
		OR item.itype_code_num = 75
		OR item.itype_code_num between 83 and 85))

