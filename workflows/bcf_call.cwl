cwlVersion: v1.2
class: Workflow
id: bcf_call
label: KFDRC NGS Checkmate Preprocess
doc: |-
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
  bcf_called_vcf: {type: File[], outputSource: bcf_filter/bcf_call}
requirements:
- class: ScatterFeatureRequirement
- class: MultipleInputFeatureRequirement

inputs:
  input_align: { type: 'File[]',
  secondaryFiles: [ { pattern: "^.crai", required: false }, { pattern: ".bai", required: false }, { pattern: "^.bai", required: false } ] }
  chr_list: { type: File, "sbg:suggestedValue": { class: File,
      path: 5f50018fe4b054958bc8d2e2, name: chr_list.txt } }
  reference_fasta: { type: File, "sbg:suggestedValue": { class: File,
      path: 60639014357c3a53540ca7a3, name: Homo_sapiens_assembly38.fasta } }
  reference_fai: { type: File, "sbg:suggestedValue": { class: File,
      path: 60639016357c3a53540ca7af, name: Homo_sapiens_assembly38.fasta.fai }}
  snp_bed: { type: File, "sbg:suggestedValue": { class: File,
      path: 5f50018fe4b054958bc8d2e4, name: SNP_hg38_liftover_wChr.bed } }

outputs:
  bcf_called_vcf: {type: 'File[]', outputSource: bcf_filter/bcf_call}

steps:
  bcf_filter:
    run: ../tools/bcf_filter.cwl
    in:
      input_align: input_align
      chr_list: chr_list
      reference_fasta:
        source: [reference_fasta, reference_fai]
        valueFrom: |
          ${
            var ref = self[0];
            ref.secondaryFiles = [self[1]];
            return ref;
          }
      snp_bed: snp_bed
    scatter: [input_align]
    out: [bcf_call]


$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: 'sbg:AWSInstanceType'
  value: c5.9xlarge;ebs-gp2;850
- class: 'sbg:maxNumberOfParallelInstances'
  value: 4
sbg:license: Apache License 2.0
sbg:publisher: KFDRC
sbg:categories:
- NGSCHECKMATE
- PREPROCESS
