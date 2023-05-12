# Read names of all sequences from the different DBs
viral_DB_origin <-  read.delim("STEP5_input_sequences.txt", header =F) 

# Add DB information
# Important things to consider:
# Yutin DB has "NC_021803  Cellulophaga phage phi13:2, complete genome" and "NC_021798 Cellulophaga phage phi17:2, complete genome"
# Viral RefSeq has "NC_021803.1 Cellulophaga phage phi13:2, complete genome" and "NC_021798.1 Cellulophaga phage phi17:2, complete genome" 
# 8 duplicated sequences between Yutin-Guerin DBs:ERR844030_ms_1, ERR975045_s_1, Fferm_ms_11, HvCF_A6_ms_4, IAS_virus_KJ003983
# Inf125_s_2, Sib1_ms_5, SRR4295175_ms_5
viral_DB_origin$DB <- NA
viral_DB_origin[,"DB"] [grep("^[ABCDY].*NODE", viral_DB_origin$V1)] <- "LLNEXT" # 217,352
viral_DB_origin[,"DB"] [grep("MGV", viral_DB_origin$V1)] <- "MGV" #189680
viral_DB_origin[,"DB"] [grep("uvig|ivig", viral_DB_origin$V1)] <- "GPD" # 84,537
viral_DB_origin[,"DB"] [grep("^NC.*\\.|^AC.*\\.", viral_DB_origin$V1)] <- "Viral_RefSeq" #5,199
viral_DB_origin[,"DB"] [grep("^NL", viral_DB_origin$V1)] <- "Gulyaeva" #637
viral_DB_origin[,"DB"] [grep("^NEGCONTROL", viral_DB_origin$V1)] <- "Neg_control" #5
viral_DB_origin[,"DB"][498067:498315] <- "Guerin" #249
viral_DB_origin[,"DB"][which(is.na(viral_DB_origin$DB))] <- "Yutin" #656

# Check for duplicated values
virus_duplicated <- viral_DB_origin[duplicated(viral_DB_origin$V1), "V1"]
deduplicated_viral_DB_origin <- viral_DB_origin[!duplicated(viral_DB_origin$V1), ]
deduplicated_viral_DB_origin$DB [which(deduplicated_viral_DB_origin$V1 %in% virus_duplicated)] <- "Guerin_Yutin"

# Save final with the 498,307 sequences used as input for STEP5 dereplication (including 5 NEGCONTROLS)
write.table(deduplicated_viral_DB_origin,"STEP5_input_sequences_DB_origin.txt", sep = "\t", 
            row.names = F, col.names = F, quote = FALSE)
