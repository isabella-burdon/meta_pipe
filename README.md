# meta_pipe 🧬
Meta pipe is a pipeline to quality check long read metagenomic data and generate taxonomic profiles using sourmash.
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
1. Concatenates raw fastq.gz files
2. Using minimap2, depletes reads that map to contaminant genomes (human and phage lambda)
3. Produces a read metrics report (json or txt format) - number of reads total, number of human/bacterial reads
4. Using nanoQC, finds the average length of poor quality bases at the start and end of reads in each sample
5. Using chopper, trims the start and the end of all reads in the sample to remove poor quality bases
6. Using sourmash, creates a taxonomic profile of each of the samples (krona.csv files saved to d_output)

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
5. Run the following:
```bash
conda install mamba -n base -c conda-forge
```
