process SAMPLER {


    input:
    path in_csv
    path in_gtf
    val n_trx 

    output:
    path out_gtf
    path out_csv 

    script:
    """
    transcript-sampler --input_gtf=$in_gtf --input_csv=$in_csv --output_gtf="out_gtf" --output_csv="out_csv" --n_to_sample=$n_trx
    """
}