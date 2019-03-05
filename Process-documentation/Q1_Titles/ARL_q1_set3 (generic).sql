﻿/*

Question 1, set 3

*/

SELECT p.dedupTitle, p.Location FROM

(SELECT ARRAY_TO_STRING(ARRAY[t.field_content, a.field_content, alt_title.field_content, uni.field_content, ed.field_content], ' ') AS dedupTitle ,

string_agg(bibloc.location_code, ' ') AS Location

    FROM sierra_view.bib_view i

    JOIN sierra_view.varfield u ON (i.id = u.record_id AND (u.marc_tag = '856' OR u.marc_tag = '956'))
    LEFT JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id) -- Bib/item linking table
    LEFT JOIN sierra_view.bib_record_holding_record_link checlink ON (i.id = checlink.bib_record_id) -- Bib/item linking table
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    LEFT JOIN sierra_view.holding_record holding ON (checlink.holding_record_id = holding.record_id)
    LEFT JOIN sierra_view.holding_record_location holdingloc ON (checlink.holding_record_id = holdingloc.holding_record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id AND i.bcode2 = 'd') -- Bib format code here

    LEFT JOIN sierra_view.varfield t ON (i.id = t.record_id AND t.marc_tag = '245')
    LEFT JOIN sierra_view.varfield a ON (i.id = a.record_id AND a.varfield_type_code = 'a')
    LEFT JOIN sierra_view.varfield alt_title ON (i.id = alt_title.record_id AND alt_title.marc_tag = '240')
    LEFT JOIN sierra_view.varfield uni ON (i.id = uni.record_id AND uni.marc_tag = '130')
    LEFT JOIN sierra_view.varfield ed ON (i.id = ed.record_id AND ed.marc_tag = '250')

    WHERE 

    (checlink.holding_record_id > 0 OR itemlink.item_record_id > 0)
   -- AND i.record_num between '1000000' and '2000000'
    --AND holding.record_id = '184839'
    AND (item.location_code LIKE '%in%' OR holdingloc.location_code LIKE '%in%')
    AND i.bcode3 != 'd' AND i.bcode3 != 's'
  
    AND i.cataloging_date_gmt <= '2013-06-30' -- cat date falls on or before last day of fiscal year

GROUP BY dedupTitle 

) p

WHERE p.Location LIKE '%bcler%' = true
    OR p.Location LIKE '%bdpst%' = true
    OR p.Location LIKE '%brwc%' = true
    OR p.Location LIKE '%buar%' = true
    OR p.Location LIKE '%buas%' = true
    OR p.Location LIKE '%bucb%' = true
    OR p.Location LIKE '%bucl%' = true
    OR p.Location LIKE '%bucm%' = true
    OR p.Location LIKE '%bucr%' = true
    OR p.Location LIKE '%buctl%' = true
    OR p.Location LIKE '%buda%' = true
    OR p.Location LIKE '%buel%' = true
    OR p.Location LIKE '%buen%' = true
    OR p.Location LIKE '%bugp%' = true
    OR p.Location LIKE '%bula%' = true
    OR p.Location LIKE '%bhhsl%' = true
    OR p.Location LIKE '%bhner%' = true
    OR p.Location LIKE '%bhy%' = true
    OR p.Location LIKE '%bmlaw%' = true
    OR p.Location LIKE '%bbcrc%' = true
    OR p.Location LIKE '%bacam%' = true
    OR p.Location LIKE '%bamrc%' = true
    OR p.Location LIKE '%bpra%' = true
    OR p.Location LIKE '%brub%' = true
    OR p.Location LIKE '%bvll%' = true 