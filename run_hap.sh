BAM_CHR1="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr1.bam"
BAM_CHR20="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr20.bam"
BAM_CHR21="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr21.bam"
TRUTH_VCF="${DATA_DIR}/HG001_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_PGandRTGphasetransfer_chrs_FIXED.vcf.gz"
TRUTH_BED="${DATA_DIR}/HG001_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_chr.bed"
REF="${DATA_DIR}/ucsc_hg19.fa"


sudo docker pull jmcdani20/hap.py:v0.3.12

time sudo docker run -it \
-v "${DATA_DIR}:${DATA_DIR}" \
-v "${OUTPUT_DIR}:${OUTPUT_DIR}" \
jmcdani20/hap.py:v0.3.12 /opt/hap.py/bin/hap.py \
  "${TRUTH_VCF}" \
  "${OUTPUT_DIR}/test_set.vcf.gz" \
  -f "${TRUTH_BED}" \
  -r "${REF}" \
  -o "${OUTPUT_DIR}/chr20-calling.happy.output" \
  -l chr20 \
  --engine=vcfeval \
  --pass-only