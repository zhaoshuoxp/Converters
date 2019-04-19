# Format Converters
-----
This repository has the following combined shell/awk/python scripts which can be used for format converting with common high-throughput sequencing data.

 * [bam2bigwig.sh](https://github.com/zhaoshuoxp/Converters#bam2bigwigsh): BAM to bigWig for genome browser visualization.
 * [BedGraph2bigwig.sh](https://github.com/zhaoshuoxp/Converters#bedgraph2bigwigsh): BedGraph(output of MACS2) to bigWig for genome browser visualization.
 * [dblnks_cvt.py](https://github.com/zhaoshuoxp/Converters#dblnks_cvtpy): a python script converting dopbox links to public.
 * [FitHiC2bigInteract.sh](https://github.com/zhaoshuoxp/Converters#fithic2biginteractsh): FitHiC output to bigInteract (binary) for WashU Epigenome Browser visualization.
 * [FitHiC2longrange.sh](https://github.com/zhaoshuoxp/Converters#fithic2longrangesh): FitHiC output to longrange (text) for WashU Epigenome Browser visualization.
 * [HiCpro2Juicebox.sh](https://github.com/zhaoshuoxp/Converters#hicpro2juiceboxsh): HiCPro output to Juicebox for HiC/HiChIP interaction visualization.
 * [GTF_rmdup.sh](https://github.com/zhaoshuoxp/Converters#gtf_rmdupsh): deduplicate transcripts in GTF format.
 * [rmdup_rdm.sh](https://github.com/zhaoshuoxp/Converters#rmdup_rdmsh): deduplicate alignments RANDOMLY by picard in BAM format.


> Requirements:
> awk, python3, bedtools, picard.jar, bgzip, tabix, [UCSC Genome Browser utility](http://hgdownload.soe.ucsc.edu/admin/exe/):bedGraphToBigWig, bedItemOverlapCount, gtfToGenePred, genePredToBed, bedClip, bedToBigBed.

[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu) [![LICENSE](https://img.shields.io/badge/license-Anti%20996-blue.svg)](https://github.com/996icu/996.ICU/blob/master/LICENSE)

-----

## bam2bigwig.sh

This script is separated from ChIPseq.sh

#### Usage

    ./bam2bigwig.sh input.bam 

#### Output

* input.bw

  

-----
## BedGraph2bigwig.sh
This script is from [macs2](https://gist.github.com/taoliu/2469050)
#### Usage

    ./BedGraph2bigwig.sh input.bam hg19_len

hg19_len can be download by:

    curl -s ftp://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/chromInfo.txt.gz | gunzip -c > hg19_len

#### Output

* input.bw

  

------
## dblnks_cvt.py
This script convert dropbox shared links to public so that it can be loaded by UCSC Genome browser.
#### Usage

    ./dblnks_cvt.py https://www.dropbox.com/s/id3ixx4beodi4jo/pooled_TCF21_filtered.bw?dl=0

#### Output

    https://dl.dropboxusercontent.com/s/id3ixx4beodi4jo/pooled_TCF21_filtered.bw



----

## FitHiC2bigInteract.sh

#### Usage

    ./FitHiC2bigInteract.sh fithic_out.txt <res, i.e. 5000> <p, optional, use P value instead of Q value for coloring> 

#### Output

* fithic_out.bb

  

------

## FitHiC2longrange.sh

#### Usage

    ./FitHiC2longrange.sh fithic_out.txt <res, i.e. 5000> <p, optional, use P value instead of Q value for coloring> 

#### Output

* fithic_out.longrange

  

------

## HiCpro2Juicebox.sh
This script comes from [HiCPro](https://github.com/nservant/HiC-Pro/blob/master/bin/utils/hicpro2juicebox.sh).
#### Usage

    ./HiCpro2Juicebox.sh -i test.allValidPairs -g hg19 -j /path/to/juicer_tools.jar
> -r|--resfrag somehow doesn't work. See [more](http://nservant.github.io/HiC-Pro/UTILS.html#hicpro2juicebox-sh).
#### Output

* test.hic

  

-----
## GTF_rmdup.sh
This script removes transcript duplicates by converting to BED12 and sorting by column1,2,3,11,12. 
#### Usage

    ./GTF_rmdup.sh input.gtf

#### Output

* input_uniq.gtf

  

-----
## rmdup_rdm.sh
This script removes alignment duplicates RANDOMLY (no SNP bias) by picard.jar. BAM file has to be sorted.
#### Usage

    ./rmdup_rdm.sh sort.bam sort_rm.bam

#### Output

* sort_rm.bam

  

-----

Author [@zhaoshuoxp](https://github.com/zhaoshuoxp)  
Mar 27 2019  

