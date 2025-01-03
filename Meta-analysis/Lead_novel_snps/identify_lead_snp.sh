# Uses PLINK clumping to extract the lead SNPs

module load Plink/1.9.10
plink --bfile ~/1000_genome/eur.1kg_phase3_all --clump ms_eur_v4.0.sumstats --clump-r2 0.1 --clump-kb 500 --out ms.eur.metal

# remove known loci 
cut -f 1 known_loci.txt > use.known_loci.txt
sed -i 's/,/\n/g; /^rsid/d' use.known_loci.txt

while read -r value1 remainder
do
  awk '{print "sed -i " "\x27" "\/'$value1'\/d" "\x27" " ms.eur.metal.clumped"}' >> extract_lead.sh
done < use.known_loci.txt

bash extract_lead.sh
cut -f 3 ms.eur.metal.clumped > lead.ms.metal.txt

