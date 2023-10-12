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
include { CDNA } from './modules/cdna_generator'
include { FRAGMENT } from './modules/fragment_selector'
include { PRIME } from './modules/priming_site_predictor'
include { SEQUENCER } from './modules/read_sequencer'
include { EXTRACT } from './modules/sequence_extractor'
include { STRUCTURE } from './modules/structure_generator'
include { SAMPLER } from './modules/transcript_sampler'


/* 
 * main script flow
 */
workflow {
    SAMPLER( params.trx_cnt )
    STRUCTURE( SAMPLER.out, params.annotation )
    EXTRACT( STRUCTURE.out, params.polya )
    PRIME( EXTRACT.out )
    CDNA( PRIME.out )
    FRAGMENT( CDNA.out )
    SEQUENCER( FRAGMENT.out, params.genome )
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/report.html\n" : "Oops .. something went wrong" )
}