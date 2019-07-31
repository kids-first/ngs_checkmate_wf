# ngs checkmate workflow

## Introduction
Based on the tool from https://github.com/parklab/NGSCheckMate, "NGSCheckMate uses depth-dependent correlation models of allele fractions of known single-nucleotide polymorphisms (SNPs) to identify samples from the same individual." Contains preprocessing tools and workflows, as well as a workflow for batch processing.

## Workflows

### bcf_call.cwl
Creates input vcfs for ngs checkmate. Especially useful to run when inputs are large WGS bam files.

#### inputs
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
#### outputs
```yaml
bcf_called_vcf: {type: File, outputSource: bcf_filter/bcf_call}
```

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

## Tools:

### bcf_filter.cwl
Used by `bcf_call.cwl`, can take cram or bam as input.

#### inputs
```yaml
inputs:
  input_align:
    type: File
    secondaryFiles: |
        ${
          if (inputs.input_align.nameext == '.cram'){
            return inputs.input_align.basename + '.crai';
          }
        else {
          return inputs.input_align.nameroot + '.bai';
        }
        }
  chr_list: File
  reference_fasta:
    type: File
    secondaryFiles: ['.fai']
  snp_bed: File
```

#### outputs
```yaml
outputs:
  bcf_call:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.nameroot).bcf.called.vcf"
```

### ngs_checkmate_vcf.cwl
Takes an array of vcfs in which bams have been filtered using bcf tools and outupts match resutls and a correlation matrix.

#### inputs
```yaml
inputs:
  input_vcf:
    type: File[]
  snp_bed: File
  output_basename: string
  ram:
    type: ['null', int]
    default: 4000
```
#### outputs
```yaml
outputs:
  match_results:
    type: File
    outputBinding:
      glob: "$(inputs.output_basename)_all.txt"

  correlation_matrix:
    type: File
    outputBinding:
      glob: "$(inputs.output_basename)_corr_matrix.txt "
```

### rna_tx2genome.cwl
In the rare event that your input is a transcriptome bam, this will convert to the ncessary sorted genome bam.
### inputs
```yaml
inputs:
  input_bam: {type: File, doc: "Input transcriptome bam"}
  genomeDir: {type: File, doc: "rsem tar gzipped reference"}
```
### outputs
```yaml
outputs:
  genome_bam:
    type: File
    outputBinding:
      glob: "$(inputs.input_bam.nameroot).converted.bam"
    secondaryFiles: [^.bai]
```

### samtools_sort_index.cwl
In the event that your bam is not coord sorted, use this tool first
#### inputs
```yaml
inputs:
  input_align: File
```

#### outputs
```yaml
outputs:
  sorted_bam:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.nameroot).sorted.bam"
  sorted_bai:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.nameroot).sorted.bai"
```