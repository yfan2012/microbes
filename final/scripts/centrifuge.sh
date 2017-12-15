#!/bin/bash

dbdir=~/scratch/centrifuge_db
srcdir=~/scratch/centrifuge

if [ $1 == download ] ; then
    ##Download taxonomy and stuff
    ##Note: ran this from the command line in the right folder. Not sure if there are bugs in these two lines.
    $srcdir/centrifuge-download -o $dbdir/taxonomy taxonomy
    $srcdir/centrifuge-download -o $dbdir/library -m -d "archaea,bacteria,viral" refseq > $dbdir/seqid2taxid.map
fi

if [ $1 == cat ] ; then
    cat $dbdir/library/*/*.fna > $dbdir/input-sequences.fna
fi

if [ $1 == build ] ; then
    ##on bigmem

    $srcdir/centrifuge-build -p 30 --conversion-table $dbdir/seqid2taxid.map \
		     --taxonomy-tree $dbdir/taxonomy/nodes.dmp --name-table $dbdir/taxonomy/names.dmp \
		     $dbdir/input-sequences.fna $dbdir/abv
fi


if [ $1 == query ] ; then
    ##on bigmem

    datadir=~/scratch/class/microbes/final
    mkdir -p $datadir/classification

    while read set ; do
	prefix=`echo $set | cut -d '_' -f 1`
	if [ ! -f $datadir/trimmed/${prefix}_unpaired.fastq ] ; then
	    cat $datadir/trimmed/${prefix}_1.fastq_s1_se $datadir/trimmed/${prefix}_2.fastq_s2_se > $datadir/trimmed/${prefix}_unpaired.fastq
	fi

	$srcdir/centrifuge -x $dbdir/abv -1 $datadir/trimmed/${prefix}_1.fastq_s1_pe -2 $datadir/trimmed/${prefix}_2.fastq_s2_pe -U $datadir/trimmed/${prefix}_unpaired.fastq -S $datadir/classification/$prefix.txt --report-file $datadir/classification/${prefix}_report.tsv
	
    done <$datadir/forward.txt
fi


if [ $1 == report ] ; then
    datadir=~/scratch/class/microbes/final
    while read set ; do
	prefix=`echo $set | cut -d '_' -f 1`
	$srcdir/centrifuge-kreport -x $dbdir/abv $datadir/classification/$prefix.txt > $datadir/kreport_$prefix.txt
    done < $datadir/forward.txt
fi
