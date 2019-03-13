Check that any records with 001 ^ wln are suppressed to &quot;s&quot;

As nearly as possible,

Q1: Titles held June 30, 20-- (all formats)

Run lists for three discreet sets of records:

(set 1) Internet  resources (remote electronic resources), including  url on print bibs, but no print item attached

(set 2) Non-internet  resources , physical carrier, including electronic resources on physical carrier (e.g., disc)

(set 3) Both electronic resource .and physical represented on single bib.

|   | **Set 1: Internet Resource (url, remote e-resource)** |
| --- | --- |
| Gather data | MARC tag 856 != &quot;&quot; OR MARC tag 956 != &quot;&quot;AND BIB LOC = Internet locations (attached item or ckin internet locations)AND BIB LOC = All fields don&#39;t have print locations ARL\_q1\_set1 (generic).sqlmono\_arl\_16-17\_q1\_set1.sql |
| Search strategy specifies |
|   | **Set 2: Physical carrier, no Internet (no url)** |
| Search strategy specifies | MARC tag 856 = &quot;&quot; OR MARC tag 956 = &quot;&quot;AND BIB LOC = ONLY Print locations (do we need to specify?) ARL\_q1\_set2 (generic).sqlmono\_arl\_16-17\_q1\_set2.sql |
|   | **Set 3 Physical carrier (e.g., print) AND Internet Resource** |
| Search strategy | MARC tag 856 != &quot;&quot; OR MARC tag 956 != &quot;&quot;AND BIB LOC = Includes both Internet and non-InternetAND Item and checkin include both  _(Some titles should be counted twice, others (especially monographs) may duplicate a title from Set 1, should be counted only once)_ ARL\_q1\_set3 (generic).sqlmono\_arl\_16-17\_q1\_set3.sql |
| Export | Export =245 ; =1XX; =240; =130, =250;  =series |

**Process**

Search each of the above sets on each bib format, using repeated passes as necessary. Within set and format, combine exported files and dedup on title strings; **do not dedup between set 1 and set 2, but – at least for monographs -- treat set 3 as follows:**

Dedup on title within set 3, note number of titles ; then append to corresponding set 1, dedup,  record resulting number.  \*Do not regularize data.

On spreadsheet, record the deduped number for Set1+3 as electronic, and for Set 2+3 as print.

Some formats require multiple passes per set + b3=d; files must be combined. Group files in discreet folders by directory. Combine the export text files within each set, and dedup using &quot;process.sh&quot;

Dedup the combined files:

Use Python script **ARL\_2011-12\_Q1\_deduponly.py** to dedupe the files and report line count. Script can be configured to output deduped files if desired.

[https://gist.github.com/3845821](https://gist.github.com/3845821)



Add figure for separately processed count of records with b3=&quot;d&quot;



The saved strategies include all formats; use in repeated passes, by format, delete other format lines.

| (1)Monograph | a, or t | AND (BIBLIOGRAPHIC  BCODE2  equal to  &quot;a&quot;        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;t&quot;) |
| --- | --- | --- |
| (2)Serial | S | _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;s&quot;_ |
| (3)Score | c-d | _OR BIBLIOGRAPHIC  BCODE2  between  &quot;c&quot;and &quot;d&quot;  _ |
| (4)Map | e-f | _OR BIBLIOGRAPHIC  BCODE2  between  &quot;e&quot;and &quot;f&quot;  _ |
| (5)Audio | i, j | _OR BIBLIOGRAPHIC  BCODE2  between  &quot;i&quot;and &quot;j&quot;  _ |
| (6)Projected | G | _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;g&quot;  _ |
| (7)2-D object | K | _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;k&quot;  _ |
| (8)E-Resource | m \*\* | _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;m&quot;_ |
| (9)Mixed | p | _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;p&quot;  _ |
| (10)Microform | h, v | _OR (BIBLIOGRAPHIC  BCODE2  equal to  &quot;h&quot;  _ _        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;v&quot;)  _ |

| INTERNET BIB LOCATIONS | INTERNET ITEM LOCATIONS |
| --- | --- |
| AND (BIBLIOGRAPHIC LOCATION HAS  &quot;in&quot;_i.e., (BIBLIOGRAPHIC  LOCATION  equal to  &quot;bcint&quot;  _ _OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;brint&quot;  _ _OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bhint&quot;  _ _OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bmint&quot;  _ _OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bolin&quot;  _ _OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buint&quot;)  _ | AND (AND  ITEM  LOCATION  has  &quot;in&quot;     OR CHECKIN  LOCATION  has  &quot;in&quot;)_i.e., LOCATION  equal to  &quot;cint&quot; __OR LOCATION  equal to &quot;rint&quot;__ OR LOCATION  equal to &quot;hint&quot; __OR LOCATION  equal to &quot;mint&quot;__ OR LOCATION equal to &quot;olink&quot;__OR LOCATION  equal to &quot;uint&quot;_ |

\*\* there are only 711 bibs with bcode 2 = &quot;m&quot; AND 006 fields for other format specific charactistics.  Run search for &quot;m&quot; as a separate pass rather than including in searches for monographs, serials, etc.  The chances of double counting a title are slim.

| **Set 1: Internet Resource (url, remote e-resource)** |
| --- |
| Search strategyspecifies | MARC tag 856 != &quot;&quot; OR MARC tag 956 != &quot;&quot;AND BIB LOC = Internet locations (attached item or ckin internet locations)AND BIB LOC = All fields don&#39;t have print locations |

| Include only Cataloged records     (based on CAT DATE), and exclude suppressed records | BIBLIOGRAPHIC  CAT DATE  not equal to  &quot;  -  -  &quot;   AND BIBLIOGRAPHIC  CAT DATE  less than or equal to  &quot;06-30-2012&quot;AND BIBLIOGRAPHIC  BCODE3  not equal to  &quot;d&quot;   AND BIBLIOGRAPHIC  BCODE3  not equal to  &quot;s&quot;   |
| --- | --- |
| Specify presence of url | AND (BIBLIOGRAPHIC  MARC Tag 856  not equal to  &quot;&quot;   OR BIBLIOGRAPHIC  MARC Tag 956  not equal to  &quot;&quot;) |
| Select format | AND (BIBLIOGRAPHIC  BCODE2  equal to  &quot;a&quot;        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;t&quot;)_OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;s&quot; __OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;m&quot;__ OR BIBLIOGRAPHIC  BCODE2  between  &quot;c&quot;and &quot;d&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  between  &quot;e&quot;and &quot;f&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  between  &quot;i&quot;and &quot;j&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;g&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;k&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;p&quot;  _ _OR (BIBLIOGRAPHIC  BCODE2  equal to  &quot;h&quot;  _ _        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;v&quot;)  _ |
| Specify item attached, and locations below | AND (BIBLIOGRAPHIC  LINKED REC  exists to  ITEM   OR BIBLIOGRAPHIC  LINKED REC  exists to  CHECKIN)   |
| Specify INTERNET Bib Location | AND (BIBLIOGRAPHIC LOCATION HAS  &quot;in&quot; |
|   | AND (BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;btest&quot; |
| Exclude non-Internet Bib Locations | AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bcler&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bdpst&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;brwc&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;buar&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;buas&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bucb&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bucl&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bucm&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bucr&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;buctl&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;buda&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;buel&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;buen&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bugp&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bula&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bhhsl&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bhner&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bhy&quot;AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bmlaw&quot;  |
| Exclude Affiliates | AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bbcrc&quot;   AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bacam&quot;   AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bamrc&quot;   AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bpint&quot;   AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bpra &quot;   AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;brub &quot;           AND BIBLIOGRAPHIC  LOCATION  not equal to    &quot;bvint&quot;   AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;bvll &quot;))   |
|   | AND (ITEM  LOCATION  has  &quot;in&quot;   OR CHECKIN  LOCATION  has  &quot;in&quot;) |
| AND ITEM  I TYPE  equal to &quot;99&quot; |



|   | **Set 2: Physical carrier, no Internet (no url)** |
| --- | --- |
| Search strategy | MARC tag 856 = &quot;[blank]&quot; AND MARC tag 956 = &quot;[blank]&quot;AND BIB LOC = ONLY Print locations, exclude Test and Affiliate locations |

| Include only Cataloged records     (based on CAT DATE), and exclude suppressed records | BIBLIOGRAPHIC  CAT DATE  not equal to  &quot;  -  -  &quot;   AND BIBLIOGRAPHIC  CAT DATE  less than or equal to  &quot;06-30-2012&quot;AND BIBLIOGRAPHIC  BCODE3  not equal to  &quot;d&quot;   AND BIBLIOGRAPHIC  BCODE3  not equal to  &quot;s&quot;   |
| --- | --- |
| Specify absence of url | AND (BIBLIOGRAPHIC  MARC Tag 856  equal to  &quot;&quot;  AND BIBLIOGRAPHIC  MARC Tag 956  equal to  &quot;&quot;) |
| Select format | AND (BIBLIOGRAPHIC  BCODE2  equal to  &quot;a&quot;        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;t&quot;)_OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;s&quot; __OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;m&quot;__ OR BIBLIOGRAPHIC  BCODE2  between  &quot;c&quot;and &quot;d&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  between  &quot;e&quot;and &quot;f&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  between  &quot;i&quot;and &quot;j&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;g&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;k&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;p&quot;  _ _OR (BIBLIOGRAPHIC  BCODE2  equal to  &quot;h&quot;  _ _        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;v&quot;)  _ |
| Specify item attached, and locations below | AND (BIBLIOGRAPHIC  LINKED REC  exists to  ITEM   OR BIBLIOGRAPHIC  LINKED REC  exists to  CHECKIN)   |
| Specify non-Internet locations | AND ((BIBLIOGRAPHIC  LOCATION  equal to  &quot;bcdrm&quot;  OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bcler&quot;  OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;brwc &quot;  OR BIBLIOGRAPHIC  LOCATION  starts with  &quot;bdp&quot;  OR BIBLIOGRAPHIC  LOCATION  starts with  &quot;bh&quot;  OR BIBLIOGRAPHIC  LOCATION  starts with  &quot;bm&quot;  OR BIBLIOGRAPHIC  LOCATION  starts with  &quot;bu&quot;)   |
| Exclude Internet locations | AND (BIBLIOGRAPHIC LOCATION All fields don&#39;t have  &quot;in&quot; |
| Exclude Affiliates | AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;btest&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bbcrc&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bacam&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bamrc&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bpint&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bpra &quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;brub &quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bvint&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bvll &quot;))   |
|  Specify item locations | AND (ITEM  LOCATION  starts with  &quot;c&quot;  OR CHECKIN  LOCATION  starts with  &quot;c&quot;  OR ITEM  LOCATION  starts with  &quot;h&quot;  OR CHECKIN  LOCATION  starts with  &quot;h&quot;  OR ITEM  LOCATION  starts with  &quot;m&quot;  OR CHECKIN  LOCATION  starts with  &quot;m&quot;  OR ITEM  LOCATION  starts with  &quot;r&quot;  OR CHECKIN  LOCATION  starts with  &quot;r&quot;  OR ITEM  LOCATION  starts with  &quot;tdp&quot;  OR ITEM  LOCATION  between  &quot;u&quot;and &quot;v&quot;  OR CHECKIN  LOCATION  between  &quot;u&quot;and &quot;v&quot;) |

|   | **Set 3 Physical carrier (e.g., print) AND Internet Resource** |
| --- | --- |
| Search strategy | MARC tag 856 != &quot;&quot; OR MARC tag 956 != &quot;&quot;AND BIB LOC = Includes both Internet and non-InternetAND Item and checkin include both |

| Include only Cataloged records     (based on CAT DATE), and exclude suppressed records | BIBLIOGRAPHIC  CAT DATE  not equal to  &quot;  -  -  &quot;   AND BIBLIOGRAPHIC  CAT DATE  less than or equal to  &quot;06-30-2012&quot;AND BIBLIOGRAPHIC  BCODE3  not equal to  &quot;d&quot;   AND BIBLIOGRAPHIC  BCODE3  not equal to  &quot;s&quot;   |
| --- | --- |
| Specify absence of url | AND (BIBLIOGRAPHIC  MARC Tag 856  not equal to  &quot;&quot;  or BIBLIOGRAPHIC  MARC Tag 956  not equal to  &quot;&quot;) |
| Select format | AND (BIBLIOGRAPHIC  BCODE2  equal to  &quot;a&quot;        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;t&quot;)_OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;s&quot; __OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;m&quot;__ OR BIBLIOGRAPHIC  BCODE2  between  &quot;c&quot;and &quot;d&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  between  &quot;e&quot;and &quot;f&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  between  &quot;i&quot;and &quot;j&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;g&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;k&quot;  _ _OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;p&quot;  _ _OR (BIBLIOGRAPHIC  BCODE2  equal to  &quot;h&quot;  _ _        OR BIBLIOGRAPHIC  BCODE2  equal to  &quot;v&quot;)  _ |
| Specify item attached, and locations below | AND (BIBLIOGRAPHIC  LINKED REC  exists to  ITEM   OR BIBLIOGRAPHIC  LINKED REC  exists to  CHECKIN)   |
| Specify Bib Locations | AND ((BIBLIOGRAPHIC  LOCATION  equal to  &quot;bcdrm&quot;  OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bcler&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bdpst&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;brwc&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buar&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buas&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bucb&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bucl&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bucm&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bucr&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buctl&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buda&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buel&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;buen&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bugp&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bula&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bhhsl&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bhner&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bhy&quot;OR BIBLIOGRAPHIC  LOCATION  equal to  &quot;bmlaw&quot; |
| Include Internet locations | AND (BIBLIOGRAPHIC LOCATION  has   &quot;in&quot; |
| Exclude Affiliates | AND BIBLIOGRAPHIC  LOCATION  All Fields don&#39;t have  &quot;btest&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bbcrc&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bacam&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bamrc&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bpint&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bpra &quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;brub &quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bvint&quot;  AND BIBLIOGRAPHIC  LOCATION  not equal to  &quot;bvll &quot;))   |
|  Specify item locations | AND (ITEM  LOCATION  starts with  &quot;c&quot;  OR CHECKIN  LOCATION  starts with  &quot;c&quot;  OR ITEM  LOCATION  starts with  &quot;h&quot;  OR CHECKIN  LOCATION  starts with  &quot;h&quot;  OR ITEM  LOCATION  starts with  &quot;m&quot;  OR CHECKIN  LOCATION  starts with  &quot;m&quot;  OR ITEM  LOCATION  starts with  &quot;r&quot;  OR CHECKIN  LOCATION  starts with  &quot;r&quot;  OR ITEM  LOCATION  starts with  &quot;tdp&quot;  OR ITEM  LOCATION  equal to  &quot;olink&quot;   OR CHECKIN  LOCATION  equal to  &quot;olink&quot;   OR ITEM  LOCATION  between  &quot;u&quot;and &quot;v&quot;  OR CHECKIN  LOCATION  between  &quot;u&quot;and &quot;v&quot;) |

compile on sheet in ARL Excel Workbook, transfer data to table below after dedup:

| b2=a,t |   | 1st pass   |   |   | 500,000 |   |
| --- | --- | --- | --- | --- | --- | --- |
|   |   | 2nd pass |   |   | 500,000 |   |
|   |   | 3rd pass   |   |   | 500,000 |   |
|   |   | 4th pass   |   |   | 500,000 |   |
|   |   | 5th pass   |   |   |   |   |
|   |   |   |   | total |
| b2=c-d |   | 1st pass |   |   |   |   |
|   |   |   |   | total |
| b2=s |   | 1st pass |   |   |   |   |
|   |   |   |   | total |
| b2=m | b1=c | monographic |   |   |
|   |   | serial |   |   |
|   | b1=i | monographic |   |   |
|   |   | serial |   |   |
|   | b1=m |   |   |   |
|   | b1=s |   |   |   |
|   |   |   |   | total |
|   |   |   |   | total |
|   |   | ProQuest these identified as dup titles |   | -7123  (check if still accurate number) |
|   |   |   |   | grand total |