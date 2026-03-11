# Variant filtering

#Variant filtering was performed using VCFtools (v0.1.16).
vcftools --gzvcf ${SAMPLE}.vcf.gz \
         --maf 0.05 \
         --min-meanDP 4 \
         --max-missing 0.95 \
         --recode --recode-INFO-all \
         --out ${SAMPLE}_filtered
