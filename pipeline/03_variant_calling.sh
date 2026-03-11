# Variant calling
# Variants were identified using FreeBayes (v1.3.1) followed by basic quality filtering.
freebayes -f ${REF} -L ${BAM_LIST} \
  --use-best-n-alleles 2 \
  --haplotype-length 0 \
  --ploidy 2 \
  --min-alternate-count 2 \
  --min-base-quality 10 \
  --min-alternate-fraction 0.2 \
  --genotype-qualities \
  | vcffilter -f 'QUAL > 20 & DP > 4' \
  | bgzip -c > ${SAMPLE}.vcf.gz

tabix -p vcf ${SAMPLE}.vcf.gz

#Variant statistics
# variant statistics were generated using vcfstats (v0.00.2019.07.10).
vcfstats --vcf ${SAMPLE}.vcf \
         --outdir ${SAMPLE}_stats \
         --formula "chromosome in ${REF}"

