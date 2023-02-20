# PentaChiliadal-Virome
Gut virome analysis from metagenomic data on Lifelines NEXT Cohort

Introduction

microRNAs (miRNAs) are a class of small non-coding RNAs of between 19-22 nucleotides that act as post-transcriptional regulators of the expression of most proteins, either by repressing translation or by degrading messenger RNAs (mRNAs). The gaining evidence pointing to an essential role of miRNAs in the regulation of numerous biological processes are favoring the development of the miRNA-seq analyses in the last years.

The characterization of the miRNA profiles of SARS-CoV-2 infected patients by massive sequencing constitutes an alternative approach that has been hardly explored, although there is considerable evidence that supports the relevant role of miRNAs in the response to different viral infections. 


Content

We here describe the methods used to:

Perform a descriptive data analysis of clinical variables from COVID-19 patients.
Identify and quantify all known human miRNAs present in plasma samples.
Identify and quantify possible new human miRNAs.
Perform a statistical analysis to determine which miRNAs are associated with a worse prognosis of COVID-19 disease.
Perform a functional analysis of the deregulated miRNAs between groups, identifying the target genes of these miRNAs and analyzing the metabolic pathways in which the affected genes are involved. 

The pipelines for each of these analyses are summarized in the next files:

a) Bash scripts:

Trimming_qualitycontrol
Mapping
Quantification (2)
De_novo_miRNA_identification (3)
Extraction_de_novo_miRNAs (3)
De_novo_quantification (3)
b) R scripts:

Descriptive_data_analysis (1)
Differential_expression_with_DESeq2 (4)
Differential_expression_with_edgeR (4)
Enrichment_analysis (5) 


The project workflow is summarized in the next figure:
