# Load R packages
library(stats)

# Get names of viral genomes and samples from command line arguments
args <- commandArgs(trailingOnly = TRUE)
viral_DB_origin <- read.delim(args[1], header=F) # file with the names of all viral sequences to be used as input for dereplication

# Add DB information
colnames(viral_DB_origin)[1] <- "viral_seq"
viral_DB_origin$DB <- NA
viral_DB_origin[,"DB"] [grep("^[ABCDY].*NODE", viral_DB_origin$viral_seq)] <- "LLNEXT" # 96,376
viral_DB_origin[,"DB"] [grep("MGV-GENOME", viral_DB_origin$viral_seq)] <- "MGV" #189,680
viral_DB_origin[,"DB"] [grep("uvig|ivig", viral_DB_origin$viral_seq)] <- "GPD" # 82,621
viral_DB_origin[,"DB"] [grep("^NC.*\\.|^AC.*\\.", viral_DB_origin$viral_seq)] <- "Viral_RefSeq" #5,199
viral_DB_origin[,"DB"] [grep("^NL", viral_DB_origin$viral_seq)] <- "Gulyaeva" #637
viral_DB_origin[,"DB"] [grep("^[UQPOC].*\\.1\\s[^>]*shotgun sequence", viral_DB_origin$viral_seq)] <- "Benler" #1480
viral_DB_origin[,"DB"] [grep("OTU_", viral_DB_origin$viral_seq)] <- "Shah" #4627
viral_DB_origin[,"DB"] [grep("^NEGCONTROL", viral_DB_origin$viral_seq)] <- "Neg_control" #5
viral_DB_origin[,"DB"][(nrow(viral_DB_origin)-248):nrow(viral_DB_origin)] <- "Guerin" #249
viral_DB_origin[,"DB"][which(is.na(viral_DB_origin$DB))] <- "Yutin" #656

# Check for duplicated values
virus_duplicated <- viral_DB_origin[duplicated(viral_DB_origin$viral_seq), "viral_seq"]
deduplicated_viral_DB_origin <- viral_DB_origin[!duplicated(viral_DB_origin$viral_seq), ]
deduplicated_viral_DB_origin$DB [which(deduplicated_viral_DB_origin$viral_seq %in% virus_duplicated)] <- "Guerin"
cat("The duplicated sequences are:", virus_duplicated)

# Add new simplified viral IDs (including prophage information)
deduplicated_viral_DB_origin$new_viral_ID <- ave(deduplicated_viral_DB_origin$DB, deduplicated_viral_DB_origin$DB, 
                       FUN = function(x) paste0(x, "_", seq_along(x)))

for (i in 1:nrow(deduplicated_viral_DB_origin)) {
  if (grepl("/",deduplicated_viral_DB_origin$viral_seq[i])) {
    deduplicated_viral_DB_origin$new_viral_ID[i] <- paste0(deduplicated_viral_DB_origin$new_viral_ID[i], "_prophage")
  }
}

# Save final file with the 381,522 sequences used as input for STEP5 dereplication and their DB of origin (including 5 NEG-CONTROLS)
write.table(deduplicated_viral_DB_origin,"STEP5_input_sequences_nodup_DB_origin.txt", sep = "\t", 
            row.names = F, col.names = F, quote = FALSE)
