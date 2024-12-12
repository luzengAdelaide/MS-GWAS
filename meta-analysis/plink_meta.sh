#!/bin/bash

# plink random effects for multi-ancestry

module load Plink/1.9.10
GWAS_FILES=$(ls ./{no.mhc.afr.ms.meta,no.mhc.amr.ms.meta,no.mhc.new.eur.ms.meta,no.mhc.imsgc.ms.summary}.txt.MAF_0.01.txt | paste -sd " ")

plink --meta-analysis $GWAS_FILES \
+ logscale study qt \
--out multi-ancestry_PLINK
