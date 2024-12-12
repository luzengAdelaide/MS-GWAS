# Estimate heritability and genetic correlation from 24 GWAS summary statistics using LDSC
# For more information, please refer to the source code: https://github.com/bulik/ldsc

#!/bin/bash

#SBATCH --time=7-00:00 
#SBATCH --mem=30GB
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -J ldsc

arr=('ms.metal' 'ad.bellengues' 'ad' 'als' 'ftd' 'pd' 'iga' 'copd' 'ob' 'ps' 'ra.eu' 'sle' 't1d' 't2d' 'thyroiditis' 'ibd' 'cd' 'celiac' 'uc' 'bd' 'dd' 'neuro' 'scz' 'bmi' 'whradjbmi')

source activate ldsc

for arr in ${arr[@]}
do
    for arr2 in ${arr[@]}
    do
	echo $arr $arr2
        ~/ldsc/ldsc.py \
	    --ref-ld-chr ~/ldsc/eur_w_ld_chr/ \
	    --out $arr.$arr2 \
	    --rg $arr.sumstats.gz,$arr2.sumstats.gz \
	    --w-ld-chr ~/ldsc/eur_w_ld_chr/
    done
done


