#!/bin/bash

#create bed from bam, requires bedtools bamToBed
bamToBed -i $1 -split > accepted_hits.bed

curl -s ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/chromInfo.txt.gz | gunzip -c > hg19_len

#create plus and minus strand bedgraph
cat accepted_hits.bed | sort -k1,1 | bedItemOverlapCount hg19 -chromSize=hg19_len stdin | sort -k1,1 -k2,2n > accepted_hits.bedGraph

bedGraphToBigWig accepted_hits.bedGraph hg19_len $1.bw

#removing intermediery files
rm accepted_hits.bed hg19_len
rm accepted_hits.bedGraph