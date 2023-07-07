# PentaChiliadal-Virome
Gut virome analysis from metagenomic data on Lifelines NEXT Cohort.


## Introduction

Lifelines NEXT is a birth cohort including 1500 pregnant women, their partners and children living in Northern Netherlands. Extensive biological specimens (including fecal samples) and phenotypyc information (both maternal phenotypes during and after pregnancy, and infant phenotypes during the first year of life) are collected. PentaChiliadal-Virome project aims to analyze the gut virome of mothers during and after pregnancy, as well as infant gut virome in early life. For this, longitudinal metagenomic sequencing data from 4,626 fecal samples is used and analyzed through a custom viral discovery pipeline.


## Content

We here describe the methods used to:

- Perform the viral detection from assembled metagenomic data (VirSorter2, DeepVirFinder)
- Identify and filter plasmid sequences (geNomad)
- Remove host contamination and filter viral sequences with low completeness (≤50%) (CheckV)
- Perform a rRNA-based quality control to further remove possible bacterial contamination
- Dereplicate the predicted viral sequences with viral genomes from public databases
- Abundance estimation of the viral sequences
- Downstream analyses 
