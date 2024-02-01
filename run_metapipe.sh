#!/bin/bash

echo "Welcome to meta-pipe"

read -p "Is this your first time running meta-pipe? [y/n] " first_time

if [[ $first_time == "y" || $first_time == "Y" ]]; then
    read -p "Do you want to set up now (includes downloading software and GTDB)? [y/n] " setup_now
    if [[ $setup_now == "y" || $setup_now == "Y" ]]; then
        ./setup.sh
    else
        echo "Running meta-pipe now..."
    fi
else
    echo "Running meta-pipe now..."
fi

read -p "Are the raw fastq files in the directory 'a_rawReads'? [y/n] " raw_reads_location

if [[ $raw_reads_location == "y" || $raw_reads_location == "Y" ]]; then
    # PREPARE AND PREFILTER READS

    # -- (1) concatenate raw reads
    ./run_files/concatenate_fastq.sh

    # -- (2) deplete contaminant reads
    mamba activate minimap2
    python run_files/map_deplete.py
    mamba deactivate

    # -- (3) quality check the reads
    python run_files/quality_check.py

    # -- (4) get parameters for chopper
    python run_files/chopper_params.py

    # -- (5) chop reads
    mamba activate chopper
    ./run_files/run_chopper.sh
    mamba deactivate

    # -- (6)get taxonomic profiles with sourmash (version 4.8.5, GTDB version 214)
    mamba activate smash
    ./run_files/run_sourmash.sh
    mamba deactivate

    echo "meta_pipe complete"
else
    echo "Please move raw reads to 'a_rawReads' and rerun meta-pipe.sh"
fi
