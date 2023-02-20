# PentaChiliadal-Virome
Gut virome analysis from metagenomic data on Lifelines NEXT Cohort.


##Introduction

Lifelines NEXT is a birth cohort including 1500 pregnant women, their partners and children living in Northern Netherlands. Extensive biological specimens (including fecal samples) and phenotypyc information (both maternal phenotypes during and after pregnancy, and infant phenotypes during the first year of life). PentaChiliadal-Virome project aims to analyze the gut virome of mothers during and after pregnancy, as well as infant gut virome in early life. For this, longitudinal metagenomic sequencing data from 4,626 samples is used and analyzed trough a custom viral discovery pipeline.


##Content

We here describe the methods used to:

Perform the viral detection from assembled metagenomic data (VirSorter2, DeepVirFinder)
Identify and filter plasmid sequences (geNomad)
Remove host contamination and filter viral sequences with low completeness (≤50%) (CheckV)


The pipelines for each of these analyses are summarized in the next files:

###a) Bash scripts:

Trimming_qualitycontrol
Mapping
Quantification (2)
De_novo_miRNA_identification (3)
Extraction_de_novo_miRNAs (3)
De_novo_quantification (3)

###b) Python scripts:

Descriptive_data_analysis (1)
Differential_expression_with_DESeq2 (4)
Differential_expression_with_edgeR (4)
Enrichment_analysis (5) 


The project workflow is summarized in the next figure:
