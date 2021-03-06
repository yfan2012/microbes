#!/bin/bash

srcdir=~/Code/microbes/final/scripts
datadir=~/scratch/class/microbes/final
maxfiles=`wc -l $datadir/forward.txt | cut -d ' ' -f 1`

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


contigs=/scratch/groups/mschatz1/cpowgs/meta/contigs/contigs.fasta

##prodigal
##run regularly on the bigmem. Could try to distribute if too slow. 
if [ $1 == prodigal ] ; then
    outdir=/scratch/groups/mschatz1/cpowgs/meta
    ~/work2/FA17_Methods_dir/lib/Prodigal-2.6.3/prodigal -i $contigs -o $outdir/all_genes.fasta -a $outdir/all_protiens.faa -p meta
fi


if [ $1 == align ] ; then
    mkdir -p $datadir/align
    mkdir -p $datadir/align/index
    mkdir -p $datadir/out_logs/align

    sbatch --output=$datadir/out_logs/align/align.%A_%a.out --array=1-$maxfiles $srcdir/align.scr
fi    


if [ $1 == index ] ; then
    mkdir -p $datadir/align/index
    bowtie2-build --threads 30 $contigs $datadir/align/index/all_meta_samps
fi


if [ $1 == split ] ; then
    ##checked that prot file is 400ish MB, so need to split into 2
    perl ~/work2/FA17_Methods_dir/bin/split_fasta.pl /scratch/groups/mschatz1/cpowgs/meta/all_protiens.faa 2
fi


if [ $1 == kegglim ] ; then
    perl ~/work2/FA17_Methods_dir/bin/bin/temp_112117.pl $datadir/ghost/nitrogen_keggids.txt $datadir/ghost/ghost1.txt > $datadir/ghost/key_prots1.txt
    perl ~/work2/FA17_Methods_dir/bin/bin/temp_112117.pl $datadir/ghost/nitrogen_keggids.txt $datadir/ghost/ghost2.txt > $datadir/ghost/key_prots2.txt

    cat $datadir/ghost/key_prots* > $datadir/ghost/all_key_prots.txt
    
    for i in $datadir/align/*.bed ;
    do
	prefix=`echo ${i#.bed} | rev | cut -d '/' -f 1 | rev`
	perl ~/work2/FA17_Methods_dir/bin/bin/temp_052317_2.pl $i $datadir/ghost/all_protiens.faa $datadir/ghost/all_key_prots.txt > $datadir/ghost/$prefix.key_protein_read_map.txt
    done
fi


if [ $1 == table ] ; then
    rawdir=~/work2/FA17_Methods_dir/class_raw_data/sprehei1_132645_HISEQ_Mystic_Aug
    
    ls $datadir/ghost/*key_protein_read_map.txt > $datadir/ghost/list.txt
    perl ~/work2/FA17_Methods_dir/bin/bin/temp_052317_3.pl $rawdir/readcount_file_list.txt $datadir/ghost/list.txt $rawdir/primer_sample_pairs.csv > $datadir/ghost/key_protein_table.tab

    perl ~/work2/FA17_Methods_dir/bin/bin/temp_052417.pl $datadir/ghost/key_protein_table.tab > $datadir/KEGG_summary_table.tab
fi
