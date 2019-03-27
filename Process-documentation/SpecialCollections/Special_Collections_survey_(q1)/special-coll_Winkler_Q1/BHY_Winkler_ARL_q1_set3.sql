﻿/*

Question 1, set 3, Winkler 2017-18

*/

SELECT p.dedupTitle--, p.Location 

FROM

(SELECT ARRAY_TO_STRING(ARRAY[t.field_content, a.field_content, alt_title.field_content, uni.field_content, ed.field_content], ' ') AS dedupTitle ,

string_agg(bibloc.location_code, ' ') AS Location

    FROM sierra_view.bib_view i

    JOIN sierra_view.varfield u ON (i.id = u.record_id AND (u.marc_tag = '856' OR u.marc_tag = '956'))
    LEFT JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id) -- Bib/item linking table
    LEFT JOIN sierra_view.bib_record_holding_record_link checlink ON (i.id = checlink.bib_record_id) -- Bib/item linking table
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    LEFT JOIN sierra_view.holding_record holding ON (checlink.holding_record_id = holding.record_id)
    LEFT JOIN sierra_view.holding_record_location holdingloc ON (checlink.holding_record_id = holdingloc.holding_record_id)

     JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id AND (i.bcode2 = 'p')) --mixed    
    -- JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id AND (i.bcode2 = 'a' OR i.bcode2 = 't')) --mono
    -- JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id AND (i.bcode2 = 'r')) --realia
    -- JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id AND (i.bcode2 = 's')) --serial
 
    LEFT JOIN sierra_view.varfield t ON (i.id = t.record_id AND t.marc_tag = '245')
    LEFT JOIN sierra_view.varfield a ON (i.id = a.record_id AND a.varfield_type_code = 'a')
    LEFT JOIN sierra_view.varfield alt_title ON (i.id = alt_title.record_id AND alt_title.marc_tag = '240')
    LEFT JOIN sierra_view.varfield uni ON (i.id = uni.record_id AND uni.marc_tag = '130')
    LEFT JOIN sierra_view.varfield ed ON (i.id = ed.record_id AND ed.marc_tag = '250')

    WHERE 

    (checlink.holding_record_id > 0 OR itemlink.item_record_id > 0)

    -- Many formats will require only 1 pass
    AND i.record_num >= '1000000' 
    
    -- Special Collections BUAR set3 format 'p' is problematic use: 
    -- AND i.record_num <= '3345124' -- the number is a .b# found in UCLID/Sierra list
    -- AND i.record_num > '3345124'

    -- Formats that require multiple passes (e.g., monographs) patterns
    -- AND i.record_num <= '2000000' -- pass 1
    -- AND i.record_num >= '2000001' -- pass 2
    -- AND i. record_num < '4000000'
    -- AND i.record_num >= '4000000' -- pass 3
    -- AND i.record_num <  '5000000' 
    -- AND i.record_num >= '5000000' -- pass 4

    -- OR
    -- AND i.record_num <= '3000000' -- pass 1
    -- AND i.record_num >= '3000001' -- pass 2
    -- AND i.record_num <  '5000000'
    -- AND i.record_num >= '5000000' -- pass 3


    AND (item.location_code LIKE 'hy%' OR holdingloc.location_code LIKE 'hy%')
    AND i.bcode3 != 'd' AND i.bcode3 != 's'
  
    AND i.cataloging_date_gmt <= '2018-06-30' -- cat date falls on or before last day of fiscal year

GROUP BY dedupTitle 

) p

WHERE p.Location LIKE '%in%'  