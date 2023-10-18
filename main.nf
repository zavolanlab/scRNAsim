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
 transcript counts: ${params.trx_cnt}
 transcript annotation: ${params.annotation}
 number of transcripts to sample: ${params.n_trx}
 outdir       : ${params.outdir}
 inclusion prob: ${params.prob}
 """

// import modules
include { SAMPLER } from './modules/transcript_sampler'
include { STRUCTURE } from './modules/structure_generator'
//include { CDNA } from './modules/cdna_generator'
//include { FRAGMENT } from './modules/fragment_selector'
include { PRIME } from './modules/priming_site_predictor'
//include { SEQUENCER } from './modules/read_sequencer'
include { EXTRACT } from './modules/sequence_extractor'

// Define inputs
trx_cnt_ch = Channel.fromPath( params.trx_cnt )
annotation_ch = Channel.fromPath( params.annotation )
n_trx_ch = Channel.value( params.n_trx )
polyA_len_ch = Channel.value( params.polyA_len )
genome_ch = Channel.fromPath( params.genome )
transcriptSeq = Channel.fromPath( params.transcriptSeq )
primerSeq = Channel.fromPath( params.primerSeq )

/* 
 * main script flow
 */
workflow {
    SAMPLER( trx_cnt_ch, annotation_ch, n_trx_ch )
    STRUCTURE( params.prob, SAMPLER.out.csv, SAMPLER.out.gtf)
    sampled_gtf_ch = STRUCTURE.out.gtf
    EXTRACT( sampled_gtf_ch, polyA_len_ch, genome_ch )
    PRIME( params.transcriptSeq, params.primerSeq )
    }

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/report.html\n" : "Oops .. something went wrong" )
}