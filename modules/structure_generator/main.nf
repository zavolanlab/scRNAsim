process STRUCTURE {

    publishDir params.outdir, mode:'copy'
    
    input:
    val prob
    path repTransCsv
    path repTransGtf

    output:
    path "*.gtf", emit: gtf
    path "*.csv", emit: csv

    script:
    """
    structure-generator \
        -p $prob \
        $repTransCsv \
        $repTransGtf
    """
}