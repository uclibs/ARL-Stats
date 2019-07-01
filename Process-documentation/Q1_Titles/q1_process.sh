#!/bin/bash
for f in *csv
do wc -l "$f"
done

#change this value for the correct dates and question
outfile=${PWD##*/}_14_15_q1_count.txt
printf '%s' $outfile
echo

set1=$(LC_ALL=C sort -i -u q1_set1* | wc -l)
echo "$set1 : set1 deduped" > $outfile

set13=$(LC_ALL=C sort -i -u q1_set1* q1_set3* | wc -l)
echo "$set13 : set1+set3 deduped" > $outfile

set2=$(LC_ALL=C sort -i -u q1_set2* | wc -l)
echo "$set2 : set2 deduped" > $outfile

set3=$(LC_ALL=C sort -i -u q1_set3* | wc -l)
echo "$set3 : set3 deduped" > $outfile