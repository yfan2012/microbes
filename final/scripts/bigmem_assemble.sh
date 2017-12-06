#!/bin/bash

module load python/2.7.10
module load zlib/1.2.8

datadir=/scratch/groups/mschatz1/cpowgs/meta
SPADES=~/work2/FA17_Methods_dir/lib/SPAdes-3.9.0-Linux/bin/spades.py
FWD_FQ=$datadir/all_s1_pe.fastq
REV_FQ=$datadir/all_s2_pe.fastq
SE_FQ=$datadir/all_se.fastq
OUT_DIR=$datadir/contigs

mkdir -p $OUT_DIR

$SPADES --meta -1 $FWD_FQ -2 $REV_FQ -s $SE_FQ -o $OUT_DIR --threads 72 --memory 500
