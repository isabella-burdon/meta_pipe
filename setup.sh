#!/bin/bash

# grant execute permissions for bash scripts
chmod +x concatenate_fastq.sh
chmod +x run_files/run_chopper.sh
chmod +x run_files/run_sourmash.sh

# download dependencies
pip install scipy pandas pyarrow matplotlib nanoQC --upgrade bokeh

# create necessary environments
mamba create -y -c bioconda -n minimap2 minimap2 python
mamba create -y -c bioconda -n chopper chopper python
mamba create -n smash -y -c conda-forge -c bioconda sourmash parallel python

# set up database for sourmash
mamba activate smash
cd genome_db
wget https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214-k31.zip
sourmash sig summarize gtdb-rs214-k31.zip
wget https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs214/gtdb-rs214.lineages.csv.gz
gunzip gtdb-rs214.lineages.csv.gz
sourmash tax prepare -t gtdb-rs214.lineages.csv \
        -o gtdb-rs214.taxonomy.sqldb -F sql
cd .. 
mamba deactivate