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