params.outdir = "results"

// Define the Nextflow module 'FRAGMENT'
process FRAGMENT {

    publishDir params.outdir, mode:'copy'
    
    // Define the input parameters for the module
    input:
    path cdna_fasta
    path cdna_counts
    val fragment_mean
    val fragment_sd

    // Define the output directory for this process
    output:
    path "terminal_fragments.fa", emit: fa

    // Define the command to run
    script:
    """
    fragment-selector \
        --fasta $cdna_fasta \
        --counts $cdna_counts \
        --mean $fragment_mean \
        --std $fragment_sd \
        --output terminal_fragments.fa
    """
}