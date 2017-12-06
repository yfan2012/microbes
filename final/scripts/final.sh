#!/bin/bash

srcdir=~/Code/microbes/final/scripts
datadir=~/scratch/class/microbes/final

##symlink stuff
if [ $1 == link ] ; then
    mkdir -p $datadir/data
    rm $datadir/data/*.fastq
    python $srcdir/link_data.py
fi

##trim
if [ $1 == trim ] ; then
    mkdir -p $datadir/out_logs/trim
    mkdir -p $datadir/trimmed
    maxfiles=`wc -l $datadir/forward.txt | cut -d ' ' -f 1`
    sbatch --output=$datadir/out_logs/trim/trim.%A_%a.out --array=1-$maxfiles $srcdir/trimmer.scr
fi


##cat
if [ $1 == cat ] ; then
    cat $datadir/trimmed/*s1_pe > $datadir/trimmed/all_s1_pe.fastq &
    cat $datadir/trimmed/*s2_pe > $datadir/trimmed/all_s2_pe.fastq &
    cat $datadir/trimmed/*_se > $datadir/trimmed/all_se.fastq
fi


##assemble
if [ $1 == assemble ] ; then
    mkdir -p $datadir/out_logs/assemble
    mkdir -p $datadir/contigs
    sbatch --output=$datadir/out_logs/assemble/assemble.out --error=$datadir/out_logs/assemble/assemble.err $srcdir/assemble.scr
fi

##prodigal
##run regularly on the bigmem. Could try to distribute if too slow. 
if [ $1 == prodigal ] ; then
    contigs=/scratch/groups/mschatz1/cpowgs/meta/contigs/contigs.fasta
    outdir=/scratch/groups/mschatz1/cpowgs/meta
    ~/work2/FA17_Methods_dir/lib/Prodigal-2.6.3/prodigal -i $contigs -o $outdir/all_genes.fasta -a $outdir/all_protiens.faa -p meta
fi
