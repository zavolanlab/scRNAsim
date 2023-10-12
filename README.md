# scRNAsim
The projects implements a simulation of single cell RNA sequencing (scRNA-seq), accounting for some common sources noise that complicate the analysis of the resulting data.

### Setting up the virtual environment

Create and activate the environment with necessary dependencies with Conda:

```bash
conda env create -f environment.yml
conda activate scrnasim
```


If you would like to contribute to _scRNAsim_ development, you may find it 
useful to further update your environment with the development dependencies:

```bash
conda env update -f environment-dev.yml
```

### Workflow

The workflow makes use of the tools available in the [scRNAsim-toolz](https://github.com/zavolanlab/scRNAsim-toolz) repo. These are:
1. Transcript sampler
2. Structure generator
3. Sequence extractor
4. Priming site predictor
5. cDNA generator
6. Fragment selector
7. Read sequencer


Inputs:
1. Genome annotation file (gtf) (#1)
2. Average gene expression values (csv: geneID,count) (#1)
3. Total number of transcripts to samples (#1)
4. Probability of intron inclusion (#2)
5. Genome sequence file (fasta) (#3)
6. Length of poly(A) tails (#3)
7. Primer sequence (#4)
8. Threshold for the energy of primer-mRNA interaction needed for priming (#4)
9. Mean of fragment length (#6)
10. SD of fragment length (#6)
11. Read length (number of sequencing cycles) (#7)

Outputs:
1. Representative transcripts (gtf) (#1)
2. Representative transcript counts (csv: transcriptID,count) (#1)
3. Sampled transcripts (gtf) (#2)
4. Sampled transcript counts (csv: transcriptID,count) (#2)
5. Transcript sequences (fasta) (#3)
6. Annotated internal priming sites (gtf) (#4)
7. Unique cDNA sequences (fasta) (#5)
8. cDNA count table (csv) (#5)
9. Terminal fragment sequences (fasta) (#6)
10. Read sequences (fasta) (#7)