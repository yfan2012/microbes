#!/bin/sh
#
#SBATCH
#SBATCH --job-name=mapping
#SBATCH --time=100:00:00
#SBATCH --nodes=1

module load bedtools/2.19.1
module load samtools/1.3.1
module load bowtie2/2.2.5

file1=`awk "NR==$SLURM_ARRAY_TASK_ID" first.files`
file2=`awk "NR==$SLURM_ARRAY_TASK_ID" second.files`

echo "Starting bowtie; Timestamp"
date
bowtie2 --threads 1 -x MAPPING/contigs -1 $file1 -2 $file2 -S MAPPING/${file1}.sam
echo "Finished bowtie; timestamp"
date
echo "Starting samtools and bedtools; Timestamp"
date
samtools view -F 4 -bS ${file1}.sam > ${file1}.bam
bedtools bamtobed -i ${file1}.bam > ${file1}.bed
echo "Finished; $SLURM_ARRAY_TASK_ID $file1 timestamp"
date
