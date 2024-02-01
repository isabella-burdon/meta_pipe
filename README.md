# meta_pipe 🧬

```ascii
╭────────🧬 Long Read Data 🧬─────────
│                 ↓                 
╰────────── ⚡️ Meta Pipe ⚡️ ───────────╮
                  ↓                  │
──────── ✨✨✨ Results ✨✨✨ ────────╯
```

Meta pipe is an easy to use pipeline to quality check long read metagenomic data and generate taxonomic profiles using sourmash.
- Compatible with MacOS
- Requires mamba package manager (see mamba installation below)

### To install meta pipe:
```bash
git clone https://github.com/isabella-burdon/meta_pipe.git
```
### To set up meta pipe:
1. The human reference genome needs to be downloaded from:
``` link
https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_009914755.1/
```
Please unzip and store the reference genome as 'chm13.fasta' in the b_contaminants folder.

2. Navigate to the meta_pipe directory
3. Run:
```bash
./setup.sh
```
This will download necessary dependancies / software / GTDB (time consuming).

### To run meta pipe:
1. Move raw fastq.gz files into the a_rawReads folder

   These files should be unconcatenated and in appropriately named folders (see diagram below).

   e.g. folder names "barcode01, barcode 02 ...", these names will be used for pipeline outputs.
3. Navigate to the meta_pipe directory
4. Run:
```bash
./run_metapipe.sh
```
5. Wait for RESULTS! 🥳

Schematic diagram of folders for input
```diagram
meta_pipe (root)
└── a_rawReads
    ├── barcode01
    │   ├── file1_pass.fastq.gz
    │   ├── file2_pass.fastq.gz
    │   ├── file3_pass.fastq.gz
    │   └── ...
    ├── barcode02
    │   ├── file1_pass.fastq.gz
    │   ├── file2_pass.fastq.gz
    │   ├── file3_pass.fastq.gz
    │   └── ...
    ├── barcode03
    │   ├── file1_pass.fastq.gz
    │   ├── file2_pass.fastq.gz
    │   ├── file3_pass.fastq.gz
    │   └── ...
    └── ...
```
Please reach out with any issues via github or email.

## What is meta pipe doing?

Meta pipe handles the setup of all necessary environments and activates / deactivates environments as needed
Meta pipe installs all necessary software, databases and reference genomes (except human reference genome which needs to be manually installed as above)
Meta pipe sets up GTDB for use with sourmash

### Prefilter steps
1. Concatenates raw fastq.gz files
2. Using minimap2, depletes reads that map to contaminant genomes (human and phage lambda)
3. Produces a read metrics report (json or txt format) - number of reads total, number of human/bacterial reads
   Located in 'b_readMetrics' folder. Path to json or txt file:
```bash
b_readMetrics/summary_metrics.josn
b_readMetrics/summary_compile.txt
```
5. Using nanoQC, finds the average length of poor quality bases at the start and end of reads in each sample
6. Using chopper, trims the start and the end of all reads in the sample to remove poor quality bases

### Taxanomic assignment and profiling of reads
8. Using sourmash, creates a taxonomic profile of each of the samples (krona.csv files saved to d_output)

#### Minimap2
* Tool to facilitate pairwase alignment of long read metagenomic data.
* In meta pipe this is used to map the human reference genome and the phage lambda genome to reads in your dataset. These matching reads are then removed from the data.
* Human (chm13) and phage lambda depleted reads as stored in 'b_readsDepleted'

Git: https://github.com/lh3/minimap2
Paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6137996/

#### NanoQC
* Tool to evaluate the average quality of the first 100 (head) and last 100 (tail) of reads in a sample
* The output of this is a .html file to visualise this data

Code written in meta pipe on top of this:
1. Extract and parse the json data in the html file
2. Using this data, find the point where the frequency of nucleotides in the read normalises at head and tail

--> Meta pipe then uses chopper to trim the low quality parts of the read at the head and tail

<img width="810" alt="Screenshot 2024-02-02 at 8 18 02 am" src="https://github.com/isabella-burdon/meta_pipe/assets/133566275/67575f64-b49b-4a9c-9bfc-bd4615fbbdbe">

In this example above the first 81 and last 55 bases are trimmed from every read in that sample.

Git: https://github.com/wdecoster/nanoQC

#### Chopper
* Tool to filter / trim reads in long read datasets.
* In Metapipe --headcrop and --tailcrop are used to remove poor quality bases from the start and end of reads.

Git: https://github.com/wdecoster/chopper
Paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10196664/

#### Sourmash
* Tool to perform taxanomic profiling of shotgun long read metagenomic data
* In meta pipe the database used is GTDB rs214

Meta pipe uses the following sourmash commands per samples:
```bash
# -- (1) sketch
sourmash sketch dna -p k=31,abund c_readsChopped/barcode01.fastq.gz \
    -o d_tmp/barcode01.sig.gz --name barcode01

# -- (2) gather matches (time consuming)
sourmash gather barcode01.sig.gz genome_db/gtdb-rs214-k31.zip --save-matches d_tmp/matches01.zip

# -- (3) save gather results to csv
sourmash gather d_tmp/barcode01.sig.gz d_tmp/matches01.zip -o d_tmp/barcode01.gather.k31.gtdb.csv

# -- (4) tax metagenome to profile microbiome
sourmash tax metagenome -g d_tmp/barcode01.gather.k31.gtdb.csv -o d_output/barcode07.profile.csv \
    -t genome_db/gtdb-rs214.taxonomy.sqldb -F krona -r species
```

Git: https://github.com/sourmash-bio/sourmash
Paper: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9749362/

## Mamba installation
(for mac users)
1. Open a new terminal window
3. Run the following in terminal to download miniforge:
```bash
wget https://github.com/conda-forge/miniforge?tab=readme-ov-file](https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh)https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-x86_64.sh
```
2. Run the installer bash file:
```bash
bash Mambaforge-MacOSX-x86_64.sh
```
3. Enter through and accept the licence
4. Say yes to running conda init to initialise miniconda
5. Enable channels:
```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```
7. Run the following to install mamba:
```bash
conda install mamba -n base -c conda-forge
```
