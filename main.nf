process TrimAdapters {
    input:
    path fastq

    output:
    path "${fastq.simpleName}_trimmed.fastq.gz"

    script:
    """
    cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
        -o ${fastq.simpleName}_trimmed.fastq.gz ${fastq}
    """
}

process CountGuides {
    input:
    path trimmed_fastq
    path library

    output:
    path "count.txt"

    script:
    """
    mageck count -l ${library} -n count \
        --fastq ${trimmed_fastq} \
        --sample-label T0,Tfinal
    """
}

process RunMAGeCKTest {
    input:
    path "count.txt"

    output:
    path "mageck_output"

    script:
    """
    mkdir mageck_output
    mageck test -k count.txt -t Tfinal -c T0 -n mageck_output/result
    """
}

