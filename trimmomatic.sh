for filename in *_R1_*.fastq.gz
do
# first, make the base by removing fastq.gz
  base=$(basename $filename .fastq.gz)
  echo $base

# now, construct the R2 filename by replacing R1 with R2
  baseR2=${base/_R1_/_R2_}
  echo $baseR2

# finally, run Trimmomatic
  TrimmomaticPE ${base}.fastq.gz ${baseR2}.fastq.gz \
    ${base}.qc.fq.gz s1_se \
    ${baseR2}.qc.fq.gz s2_se \
    ILLUMINACLIP:TruSeq3-PE.fa:2:40:15 \
    LEADING:2 TRAILING:2 \
    SLIDINGWINDOW:4:2 \
    MINLEN:25

# save the orphans
  gzip -9c s1_se s2_se >> orphans.qc.fq.gz
  rm -f s1_se s2_se
done
