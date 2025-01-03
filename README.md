# MS-GWAS

Repository for MS GWAS v4.0 multi-ancestry meta-analysis efforts at the Center for Translational and Computational Neuroimmunology, Columbia University Irving Medical Center

## Abstract
Multiple Sclerosis (MS) is a chronic inflammatory and neurodegenerative disease affecting the brain and spinal cord. Genetic studies have identified many risk loci, that were thought to primarily impact immune cells and microglia. Here, we performed a multi-ancestry genome- wide association study with 20,831 MS and 729,220 control participants, identifying 236 susceptibility variants outside the Major Histocompatibility Complex, including four novel loci. We derived a polygenic score for MS and, optimized for European ancestry, it is informative for African-American and Latino participants. Integrating single-cell data from blood and brain tissue, we identified 76 genes affected by MS risk variants. Notably, while T cells showed the strongest enrichment, inhibitory neurons emerged as a key cell type, highlighting the importance of neuronal and glial dysfunction in MS susceptibility.

## Overview

1. [Meta-analysis](https://github.com/luzengAdelaide/MS-GWAS/tree/main/Meta-analysis)
   - [METAL](https://github.com/luzengAdelaide/MS-GWAS/tree/main/Meta-analysis/METAL_EUR): Performing a meta-analysis of European ancestry only using METAL.
    - [MR-MEGA](https://github.com/luzengAdelaide/MS-GWAS/tree/main/Meta-analysis/MR-MEGA): Performing a multi-ancestry meta-analysis using MR-MEGA v0.2.   
    - [Random and Fixed Effects](https://github.com/luzengAdelaide/MS-GWAS/tree/main/Meta-analysis/Random_and_fixed_effects): Performing multi-ancestry fixed and random effects meta-analyses using PLINK v1.9.   

2. [LDSC autoimmune](https://github.com/luzengAdelaide/MS-GWAS/tree/main/LDSC_autoimmune): Estimating genetic correlation from GWAS summary statistics, including MS susceptibility, MS severity,  other 12 autoimmune diseases, 4 neurodegenerative diseases, 4 psychiatric disorders, and 3 metabolic traits.

3. [COLOC analysis](https://github.com/luzengAdelaide/MS-GWAS/tree/main/COLOC_analysis): Performing genetic colocalisation analysis of eQTL and MS GWAS.  
    
 ## Software download
 1. METAL: https://github.com/statgen/METAL
 2. MR-MEGA: https://tools.gi.ut.ee/tools/MR-MEGA_v0.2.zip
 3. PLINK v1.9: https://www.cog-genomics.org/plink/
 4. LDSC: https://github.com/bulik/ldsc
 5. PRS: https://github.com/getian107/PRScsx
 