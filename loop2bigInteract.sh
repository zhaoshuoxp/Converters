#!/bin/bash
#####################################
# check dependences
which bedToBigBed &>/dev/null || { echo "bedToBigBed not found! Download http://hgdownload.soe.ucsc.edu/admin/exe"; exit 1; }
which sortBed &>/dev/null || { echo "bedtools not found!"; exit 1; }

hg38.size='https://hgdownload-test.gi.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes'
hg19.size='http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/hg19.chrom.sizes'
wget https://genome.ucsc.edu/goldenPath/help/examples/interact/interact.as

# help message
help(){
	cat <<-EOF
    Usage: loop2bigInteract.sh -h | [-f -r <res>] <input file>

    ### INPUT: FitHiC or HiCCUPS output files ###
    All results will be store in current (./) directory.
    ### bedToBigBed/sortBed required ###

    Options:
        -f input is FitHiC
        -p input is FitHiChIP
        -r [int] resolution of FitHiC/FitHiChIP
        -c input is HiCCUPs
        -h Print this help message
EOF
	exit 0
}

fithic(){
    # resolution
    res=$3/2
    # set q value as color depth
    # convert FitHiC output to interact BED5+13 format
    awk -v OFS="\t" '{print $1,$2-'$res',$2+'$res',".",$5,-log($7),".", "0",$3,$4-'$res',$4+'$res',".",".", $1,$2-'$res',$2+'$res',".","."}' $1 > ${2}.temp
    # get max -log(q_value), in case of q_value=0
    max_q=$(awk 'BEGIN {max = 0} {if ($6!="inf" && $6+0> max) max=$6} END {print max}' ${2}.temp)
    # replace "inf" to max -log(q_value)
    awk -v OFS="\t" '{if ($6=="inf")$6='$max_q'}1' ${2}.temp |awk -v OFS="\t" '{if ($5>1000)$5=1000}1' > ${2}.temp2

}

fithic2longrange(){
    res=$2/2
    # convert FitHiC output to WashU longrange format
    awk -v OFS="," -F"\t" '{print $1"\t"$2-'$res'"\t"$2+'$res'"\t"$3":"$4-'$res'"-"$4+'$res',-log($7)"\n"$3"\t"$4-'$res'"\t"$4+'$res'"\t"$1":"$2-'$res'"-"$2+'$res',-log($7)}' $1 > $1.temp
    # get max -log(q_value), in case of q_value=0
    max_q=$(awk -F"," 'BEGIN {max = 0} {if ($2+0> max) max=$2} END {print max}' $1.temp)
    # replace "inf" to max -log(q_value)
    awk -v OFS="\t" -F"," '{if ($2=="inf"){print $1,'$max_q'}else{print $0}}' $1.temp > $(basename $1 .txt).longrange
    # sort file
    sortBed -i $(basename $1 .txt).longrange > $(basename $1 .txt).lr
    # bgzip compress and index
    bgzip $(basename $1 .txt).lr
    tabix -p bed $(basename $1 .txt).lr.gz
    # clean
    rm $1.temp $(basename $1 .txt).longrange
}

hiccups(){
    # convert HiCCUPS output to interact BED5+13 format
    grep -v ^# $1|sed 's/chr//g' | awk -v OFS="\t" '{print "chr"$1,$2,$3,$7,int($12),-log($17),".", "0","chr"$4,$5,$6,".",".", "chr"$1,$22,$23,".","."}' > ${2}.temp
    max_q=$(awk 'BEGIN {max = 0} {if ($6!="inf" && $6+0> max) max=$6} END {print max}' ${2}.temp)
    # replace "inf" to max -log(q_value)
    awk -v OFS="\t" '{if ($6=="inf")$6='$max_q'}1' ${2}.temp |awk -v OFS="\t" '{if ($5>1000)$5=1000}1' > ${2}.temp2
}

fithichip(){
    # convert FitHiChIP output to interact BED5+13 format
    sed '1d' $1| awk -v OFS="\t" '{print $1,$2,$3,".",int($7),-log($24),".", "0",$4,$5,$6,".",".", $1,$2,$6,".","."}' > ${2}.temp
    max_q=$(awk 'BEGIN {max = 0} {if ($6!="inf" && $6+0> max) max=$6} END {print max}' ${2}.temp)
    # replace "inf" to max -log(q_value)
    awk -v OFS="\t" '{if ($6=="inf")$6='$max_q'}1' ${2}.temp |awk -v OFS="\t" '{if ($5>1000)$5=1000}1' > ${2}.temp2
}

main(){

    if [ $1 == 'fithic' ];then
        name=$(basename $2 .txt)
        fithic $2 $name $3
    elif [ $1 == 'hiccups' ];then
        name=$(basename $2 .bedpe)
        hiccups $2 $name
    elif [ $1 == 'fithichip' ];then
        name=$(basename $2 .bed)
        fithichip $2 $name
    else
        echo "Must choose a input type: fithic[-f], fithichip[-p] or hiccups[-c]!"
        help
        exit 1
    fi
    
    # sort
    sortBed -i ${name}.temp2 > ${name}.temp3
    curl -s $hg38.size  > chromsize
    # convert interact to biginteract
    bedToBigBed -as=interact.as -type=bed5+13 ${name}.temp3 chromsize ${name}.bb
       
    # clean
    rm ${name}.temp ${name}.temp2 ${name}.temp3 
    rm interact.as chromsize 
}

if [ $# -lt 1 ];then
    help
    exit 1
fi

while getopts "cfpr:h" arg
do
    case $arg in
        c) mod='hiccups';;
        f) mod='fithic';;
        p) mod='fithichip';;
        r) res=$OPTARG;;
        h) help ;;
        ?) help
            exit 1;;
    esac
done
shift $(($OPTIND - 1))

main $mod $1 $res

# check running status
if [ $? -ne 0 ]; then
    help
    exit 1
else
    echo "Run succeed"
fi

################ END ################
#          Created by Aone          #
#     quanyi.zhao@stanford.edu      #
################ END ################