params.outdir = "results"

// Define the Nextflow module 'structure-generator'
process STRUCTURE {

    publishDir params.outdir, mode:'copy'
    
    // Define the input parameters for the module
    input:
    path repTransCsv
    path repTransGtf
    float probIncl

    // Define the output directory for this process
    output:
    path "*"

    // Define the command to run
    script:
    """
    structure-generator \
        -p ${probIncl} \
        ${repTransCsv} \
        ${repTransGtf}
    """
}