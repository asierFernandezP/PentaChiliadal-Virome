################################################################################
##### Check DB of origin of viral sequences and duplicated viruses
### Author(s):Asier Fernández
### Last updated: 12th May, 2023
################################################################################

# Set working directory
setwd("~/Desktop/PhD/Projects/Virome LL-Next/Analysis/Remove duplicates input STEP 5/")

# Read file with all the sequence IDs to be used for dereplication
viral_DB_origin <-  read.delim("STEP5_input_sequences.txt", header =F) 
colnames(viral_DB_origin)[1] <- "viral_seq"

# Add DB information
# Important things to consider:
# Yutin DB has "NC_021803  Cellulophaga phage phi13:2, complete genome" and "NC_021798 Cellulophaga phage phi17:2, complete genome"
# Viral RefSeq has "NC_021803.1 Cellulophaga phage phi13:2, complete genome" and "NC_021798.1 Cellulophaga phage phi17:2, complete genome" 
# 8 duplicated sequences between Yutin-Guerin DBs:ERR844030_ms_1, ERR975045_s_1, Fferm_ms_11, HvCF_A6_ms_4, IAS_virus_KJ003983
# Inf125_s_2, Sib1_ms_5, SRR4295175_ms_5
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
deduplicated_viral_DB_origin$DB [which(deduplicated_viral_DB_origin$viral_seq %in% virus_duplicated)] <- "Guerin_Yutin"

# Save final with the 381,522 sequences used as input for STEP5 dereplication (including 5 NEG-CONTROLS)
write.table(deduplicated_viral_DB_origin,"STEP5_input_sequences_nodup_DB_origin.txt", sep = "\t", 
            row.names = F, col.names = F, quote = FALSE)
