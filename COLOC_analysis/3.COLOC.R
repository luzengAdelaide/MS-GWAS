library(dplyr)
library(stringr)
library(coloc)
library(data.table)

args <- commandArgs(trailingOnly=TRUE)
celltype <- args[1]

# load GWAS summary stats of each risk SNP
gwas_window_dir <-  paste("~/project_msgwas/genetic/coloc/GWAS_1MB/")

# Load eQTL for each risk snp for each cell type
eqtl_window_dir <-  paste("~/project_msgwas/genetic/coloc/eQTL_1MB/", celltype, sep="")
pattern <- file.path(eqtl_window_dir, "rs*", "eQTL_*.txt")
eqtl_windows <- Sys.glob(pattern)

# apply COLOC function for eqtl and gwas, can use MAF or varbeta depends what provide from GWAS 
for(eqtl_window_file in eqtl_windows) {
  rsid = eqtl_window_file %>% dirname %>% basename
  eqtl_window <- fread(eqtl_window_file)
  
  gwas_window_file <- file.path(gwas_window_dir, str_c("GWAS_", rsid, ".txt"))
  gwas_window <- fread (gwas_window_file)
  
  df <- gwas_window %>%
    inner_join(eqtl_window, by = c("MarkerName" = "snps")) %>%
    mutate(my.MAF = ifelse(EAF < 0.5, EAF, 1 - EAF))
  
  dataset1 <- list(pvalues=df$P,N=df$Weight, snp=df$MarkerName, type="cc", s=0.5)
  
  df$varbeta <- (df$beta.y / df$statistic)^2
  df <- df %>% dplyr::filter(!is.na(varbeta))
  dataset2 <- list(beta=df$beta.y, varbeta=df$varbeta, snp=df$MarkerName, sdY=1, type="quant")

  res <- coloc.abf(dataset1, dataset2, MAF=df$my.MAF)
  
  # regular expression
  gene <- eqtl_window_file %>% basename %>% str_match("eQTL_(.+)\\.txt") %>% .[2]
  
  dir = "/mnt/mfs/ctcn/team/lu/project_msgwas/genetic/coloc/results"
  
  outfile <- sprintf("%s/%s.%s-%s.coloc.tsv", dir, celltype, rsid, gene)
  
  summary.df <- data.frame(
    key = names(res$summary),
    value = res$summary,
    row.names = NULL) %>%
    mutate(
      snp = rsid,
      gene = gene
    )
  
  fwrite(summary.df, file=outfile, sep = "\t")
}


