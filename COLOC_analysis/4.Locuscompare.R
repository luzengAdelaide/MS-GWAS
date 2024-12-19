# plot LocusZoom plots

library(locuscomparer)
library("data.table")

args <- commandArgs(trailingOnly=TRUE)
##############################################################
risk_snp= args[1]
gene= args[2]
celltype= args[3]
chr= args[4]

# load SNP positions
snppos <- fread("~/GRCh38.ALL.snppos", header=T)
snppos$pos2 = paste(snppos$chr, snppos$pos, sep=":")
# load ld score
ld = fread(paste("~/GRCh38ampad/ld_cal/tmp.chr", chr, ".ld", sep=""), sep="\t", header=T)
colnames(ld) = c("CHR_A", "BP_A", "SNP_A", "CHR_B", "BP_B", "SNP_B", "R2")

# read file
eqtl_snp = read.table(paste("~/project_msgwas/genetic/coloc/eQTL_1MB/", celltype, "/", risk_snp, "/eQTL_", gene, ".txt", sep=""), sep="\t", header=T)
gwas_snp = read.table(paste("~/project_msgwas/genetic/coloc/GWAS_1MB/GWAS_", risk_snp, ".txt", sep=""), sep="\t", header=T)

eqtl_snp$logp = -log10(eqtl_snp$pvalue)
eqtl_snp$pos2 = paste(eqtl_snp$chr, eqtl_snp$pos, sep=":")
use.eqtl_snp = eqtl_snp[, c("pos2", "pvalue", "logp")]
colnames(use.eqtl_snp) = c("rsid", "pval", "logp")

gwas_snp$logp = -log10(gwas_snp$P)
gwas_snp$pos2 = paste(gwas_snp$Chr_GRCh38, gwas_snp$Pos_GRCh38, sep=":")
gwas_snp$pos2 = paste("chr", gwas_snp$pos2, sep = "")
use.gwas_snp = gwas_snp[, c("pos2", "P", "logp")]
colnames(use.gwas_snp) = c("rsid", "pval", "logp")

tmp = merge(use.eqtl_snp, use.gwas_snp, by="rsid")
colnames(tmp) = c("rsid", "pval1", "logp1", "pval2", "logp2")

merged = merge(tmp, snppos, by.x="rsid", by.y="pos2")

use.eqtl_snp = merge(use.eqtl_snp, snppos, by.x="rsid", by.y="pos2")
use.gwas_snp = merge(use.gwas_snp, snppos, by.x="rsid", by.y="pos2")

# get lead snp
get_lead_snp = function(merged, snp = NULL){
  if (is.null(snp)) {
    snp = merged[which.min(merged$pval1 + merged$pval2), 'rsid']
  }
  else {
    if (!snp %in% merged$rsid) {
      stop(sprintf("%s not found in the intersection of in_fn1 and in_fn2.", snp))
    }
  }
  return(as.character(snp))
}
snp = get_lead_snp(merged)

# assign color
color = assign_color(merged$rsid, snp, ld)

# add label
add_label = function(merged, snp){
  merged$label = ifelse(merged$rsid %in% snp, merged$rsid, '')
  return(merged)
}
merged = add_label(merged, snp)
# plot figure
title1 = 'eQTL'
title2 = 'GWAS'

shape = ifelse(merged$rsid == snp, 23, 21)
names(shape) = merged$rsid
size = ifelse(merged$rsid == snp, 3, 2)
names(size) = merged$rsid

chr = unique(use.eqtl_snp$chr)
use.eqtl_snp = add_label(use.eqtl_snp, snp)
# assign color
color = assign_color(use.eqtl_snp$rsid, snp, ld)

chr = unique(use.gwas_snp$chr)
use.gwas_snp = add_label(use.gwas_snp, snp)
# assign color
color = assign_color(use.gwas_snp$rsid, snp, ld)
options(ggrepel.max.overlaps = Inf)

snp = "rs429358"
pdf(file = paste("coloc_eqtl_", gene, "_", risk_snp, "_", celltype, ".pdf", sep=""), width = 9.88, height = 5.20)
make_combined_plot(merged, 'eQTL', 'GWAS', ld, chr, snp)
dev.off()
