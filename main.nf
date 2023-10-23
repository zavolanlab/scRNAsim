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
include { EXTRACT } from './modules/sequence_extractor'
include { PRIME } from './modules/priming_site_predictor'
include { CDNA } from './modules/cdna_generator'
include { FRAGMENT } from './modules/fragment_selector'
//include { SEQUENCER } from './modules/read_sequencer'


// Define inputs
trx_cnt_ch = Channel.fromPath( params.trx_cnt )
annotation_ch = Channel.fromPath( params.annotation )
n_trx_ch = Channel.value( params.n_trx )
polyA_len_ch = Channel.value( params.polyA_len )
genome_ch = Channel.fromPath( params.genome )
primerSeq_ch = Channel.fromPath( params.primerSeq )
frag_mean = Channel.value( params.frag_mean )
frag_sd = Channel.value( params.frag_sd )

/* 
 * main script flow
 */
workflow {
    SAMPLER( trx_cnt_ch, annotation_ch, n_trx_ch )
    STRUCTURE( params.prob, SAMPLER.out.csv, SAMPLER.out.gtf)
    sampled_gtf_ch = STRUCTURE.out.gtf
    sampled_transcript_counts_csv = STRUCTURE.out.csv
    EXTRACT( sampled_gtf_ch, polyA_len_ch, genome_ch )
    extracted_seqs_ch = EXTRACT.out.polya_fasta_ch
    PRIME( extracted_seqs_ch , primerSeq_ch )
    priming_sites_gtf = PRIME.out.priming_sites
    CDNA( extracted_seqs_ch, priming_sites_gtf, sampled_transcript_counts_csv )
    cdna_seq = CDNA.out.fa
    cdna_counts = CDNA.out.csv
    FRAGMENT( cdna_seq, cdna_counts, frag_mean, frag_sd )
    terminal_fragments = FRAGMENT.out.fa
    }

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/report.html\n" : "Oops .. something went wrong" )
}