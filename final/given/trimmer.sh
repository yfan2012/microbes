#!/bin/bash -l

#SBATCH

#SBATCH --job-name=trim_test
#SBATCH --time=4:00:00
#SBATCH --partition=parallel

EX_LOC=/home-4/t-sprehei1@jhu.edu/work/FA17_Methods_dir/lib/Trimmomatic-0.36/trimmomatic-0.36.jar
AD_LOC=/home-4/t-sprehei1@jhu.edu/work/FA17_Methods_dir/lib/Trimmomatic-0.36/adapters/NexteraPE-PE.fa
LIB_DIR=./Chesapeake_Bay/

ASSEM=./Trimmed_Chesapeake
FWD_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" forward`
REV_FQ=`awk "NR==$SLURM_ARRAY_TASK_ID" reverse`

java -jar $EX_LOC PE -threads 8 -phred33 \
$LIB_DIR/$FWD_FQ  $LIB_DIR/$REV_FQ \
$ASSEM/${FWD_FQ}_s1_pe $ASSEM/${FWD_FQ}_s1_se $ASSEM/${REV_FQ}_s2_pe $ASSEM/${REV_FQ}_s2_se \
ILLUMINACLIP:$AD_LOC:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:33 MINLEN:50

