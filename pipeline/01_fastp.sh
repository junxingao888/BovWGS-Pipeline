# Quality control of raw reads
## Quality filtering and preprocessing were performed using fastp (v0.23.4), including removal of low-quality reads (Phred quality < 30), trimming reads shorter than 36 bp, base correction, and duplicate removal.
fastp -i ${input_dir}/${SAMPLE}/1.fq.gz \
      -I ${input_dir}/${SAMPLE}/2.fq.gz \
      -o ${output_dir}/${SAMPLE}/${READS_1} \
      -O ${output_dir}/${SAMPLE}/${READS_2} \
      -q 30 -l 36 -c -D
