# Read mapping
# Reads were aligned to the Bos taurus reference genome (ARS-UCD1.2) using BWA-MEM2 (v2.2.1).
bwa-mem2 index ${REF}

bwa-mem2 mem ${REF} ${READS_1} ${READS_2} > ${SAMPLE}.sam
