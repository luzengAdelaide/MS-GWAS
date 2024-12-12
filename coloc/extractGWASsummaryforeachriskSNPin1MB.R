library(dplyr)
library(data.table)
library(stringr)

# extract MR-MEGA results
# load MS risk SNPs
risk_snps <- read.table("~/project_msgwas/genetic/coloc/GRCh38_ms-all_RiskSNP.txt", header=T)
# extract necessary columns
risk_snps <- risk_snps[, c("SNP_ID", "Chr_GRCh38", "Pos_GRCh38")]

# load GWAS summary statistics
GWAS = fread("~/project_msgwas/meta-analysis/anno.METAANALYSIS1.TBL")
GWAS <- as.data.frame(GWAS)

# calculate beta and SE from Z score and p-value
GWAS$beta = GWAS$Zscore/sqrt(2*GWAS$EAF*(1-GWAS$EAF)*(GWAS$Weight+GWAS$Zscore^2))
GWAS$se = 1/sqrt(2*GWAS$EAF*(1-GWAS$EAF)*(GWAS$Weight+GWAS$Zscore^2))

# output directory
outdir <- "~/project_msgwas/genetic/coloc/GWAS_1MB"
dir.create(outdir, recursive = T)

################################################################################
## extract GWAS summary stats for each risk SNP in 1MB

window_size <- 1e+6
#window_size <- 10000

risk_snps$Position_38 <- risk_snps$Pos_GRCh38


for(i in 1:nrow(risk_snps)){
  risk_snp <- risk_snps[i, ]
  
  risk_snp$Position_38 <-  as.numeric(risk_snp$Position_38)
  #risk_snp$Chr_GRCh38 <- as.numeric(risk_snp$Chr_GRCh38)
  
  start_pos_in_GRCh38 <- risk_snp$Position_38 - window_size
  end_pos_in_GRCh38 <- risk_snp$Position_38 + window_size
  
  # extract GWAS summary stats around the risk SNP
  region <- GWAS %>%
    dplyr::filter(
      CHR == risk_snp$Chr_GRCh38,
      start_pos_in_GRCh38 < BP,
      BP < end_pos_in_GRCh38
    )
  
  # export the extracted stats
  outfile <- sprintf("GWAS_%s.txt", risk_snp$SNP_ID)
  outpath <- file.path(outdir, outfile)
  write.table(region, file = outpath, sep = "\t",
              row.names = FALSE, col.names = TRUE, quote=FALSE)
  
}

