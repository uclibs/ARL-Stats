-- Executing query:
/*


2015-2016 ARL Q2 - Winkler 

As with other C&D libs, the number of entries in ARL stats database does not add up to the number of item records in UCLID; 
we had a beginning figure from previous database for reports, but did not attempt to build that number into the acutal entries. 

So, the numbers have to come from UCLID list 

This strategy collects the I Types which have typically been included in "Vols Held" 
Monographs, Serials, and Scores (Vols).  Make a second pass for Realia (19) 

*/

SELECT distinct item.id

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id)

    WHERE 

    item.location_code LIKE 'hy%'
    AND i.bcode3 != 'd' AND i.bcode3 != 's' -- bib record is not suppressed
  
    AND i.cataloging_date_gmt <= '2016-06-30' -- cat date falls on or before last day of fiscal year
    
    AND item.item_status_code != 'w'
    AND item.icode2 != 's'
    AND (item.itype_code_num between 1 and 8
    OR item.itype_code_num between 24 and 26
    OR item.itype_code_num between 33 and 35
    OR item.itype_code_num between 37 and 52
    OR item.itype_code_num = 75
    OR item.itype_code_num between 83 and 85)
    -- AND item.itype_code_num = 19





/*

Additional parts:

field content	count	bcode2
"Check for parts: 2 genealogical charts + Inventory of Rothenberg papers"	3	"a"


*/






/*

Query used to get extra pieces:

SELECT message.field_content, count(message.field_content), i.bcode2

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id)
    JOIN sierra_view.varfield_view message ON (item.record_id = message.record_id AND message.record_type_code = 'i' AND message.varfield_type_code = 'm')

    WHERE 

    item.location_code LIKE 'hy%'


    
    AND i.bcode3 != 'd' AND i.bcode3 != 's' -- bib record is not suppressed
  
    AND i.cataloging_date_gmt <= '2013-06-30' -- cat date falls on or before last day of fiscal year
    AND item.item_status_code != 'w'
    AND item.icode2 != 's'
    AND (item.itype_code_num between 1 and 8
    OR item.itype_code_num between 24 and 26
    OR item.itype_code_num between 33 and 35
    OR item.itype_code_num between 37 and 52
    OR item.itype_code_num = 75
    OR item.itype_code_num between 83 and 85)
    AND lower(message.field_content) LIKE '%check%'

GROUP BY message.field_content, i.bcode2

*/