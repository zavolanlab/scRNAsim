// Define the Nextflow module 'RIBLAST'
process RIBLAST {
    label "RIblast_process"
    container "quay.io/biocontainers/riblast:1.2.0--hdcf5f25_0"

    input:
    path transcriptSeq
    path primerSeq

    output:
    path "riblast_output.txt", emit: txt

    script:
    """
    RIblast db -i $transcriptSeq -o riblast_db
    RIblast ris -i $primerSeq -o riblast_output.txt -d riblast_db
    """
}

// // Define the Nextflow module 'POST_RIBLAST'
// process POST_RIBLAST {

//     publishDir params.outdir, mode:'copy'
    
//     // Define the input parameters for the module
//     input:
//     val prob
//     path repTransCsv
//     path repTransGtf

//     // Define the output directory for this process
//     output:
//     path "*"

//     // Define the command to run
//     script:
//     """
//     structure-generator \
//         -p $prob \
//         $repTransCsv \
//         $repTransGtf
//     """
// }

// // Define the Nextflow workflow 'PRIME'
// workflow PRIME {

//     take:
// 	genome_ch
//     gtf_ch
// 	other_genes_unmapped_fasta

//     main:   
// 	// generate index for later mapping
// 	STAR_INDEX_GENOME(
// 		genome_ch
// 	)
// 	genome_index = STAR_INDEX_GENOME.out.index

// 	// map reads to genome with star and use samtools
// 	MAP_GENOME_STAR(
// 		other_genes_unmapped_fasta,
// 		genome_index,
// 		gtf_ch
// 	)
// 	star_mapped_sam = MAP_GENOME_STAR.out.aligned
// 	star_unmapped_fasta = MAP_GENOME_STAR.out.unmapped

// 	SAM_TO_BAM_SORT_AND_INDEX_STAR(
//         star_mapped_sam
//     )
//     star_mapped_sortindex_bam = SAM_TO_BAM_SORT_AND_INDEX_STAR.out.bam
//     star_mapped_sortindex_bai = SAM_TO_BAM_SORT_AND_INDEX_STAR.out.bai
//     bam_sort_index_folder = SAM_TO_BAM_SORT_AND_INDEX_STAR.out.folder

//     emit:
// 	bam_sort_index_folder

// }
