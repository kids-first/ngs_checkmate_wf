# BCF Filter Tool
Preprocessing workflow to use bcftools to subset bams and create a bcftools-called vcf

![data service logo](https://github.com/d3b-center/d3b-research-workflows/raw/master/doc/kfdrc-logo-sm.png)

## bcf_call.cwl

Creates input vcfs for ngs checkmate. Especially useful to run when inputs are large WGS bam files.

### inputs
```yaml
inputs:
  input_align: File[]
  chr_list: File
  reference_fasta: File
  snp_bed: File
```
Suggested inputs:
```text
chr_list: chr_list.txt
snp_bed: SNP_hg38_liftover_wChr.bed
reference_fasta: Homo_sapiens_assembly38.fasta
```
### outputs
```yaml
bcf_called_vcf: {type: File, outputSource: bcf_filter/bcf_call}