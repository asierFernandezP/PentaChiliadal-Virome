######
###Estimating q-values from p-values using DeepVirFinder output files
######

#Load libraries
library(qvalue)

# Get the input passed from the shell script
args <- commandArgs(trailingOnly = TRUE)

# Use shell input
dvf_file<-args[1] 

#Read the file, estimate the q-value, sort the results and write the final file
df <- read.csv(dvf_file, sep = "\t")
df$qvalue <- qvalue(df$pvalue,pi0 = 1)$qvalues
df <- df[order(df$qvalue),]
write.table(df, file = sub('\\_metaspades_contigs.fa_gt10000bp_dvfpred.txt$', '_DVF_gt10000bp_processed.txt', dvf_file), sep ="\t", row.names = F)
