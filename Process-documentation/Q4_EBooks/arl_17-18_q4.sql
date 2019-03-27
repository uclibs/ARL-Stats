/*

Query for ARL question 4 - 
Subquery returns deduped URLs with bib record number
Superquery returns set deduped by bib record number

*/

SELECT DISTINCT ON(a.record_num) a.record_num -- output deduped by bib record number

FROM

  (SELECT DISTINCT ON(substring(u.field_content FROM '\|u.*?(?=\||$)')) u.field_content, i.record_num -- Select deduped, raw URLs with bib record number

    FROM sierra_view.bib_view i
  
    JOIN sierra_view.bib_record_item_record_link link ON (i.id = link.bib_record_id) -- Bib/item linking table
    LEFT JOIN sierra_view.control_field y006 ON (i.id = y006.record_id AND y006.control_num = 6 AND y006.p00 = 'a')
    JOIN sierra_view.varfield u ON (i.id = u.record_id AND (u.marc_tag = '856' OR u.marc_tag = '956'))
    LEFT JOIN sierra_view.item_record item ON (link.item_record_id = item.record_id)

    WHERE 

    i.bcode3 != 'd' AND i.bcode3 != 's' -- bcode3 not equal to 'd' or 's'
  
    AND i.cataloging_date_gmt <= '2018-06-30' -- cat date falls on or before last day of fiscal year

    AND (i.bcode2 = 'a' OR i.bcode2 = 't' 
      OR (i.bcode2 = 'm' AND y006.control_num = 6 AND y006.p00 = 'a'))

    --Limit by item location code
  
    AND (item.location_code = 'cint'
      OR item.location_code = 'rint'
      OR item.location_code = 'uint'
      OR item.location_code = 'olink'
      OR (substring(item.location_code from 1 for 1) BETWEEN 'u' AND 'v' AND itype_code_num = '99'))) a
	  
--LIMIT 10;  

/*
ARL 12-13  Total query runtime: 561933 ms.
1,352,175 rows retrieved.

ARL 13-14  Total query runtime: 525821 ms.
  902,585 rows retrieved

ARL 14-15 
  980,326 rows retrieved

ARL 15-16
  1,019,440 rows retrieved

ARL 16-17 
  1,057,400 rows retrieved
*/

ARL 17-18 
Successfully run. Total query runtime: 2 min 34 secs. 
  1,069,689 rows affected.