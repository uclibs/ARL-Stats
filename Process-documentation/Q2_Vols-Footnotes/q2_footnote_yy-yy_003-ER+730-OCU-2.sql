SELECT
  CONCAT('b', b.record_num, 'a'),
  s2.marc_tag,
  s2.tag,
  s2.content,
  s3.marc_tag,
  s3.field_content
FROM
  sierra_view.bib_view b
  JOIN sierra_view.subfield s ON b.id = s.record_id
  JOIN sierra_view.subfield s2 ON b.id = s2.record_id
  JOIN sierra_view.varfield s3 ON s.varfield_id = s3.id
WHERE
  b.bcode3 != 'd'
  AND b.bcode3 != 's'
  AND b.cataloging_date_gmt <= 'yyyy-06-30'
  AND (b.bcode2 = 'a' OR b.bcode2 = 't')

  AND s.marc_tag = '730'
  AND s.tag = '5'
  AND s.content = 'OCU'

  AND s2.marc_tag = '003'
  AND s2.tag IS NULL
  AND s2.content LIKE 'ER-%'

  -- the affected records start in the >= 3000000- range
  -- AND b.record_num >= '1000000'
  -- AND b.record_num <  '2000000'

  -- AND b.record_num >= '2000000'
  -- AND b.record_num <  '3000000'

  AND b.record_num >= '3000000'
  AND b.record_num <  '4000000'

  -- AND b.record_num >= '4000000'
  -- AND b.record_num <  '5000000'

  -- AND b.record_num >= '5000000'
  -- AND b.record_num <  '6000000'

  -- AND b.record_num >= '6000000'
  -- AND b.record_num <  '7000000'
;
