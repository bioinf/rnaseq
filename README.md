# RNA-seq one-command pipeline 
<center>I choose a lazy person to do a hard job. Because a lazy person will find an easy way to do it.</center>

This collection of scripts is dedicated to one purpose: align, visualize, and quantify RNA-seq experiments with minimal interaction and using the best practices. The pipeline is implemented in bash and implies the use of a Unix system. It is designed to be applicable to Illumina (paired- and singe-end experiments), as long as colorspace (ABI SOLID) reads. 

## Prerequisites
The following programs need to be installed and available in the system $PATH variable:
* fastqc
* STAR
* bowtie (v1 for colorspace reads)
* tophat2 (for colorspace reads)
* rsem
* kallisto
* igvtools
* samtools
* Picard tools (as a separate folder)

## Configuration file 
The following options need to be specified in order for the pipeline to work.

## Preparing the reference
This is how you prepare the reference. 
