process FRAGMENT {

    publishDir params.outdir, mode:'copy'
    
    input:
    path cdna_fasta
    path cdna_counts
    val fragment_mean
    val fragment_sd

    output:
    path "terminal_fragments.fa", emit: fa

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