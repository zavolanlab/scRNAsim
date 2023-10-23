params.outdir = "results"

// Define the Nextflow module 'structure-generator'
process CDNA {

    publishDir params.outdir, mode:'copy'
    
    // Define the input parameters for the module
    input:
    path genome_fasta
    path priming_sites_gtf
    path sampled_transcript_counts_csv

    // Define the output directory for this process
    output:
    path "cdna_seq.fa", emit: fa
    path "cdna_counts.csv", emit: csv

    // Define the command to run
    script:
    """
    cdna-generator \
        -ifa $genome_fasta \
        -igtf $priming_sites_gtf \
        -icpn $sampled_transcript_counts_csv \
        -ofa cdna_seq.fa \
        -ocsv cdna_counts.csv
    """
}