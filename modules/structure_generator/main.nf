params.outdir = "results"

// Define the Nextflow module 'structure-generator'
process STRUCTURE {

    publishDir params.outdir, mode:'copy'
    
    // Define the input parameters for the module
    input:
    val prob
    path repTransCsv
    path repTransGtf

    // Define the output directory for this process
    output:
    path "*.gtf", emit: gtf
    path "*.csv", emit: csv

    // Define the command to run
    script:
    """
    structure-generator \
        -p $prob \
        $repTransCsv \
        $repTransGtf
    """
}