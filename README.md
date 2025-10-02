# Format Converters
-----
This repository has the following combined shell/awk/python scripts which can be used for format converting with common high-throughput sequencing data.

 * [bam2bigwig.sh](https://github.com/zhaoshuoxp/Converters#bam2bigwigsh): BAM to bigWig for genome browser visualization.
 * [BedGraph2bigwig.sh](https://github.com/zhaoshuoxp/Converters#bedgraph2bigwigsh): BedGraph(output of MACS2) to bigWig for genome browser visualization.
 * [loop2bigInteract.sh](https://github.com/zhaoshuoxp/Converters#loop2biginteractsh): FitHiC and HiCCUPs output to bigInteract format for WashU Epigenome Browser visualization.
 * [HiCpro2Juicebox.sh](https://github.com/zhaoshuoxp/Converters#hicpro2juiceboxsh): HiCPro output to Juicebox for HiC/HiChIP interaction visualization.
 * [GTF_rmdup.sh](https://github.com/zhaoshuoxp/Converters#gtf_rmdupsh): deduplicate transcripts in GTF format.
 * [rmdup_rdm.sh](https://github.com/zhaoshuoxp/Converters#rmdup_rdmsh): deduplicate alignments RANDOMLY by picard in BAM format.
 * [mus2hum.R](https://github.com/zhaoshuoxp/Converters#mus2humr): convert mouse gene symbols to human by homological search.


> Requirements:
> awk, python3, bedtools, picard.jar, bgzip, tabix, [UCSC Genome Browser utility](http://hgdownload.soe.ucsc.edu/admin/exe/):bedGraphToBigWig, bedItemOverlapCount, gtfToGenePred, genePredToBed, bedClip, bedToBigBed, R, biomaRt.

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

  

----

## loop2bigInteract.sh

This script converts FitHiC or HiCCUPS output to bigInteract format for Genome Browser visualization. q value (FitHiC) and raw reads counts (HiCCUPs) will be used for color depth.

####Input

FitHiC output (q value filtered), i.e all_10k_2m.spline_pass2.significants.txt

HiCCUPs output, i.e. merged_loops.bedpe 

#### Options

help message can be shown by `loop2bigInteract.sh -h`

    Usage: loop2bigInteract.sh -h | [-f -r <res>] <input file>
    
    ### INPUT: FitHiC or HiCCUPS output files ###
    All results will be store in current (./) directory.
    ### bedToBigBed/sortBed required ###
    
      Options:
        -f input is FitHiC
        -r [int] resolution of FitHiC
        -c input is HiCCUPs
        -h Print this help message

#### Example

```shell
# FitHiC output
loop2bigInteract.sh -f -r 5000 all_10k_2m.spline_pass2.significants.txt
# HiCCUPS output
loop2bigInteract.sh -c merged_loops.bedpe 
```

#### Output

* bigInteract file (.bb) with prefix kept will be stored in the current directory.

  

------

## HiCpro2Juicebox.sh

This script comes from [HiCPro](https://github.com/nservant/HiC-Pro/blob/master/bin/utils/hicpro2juicebox.sh).
#### Usage

    ./HiCpro2Juicebox.sh -i test.allValidPairs -g hg19 -j /path/to/juicer_tools.jar
> -r|--resfrag somehow doesn't work. See [more](http://nservant.github.io/HiC-Pro/UTILS.html#hicpro2juicebox-sh).
#### Output

* .hic file

  

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

## mus2hum.R

This script converts mouse gene symbols to human by homological search. R and biomaRt are required.

#### Usage

    ./mus2hum.R input.txt

#### Input

Text file of mouse gene symbols, a gene per row at first column.

#### Output

input2hum.txt. The homolog human gene symbols are added to the beginning of each row.



-----

Author [@zhaoshuoxp](https://github.com/zhaoshuoxp)  
Nov 7 2023

