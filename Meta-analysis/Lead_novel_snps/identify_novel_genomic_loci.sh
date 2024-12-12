# Search through metal, MR-MEGA and random effects meta-analyses for potentialy novel loci

METAL:
Rscript find_novel_loci.R -s ms_eur_v4.0.sumstats -p "P" -o metal.novel.csv -k known_loci.txt 

MR-MEGA:
Rscript find_novel_loci.R -s mrmega.result.fixedP -p "P.value_association" -o MRMEGA.result.fixedP.novel.csv -k known_loci.txt

Random effects
Rscript find_novel_loci.R -s multi-ancestry_PLINK.meta -c 'CHR' -l 'BP' -m 'SNP' -p '"P\(R\)"' -o multi-ancestry_PLINK.meta.novel.csv -k known_loci.txt
