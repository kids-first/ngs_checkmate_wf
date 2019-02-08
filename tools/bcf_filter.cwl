cwlVersion: v1.0
class: CommandLineTool
id: bcf_filter
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/ngscheckmate:latest'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 24000

baseCommand: [cat]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.chr_list.path) |
      xargs -ICH -P 4
      sh -c
      'bcftools mpileup --output /dev/stdout --fasta-ref $(inputs.reference_fasta.path) -r CH -T $(inputs.snp_bed.path) $(inputs.input_align.path) > $(inputs.input_align.basename).pileup.vcf' &&
      find . -not -empty -name '*.pileup.vcf' > pileup_list.txt &&
      vcf-concat -f pileup_list.txt > $(inputs.input_align.basename).merged.vcf
      bcftools -c $(inputs.input_align.basename).merged.vcf > $(inputs.input_align.basename).bcf.called.vcf


inputs:
  input_align: File
  chr_list: File
  reference_fasta: File
  snp_bed: File

outputs:
  bcf_call:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.basename).bcf.called.vcf"


