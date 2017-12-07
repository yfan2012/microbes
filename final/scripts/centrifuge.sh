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
