# ngs checkmate workflow

<p align="center">
  <a href="https://github.com/kids-first/ngs_checkmate_wf/blob/master/LICENSE"><img src="https://img.shields.io/github/license/kids-first/kf-template-repo.svg?style=for-the-badge"></a>
</p>

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
  
  snp_bed: File
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
