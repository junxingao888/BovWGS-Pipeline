#!/bin/bash
#SBATCH --job-name=pop_structure
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --output=logs/pop_structure_%j.out
#SBATCH --error=logs/pop_structure_%j.err

set -euo pipefail

# ============================
# User settings
# ============================
file=240_afr_samples.vcf.gz
prefix=$(basename $file .vcf.gz)

THREADS=${SLURM_CPUS_PER_TASK}

module load plink/1.9
module load vcftools
module load admixture/1.3.0

echo "Starting population structure analysis"

# ============================
# 1. Convert VCF → PLINK
# ============================
echo "Step 1: VCF → PLINK"

plink \
  --vcf $file \
  --make-bed \
  --maf 0.01 \
  --geno 0.01 \
  --double-id \
  --allow-extra-chr \
  --chr-set 30 \
  --threads $THREADS \
  --out ${prefix}


# ============================
# 2. LD pruning
# ============================
echo "Step 2: LD pruning"

plink \
  --bfile ${prefix} \
  --indep-pairwise 50 10 0.2 \
  --allow-extra-chr \
  --chr-set 30 \
  --threads $THREADS \
  --out ${prefix}.pruned


# Extract pruned SNPs
plink \
  --bfile ${prefix} \
  --extract ${prefix}.pruned.prune.in \
  --make-bed \
  --allow-extra-chr \
  --chr-set 30 \
  --threads $THREADS \
  --out ${prefix}.LDpruned


# ============================
# 3. PCA
# ============================
echo "Step 3: PCA"

plink \
  --bfile ${prefix}.LDpruned \
  --pca 4 \
  --allow-extra-chr \
  --chr-set 30 \
  --threads $THREADS \
  --out ${prefix}.PCA

echo "PCA output: ${prefix}.PCA.eigenvec"


# ============================
# 4. Prepare for ADMIXTURE
# ============================
echo "Step 4: Prepare ADMIXTURE input"

awk '{ $1=0; print $0 }' ${prefix}.LDpruned.bim > tmp.bim
mv tmp.bim ${prefix}.LDpruned.bim


# ============================
# 5. ADMIXTURE (K=1..8)
# ============================
echo "Step 5: Running ADMIXTURE"

for K in {1..8}
do
    echo "Running ADMIXTURE for K=$K"

    admixture \
        --cv \
        -j$THREADS \
        ${prefix}.LDpruned.bed \
        $K | tee log${K}.out
done


# ============================
# 6. Extract CV error
# ============================
echo "Step 6: Extract CV errors"

grep -h CV log*.out > admixture_CV.txt

echo "Finished population structure analysis"

for K in {1..5}; do
    admixture --cv ${prefix}.LDpruned.bed $K | tee log${K}.out
done

grep CV log*.out > cv_summary.txt
