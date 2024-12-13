#!/bin/bash

#$-l h_vmem=10G
#$-t 17-19
#$-tc 3
#$-wd /home/lz2838/1000_genome
#$-N annotate_rsid

module load BCFTOOLS
chr=${SGE_TASK_ID}

# Download_grch37 rsid information
wget https://ftp.ncbi.nih.gov/snp/redesign/latest_release/VCF/GCF_000001405.25.gz
wget https://ftp.ncbi.nih.gov/snp/redesign/latest_release/VCF/GCF_000001405.25.gz.tbi

bcftools annotate --rename-chrs chrom-map.txt -Oz -o GCF_000001405.25.renamed.vcf.gz GCF_000001405.25.gz
~/tabix-0.2.6/tabix -p vcf GCF_000001405.25.renamed.vcf.gz

# Download 1000 Genomes Project phase 3, v5 reference
ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/

# annotate chr:pos with rsid
bcftools annotate -a GCF_000001405.25.renamed.vcf.gz -c ID,INFO -Ob -o rsid.1kb.chr${chr}.vcf ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz

