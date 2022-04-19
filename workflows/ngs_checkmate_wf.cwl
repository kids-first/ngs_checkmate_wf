cwlVersion: v1.0
class: Workflow
id: ngs_checkmate_wf
label: KFDRC NGSCHECKMATE Sample QC
doc: |
  # ngs checkmate workflow

  ## Introduction
  Based on the tool from https://github.com/parklab/NGSCheckMate, "NGSCheckMate uses depth-dependent correlation models of allele fractions of known single-nucleotide polymorphisms (SNPs) to identify samples from the same individual." 

  ![data service logo](https://github.com/d3b-center/d3b-research-workflows/raw/master/doc/kfdrc-logo-sm.png)

  ### ngs_checkmate_wf.cwl
  Runs ngscheckmate in vcf mode - requires output from bcf_call step.

  #### inputs
  ```yaml
  inputs:
    input_vcf:
      type:
          type: array
          items:
              type: array
              items: File
    
    snp_bed: { type: File, "sbg:suggestedValue": { class: File,
      path: 5f50018fe4b054958bc8d2e4, name: SNP_hg38_liftover_wChr.bed } }
    output_basename: string[]
    ram: 
      type: ['null', int]
      default: 4000
  ```
  1) Ram input param optional - use if you plan on batching ~20+ vcfs.
  2) `input_vcf` is an array of arrays - basically an array of groups of vcfs that you'd like ot see evaluated together.
  3) `output_basename` is an array of file output prefixes - should line up with the first level of array elements from `input_vcf`

  #### outputs
  ```yaml
  outputs:
    match_results: {type: 'File[]', outputSource: ngs_checkmate/match_results}
    correlation_matrix: {type: 'File[]', outputSource: ngs_checkmate/correlation_matrix}
  ```
requirements:
- class: ScatterFeatureRequirement
- class: MultipleInputFeatureRequirement

inputs:
  input_vcf:
    type:
      type: array
      items:
        type: array
        items: File

  snp_bed: File
  output_basename: string[]
  ram:
    type: ['null', int]
    default: 4000

outputs:
  match_results: {type: 'File[]', outputSource: ngs_checkmate/match_results}
  correlation_matrix: {type: 'File[]', outputSource: ngs_checkmate/correlation_matrix}

steps:
  ngs_checkmate:
    run: ../tools/ngs_checkmate_vcf.cwl
    in:
      input_vcf: input_vcf
      snp_bed: snp_bed
      output_basename: output_basename
      ram: ram
    scatter:
    - input_vcf
    - output_basename
    scatterMethod: dotproduct
    out: [match_results, correlation_matrix]

$namespaces:
  sbg: https://sevenbridges.com
hints:
- class: 'sbg:AWSInstanceType'
  value: c5.9xlarge;ebs-gp2;400
- class: 'sbg:maxNumberOfParallelInstances'
  value: 4
"sbg:license": Apache License 2.0
"sbg:publisher": KFDRC
"sbg:categories":
- NGSCHECKMATE
- QC
"sbg:links":
- id: 'https://github.com/kids-first/ngs_checkmate_wf/releases/tag/v1.0.0'
  label: github-release
