################################################################################
##### LL-NEXT metadata with number of reads for abundance estimation
### Author(s):Asier Fernández
### Last updated: 14th May, 2023
################################################################################

##************************************************************************
# Prepare metadata file with number of reads for abundance estimation
#*************************************************************************
# Here, we include all 4628 samples (also AMBF012534G3 and AMBF028434G2 samples)

# Set working directory and load files
setwd("~/Desktop/PhD/Projects/Virome LL-Next/Analysis/")

# metadata_virome: #4603 samples (AMBF012534G3 and AMBF028434G2 are not present here)
# metadata_virome_low_reads: 25 samples (without FSK control) - 23 if we exclude AMBF012534G3 and AMBF028434G2
metadata_virome <- read.delim("Metadata_NEXT/LLNEXT_metadata_03_03_2023.txt") 
metadata_virome_low_reads <- read.delim("Metadata_NEXT/metadata_samples_low_read-number.txt") 

#Create metadata with number of reads for the abundance estimation step
metadata_reads <- data.frame(cbind(c(metadata_virome$NG_ID, metadata_virome_low_reads$NG_ID),
                                   c(metadata_virome$clean_reads_FQ_1, metadata_virome_low_reads$clean_reads_FQ_1)))
colnames(metadata_reads) <- c("sample","clean_reads")

# Write resulting table
write.table(metadata_reads,"LLNEXT_PentaChiliadal_nreads_4628_clean.txt", sep = "\t", row.names = F, quote=F)
