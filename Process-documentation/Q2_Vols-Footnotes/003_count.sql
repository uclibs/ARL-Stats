-- Executing query:


SELECT y.field_content, count(y.field_content)
FROM sierra_view.bib_view i

LEFT JOIN sierra_view.varfield y ON (i.id = y.record_id and y.marc_tag = '003')
--LEFT JOIN sierra_view.varfield u ON (i.id = u.record_id and u.marc_tag = '730')

WHERE y.field_content LIKE 'ER-%'
AND i.bcode3 != 'd'
AND i.bcode3 != 's'
AND i.cataloging_date_gmt <= '2016-06-30'
AND (i.bcode2 = 'a' OR i.bcode2 = 't')

GROUP BY y.field_content


-- write passes to .csv files

/*

pass 1, include all formats
*/

/*

pass 2, limit to bcode2 = 'a' or 't'
	run another pass on 730? 

*/
