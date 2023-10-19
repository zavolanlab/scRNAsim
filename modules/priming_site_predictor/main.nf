// Define the Nextflow module 'RIBLAST'
process RIBLAST {
    label "RIblast_process"
    container "quay.io/biocontainers/riblast:1.2.0--hdcf5f25_0"

    input:
    path extracted_seqs_ch
    path primerSeq_ch

    output:
    path "riblast_output.txt", emit: txt

    script:
    """
    RIblast db -i $extracted_seqs_ch -o riblast_db
    RIblast ris -i $primerSeq_ch -o riblast_output.txt -d riblast_db
    """
}

// // Define the Nextflow module 'POST_RIBLAST'
process POST_RIBLAST {

    publishDir params.outdir, mode:'copy'
    
    // Define the input parameters for the module
    input:
    path riblast_output

    // Define the output directory for this process
    output:
    path "priming_sites.gtf", emit: gtf

    // Define the command to run
    script:
    """
    priming-site-predictor \
        -r $riblast_output \
        -o priming_sites.gtf \
    """
}

// Define the Nextflow workflow 'PRIME'
workflow PRIME {

    take:
	extracted_seqs_ch
    primerSeq_ch

    main:   
    RIBLAST( 
        extracted_seqs_ch, 
        primerSeq_ch )
	riblast_output = RIBLAST.out.txt

	POST_RIBLAST(
        riblast_output
	)
	priming_sites = POST_RIBLAST.out.gtf

    emit:
	priming_sites

}
