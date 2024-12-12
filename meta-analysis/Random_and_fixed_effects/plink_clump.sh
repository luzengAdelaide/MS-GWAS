# Uses PLINK clumping to extrat the lead SNPs

module load Plink/1.9.10
plink --bfile ~/1000_genome/eur.1kg_phase3_all --clump anno.METAANALYSIS1.TBL --clump-r2 0.1 --clump-kb 500 --out ms.eur.metal
