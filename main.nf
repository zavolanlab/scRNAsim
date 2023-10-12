/* 
 * enables modules 
 */
nextflow.enable.dsl = 2

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */


params.outdir = "results"


log.info """\
 SINGLE CELL RNA-SEQ SIMULATION - N F   P I P E L I N E
 ===================================
 genome: ${params.genome}
 transcript counts: ${params.trx_cnt}
 transcript annotation: ${params.annotation}
 outdir       : ${params.outdir}
 """

// import modules
include { STRUCTURE } from './modules/structure_generator'


/* 
 * main script flow
 */
workflow {
    STRUCTURE( params.repTransCsv, params.repTransGtf )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/report.html\n" : "Oops .. something went wrong" )
}