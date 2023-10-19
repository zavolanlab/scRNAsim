#!/usr/bin/env nextflow
nextflow.enable.dsl=2
// Define a subworkflow for the sequence_extractor module

process MAKE_BED {
    label "make_bed"
    publishDir params.outdir, mode:'copy'

    input:
    path in_gtf

    output:
    path "output.bed", emit: bed

    script:
    """
    sequence-extractor \
        --mode="pre_bedtools" \
        --input-gtf-file=$in_gtf \
        --output-bed-file="output.bed"
    """
}

process GET_SEQS {
    label "get_seqs"
    container 'quay.io/biocontainers/bedtools:2.27.1--hdcf5f25_8'
    publishDir params.outdir, mode:'copy'
    
    input:
    path bed
    path genome_ch

    output:
    path "output.fasta", emit: fasta

    script:
    """
    bedtools getfasta \
        -fi $genome_ch \
        -bed $bed \
        -name \
        -s \
        -fo "output.fasta"
    """
}

process MAKE_TRANSCRIPTS {
    label "make_transcripts"
    publishDir params.outdir, mode:'copy'

    input:
    path fasta
    val polya_len

    output:
    path "polyA_output.fasta", emit: polya_fasta

    script:
    """
    sequence-extractor \
        --mode="post_bedtools" \
        --input-fasta-file=$fasta \
        --polyA-length=$polya_len \
        --output-file-name="polyA_output.fasta"
    """
}


workflow EXTRACT {
    take:
        sampled_gtf_ch
        polyA_len_ch
        genome_ch

    main:
    MAKE_BED( 
        sampled_gtf_ch
        )

    GET_SEQS( 
        MAKE_BED.out.bed,
        genome_ch
        )

    MAKE_TRANSCRIPTS( 
        GET_SEQS.out.fasta,
        polyA_len_ch
        )

    polya_fasta_ch = MAKE_TRANSCRIPTS.out.polya_fasta

    emit:
    polya_fasta_ch
    }


