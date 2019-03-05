-- Executing query:
/*

2015-2016 ARL Q2 - Oesper

As with other C&D libs, the number of entries in ARL stats database does not add up to the number of item records in UCLID. We had a beginning figure from previous database for reports, but did not attempt to build that number into the acutal entries. Therefore, the numbers have to come from UCLID list 

This strategy collects the I Types which have typically been included in Vols Held 
Monographs, Serials, and Scores. 

*/

--SELECT distinct item.id
SELECT distinct ON (item.id) item.id, itemview.record_num

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id)
    JOIN sierra_view.item_view itemview ON (item.id = itemview.id)

    WHERE 

    item.location_code LIKE 'ucbb%'   
    AND i.bcode3 != 'd' AND i.bcode3 != 's' -- bib record is not suppressed
  
    AND i.cataloging_date_gmt <= '2016-06-30' -- cat date falls on or before last day of fiscal year 
    AND itemview.record_creation_date_gmt <= '2016-06-30'-- item record created on or before last day of fiscal year

    AND item.item_status_code != 'w'
    AND item.icode2 != 's'
    AND (item.itype_code_num between 1 and 8
    OR item.itype_code_num between 24 and 26
    OR item.itype_code_num between 33 and 35
    OR item.itype_code_num between 37 and 52
    OR item.itype_code_num = 75
    OR item.itype_code_num between 83 and 85)

/*

Total query runtime: 1781 ms.
19217 rows retrieved.

*/

