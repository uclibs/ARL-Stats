-- Executing query:
/*

2015-2016 ARL Q2-BUAR

As with other C&D libs, the number of entries in ARL stats database does not add up to the number of item records in UCLID. We had a beginning figure from previous database for reports, but did not attempt to build that number into the acutal entries. So, the numbers have to come from UCLID list 

This strategy collects I Types which have typically been included in Vols Held 
Monographs, Serials, and Scores. 

*/

SELECT distinct ON (item.id) item.id, itemview.record_num

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id)
    JOIN sierra_view.item_view itemview ON (item.id = itemview.id)

    WHERE 

    (item.location_code LIKE 'uar%'
    OR (item.location_code LIKE 'tdpa%' AND item.item_message_code = 'u'))

    
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

Total query runtime: 31321 ms.
88148 rows retrieved.

88,148 - does not include a count of accompanying material or additional pieces.  See additional pieces below. 


Note	count	bcode2
Check for 1 CD	3	a
Check for 1 CDROM	26	a
Check for 1 DVD	1	a
Check for 1 fiche	4	a
Check for 1 folded sheet laid in	1	a
Check for 1 leaf laid in	1	a
Check for 1 sheet laid in: Wochenbericht {232]uber Missionsarbeit	1	a
Check for 10 leaves of poetry + 11 descriptive leaves (poem: Sappho + wanting)	1	a
Check for 14 PAMPHLETS	1	a
Check for 2 clippings laid in	1	a
Check for 2 price lists laid in	1	a
Check for 2003 exhibit brochure (1 fold. sheet) laid in	1	a
Check for 5 items	5	a
Check for 5 sheets + 1 envelope laid in	1	a
Check for 9 Lieferungen	1	a
Check for I fold. map in back of book	1	a
Check for a Cincinnati newspaper clipping laid in about the Gerok tombstone in Stuttgart	1	a
Check for dealer's description laid in at back	1	a
Check for facsim. broadside laid in	2	a
Check for facsim. broadside laid in.	2	a
Check for folded leaf laid in	1	a
Check for laid in items	1	a
Check for letter laid in	1	a
Check for loose sheet laid in at back	1	a
Check for map	1	a
Check for 1 leather case + 1 display stand	1	c
Check for 1 CD	3	d
Check for 1 score + 1 CD	1	d
Check for 2 CD	3	d
Check for 1 CDROM	2	m
Check for 1 CDROM in jewel case attached to inside front cover of handbook	1	m
Check for 1 CDROM	4	s
Check for 12 ISSUES: 1884,1885,1886,1887 (2 copies),1888,1889,1892 (2 copies),1894,1895,1897	1	s
Check for 4 fiche	1	s
Check for calendar leaf laid in	1	s
Check for cover missing (see if matches with the 1 Frances provided)	2	s
Check for inserted item (1 fold. sheet)	1	s
checked out to bindery 3/5/09	4	s
Check for 1 CD	5	t
Check for 1 CDROM	9	t
Check for parts	1	t


*/




/*

This is the strategy to find extra pieces --

SELECT message.field_content, count(message.field_content), i.bcode2

    FROM sierra_view.bib_view i

    JOIN sierra_view.bib_record_item_record_link itemlink ON (i.id = itemlink.bib_record_id)
    LEFT JOIN sierra_view.item_record item ON (itemlink.item_record_id = item.record_id)
    JOIN sierra_view.bib_record_location bibloc ON (i.id = bibloc.bib_record_id)
    JOIN sierra_view.varfield_view message ON (item.record_id = message.record_id AND message.record_type_code = 'i' AND message.varfield_type_code = 'm')

    WHERE 

    (item.location_code LIKE 'uar%'
    OR (item.location_code LIKE 'tdpa%' AND item.item_message_code = 'u'))

    
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
