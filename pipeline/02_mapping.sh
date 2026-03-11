# Read mapping
# Reads were aligned to the Bos taurus reference genome (ARS-UCD1.2) using BWA-MEM2 (v2.2.1).
bwa-mem2 index ${REF}
bwa-mem2 mem ${REF} ${READS_1} ${READS_2} > ${SAMPLE}.sam

# Duplicate marking
#Duplicate reads were identified and marked using Samblaster (v0.1.26).
samblaster -r -i ${SAMPLE}.sam

# BAM processing
#Sorting and indexing of alignment files were performed using Samtools (v1.14).
samtools sort -m 16G -@ ${CPUS} -O bam ${SAMPLE}.sam > ${SAMPLE}.bam
samtools index -@ ${CPUS} ${SAMPLE}.bam

# Mapping quality assessment
# Mapping quality and coverage statistics were evaluated using Qualimap (v2.2.1).
unset DISPLAY && qualimap bamqc \
      -bam ${SAMPLE}.bam \
      --java-mem-size=8G \
      -nt ${CPUS} \
      -outdir ${SAMPLE}_qc

