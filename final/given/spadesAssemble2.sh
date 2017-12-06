#!/bin/bash -l

#SBATCH

#SBATCH --job-name=SPDS_assemble2
#SBATCH --time=48:00:00
#SBATCH --ntasks=48
#SBATCH --cpus-per-task=1
#SBATCH --partition=lrgmem
#SBATCH --error=SPDS_assemble2.err
#SBATCH --output=SPDS_assemble2.out

module load python/2.7.10
module load zlib/1.2.8

SPADES=~/work/FA17_Methods_dir/lib/SPAdes-3.9.0-Linux/bin/spades.py
FWD_FQ=./Trimmed_Chesapeake/all_s1_pe.fastq
REV_FQ=./Trimmed_Chesapeake/all_s2_pe.fastq
OUT_DIR=ChesapeakeContigs

free -mh
getconf _NPROCESSORS_ONLN

$SPADES --meta -1 $FWD_FQ -2 $REV_FQ -o $OUT_DIR --threads 48 --memory 950

