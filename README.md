# meta_pipe 🧬
Pipeline to QC and filter long read metagenomic data and generate taxonomic profiles using sourmash.
Compatible with MacOS
Requires mamba package manager 

### To install meta pipe:
```bash
git clone https://github.com/isabella-burdon/meta_pipe.git
```
### To set up meta pipe:
1. the human reference genome needs to be downloaded and stored as chm13.fasta in the b_contaminants folder.
   this can be dowloaded from ncbi at:
``` link
https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_009914755.1/
```
 navigate to the meta_pipe directory
3. run:
```bash
./setup.sh
```
This will download necessary dependancies / software / GTDB (time consuming).

### To run meta pipe:
1. move raw fastq.gz files into the a_rawReads folder
     These files should be unconcatenated and in appropriately named folders.
     e.g. folder names "barcode01, barcode 02 ...", these names will be used for pipeline outputs.
2. navigate to the meta_pipe directory
3. run:
```bash
./run_metapipe.sh
```
## What is meta pipe doing?
1. Concatenates raw fastq.gz files
2. Using minimap2, depletes reads that map to contaminant genomes (human and phage lambda)
3. Produces a read metrics report (json or txt format) - number of reads total, number of human/bacterial reads
4. Using nanoQC, finds the average length of poor quality bases at the start and end of reads in each sample
5. Using chopper, trims the start and the end of all reads in the sample to remove poor quality bases
6. Using sourmash, creates a taxonomic profile of each of the samples (krona.csv files saved to d_output)
