# Variant annotation
# Functional annotation of variants was performed using Ensembl Variant Effect Predictor (VEP, release 111).

VEP_CACHE_DIR=/path/to/vep_cache
REFERENCE_FASTA=/path/to/Bos_taurus.ARS-UCD1.2.dna.toplevel.fa.gz

vep -i ${SAMPLE}.vcf.gz \
    -o ${SAMPLE}_annotation.vcf.gz \
    --vcf \
    --compress_output bgzip \
    --force_overwrite \
    --cache \
    --offline \
    --species bos_taurus \
    --assembly ARS-UCD1.2 \
    --dir_cache ${VEP_CACHE_DIR} \
    --fasta ${REFERENCE_FASTA} \
    --fork 8
