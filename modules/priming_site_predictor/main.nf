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

process POST_RIBLAST {

    publishDir params.outdir, mode:'copy'
    
    input:
    path riblast_output

    output:
    path "priming_sites.gtf", emit: gtf

    script:
    """
    priming-site-predictor \
        -r $riblast_output \
        -o priming_sites.gtf \
    """
}

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
