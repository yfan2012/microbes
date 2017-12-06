#!/bin/bash


datadir=~/scratch/class/microbes/final
dbdir=$datadir/db
srcdir=~/Code/microbes/final/scripts

if [ $1 == db ]; then
    ml blast/2.2.30
    ml ncbi-blast/2.2.26

    mkdir -p $dbdir
    cat $datadir/ref_genes/*narG* > $dbdir/all_narG.fasta
    sed -i -e 's/\n\n/\n/g' $dbdir/all_narG.fasta
    
    makeblastdb -in $dbdir/all_narG.fasta -out $dbdir/narGdb -dbtype nucl
fi


if [ $1 == query ] ; then
    mkdir -p $datadir/out_logs/blast
    mkdir -p $datadir/blast
    mkdir -p $datadir/fastas
    maxfiles=`wc -l $datadir/forward.txt | cut -d ' ' -f 1`
    sbatch --output=$datadir/out_logs/blast/blast.%A_%a.out --array=1-$maxfiles $srcdir/blast_query.scr
fi


if [ $1 == readdb ] ; then
    mkdir -p $datadir/out_logs/readdb
    mkdir -p $datadir/readdb
    mkdir -p $datadir/fastas
    maxfiles=`wc -l $datadir/forward.txt | cut -d ' ' -f 1`
    sbatch --output=$datadir/out_logs/readdb/makedb.%A_%a.out --array-1-$maxfiles $srcdir/readdb.scr
fi

