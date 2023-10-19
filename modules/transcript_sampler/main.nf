process SAMPLER {

    publishDir params.outdir, mode:'copy'

    input:
    path in_csv
    path in_gtf
    val n_trx 

    output:
    path "sampled.gtf", emit: gtf
    path "sampled.csv", emit: csv

    script:
    """
    transcript-sampler --input_gtf=$in_gtf --input_csv=$in_csv --output_gtf="sampled.gtf" --output_csv="sampled.csv" --n_to_sample=$n_trx
    """
}