#!/bin/bash

##########################################################################################################
#
# Can fetch sequence from NCBI in FASTA format/ input should be in bed format
#		OR143135	1111	2286
#		OR143134	1111	2286
#		OR143158	1070	2245
#
######################################################################################################





# blast input and check proper input

if (( $# < 1 )); then
     
     echo "Uses : blast.sh input"
    
    exit 1

else
    echo "Give me the datbase name"

fi



read -p "Choose the BLAST DB (NCBI or other): " name
read -p "Choose the BLAST type (full or short): " blast_type

if [[ $name == "NCBI" &&  $blast_type == "full" ]];

then

blastn -task blastn-short -word_size 7 -evalue 1000 -gapopen 10 -gapextend 2 -dust no -soft_masking false -out $1.blast -query $1 -db ~/bin/blastdb/db/virus_all -max_target_seqs 10 -perc_identity 60 -qcov_hsp_perc 90

elif [[ $name == "NCBI" &&  $blast_type == "short" ]];

then

blastn -task blastn-short -word_size 7 -evalue 1000 -gapopen 10 -gapextend 2 -dust no -soft_masking false -out $1.blast -query $1 -db ~/bin/blastdb/db/virus_all -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids"

elif [[ $name == "other" &&  $blast_type == "full" ]];

then

blastn -task blastn-short -word_size 7 -evalue 1000 -gapopen 10 -gapextend 2 -dust no -soft_masking false -out $1.blast -query $1 -db ~/bin/blastdb/db/virushostdb -max_target_seqs 10 -perc_identity 60 -qcov_hsp_perc 90

else

blastn -task blastn-short -word_size 7 -evalue 1000 -gapopen 10 -gapextend 2 -dust no -soft_masking false -out $1.blast -query $1 -db ~/bin/blastdb/db/virushostdb -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids"


fi


