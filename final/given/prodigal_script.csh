#!/bin/sh
#
#SBATCH
#SBATCH --job-name=prodigal
#SBATCH --time=100:00:00
#SBATCH --nodes=1

$CONTIGS=./ChesapeakeContigs/contigs.fa
$ODIR=./ChesapeakeContigs

echo "Timestamp"
date
echo "Starting prodigal"
~/work/FA17_Methods_dir/lib/Prodigal-2.6.3/prodigal -i $CONTIGS -o ${ODIR}/all_genes.fa -a ${ODIR}/all_proteins.faa -p meta
echo "Finished prodigal; timestamp"
date
