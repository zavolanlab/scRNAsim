process SEQUENCER {

    publishDir params.outdir, mode:'copy'
    
    input:
    path terminal_fragments
    val read_length

    output:
    path "sequenced_reads.fa", emit: fa

    script:
    """
    read-sequencer \
        -i $terminal_fragments \
        -r $read_length \
        sequenced_reads.fa
    """
}