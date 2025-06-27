cwlVersion: v1.2
class: CommandLineTool
id: bcf_filter
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'pgc-images.sbgenomics.com/d3b-bixu/ngscheckmate:1.3'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 4000

baseCommand: [cat]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.chr_list.path) |
      xargs -Ichr_placeholder_108 -P 4
      sh -c
      'bcftools mpileup --output /dev/stdout --fasta-ref $(inputs.reference_fasta.path) -r chr_placeholder_108 -T $(inputs.snp_bed.path) $(inputs.input_align.path) > $(inputs.input_align.nameroot).chr_placeholder_108.pileup.vcf' &&
      find . -not -empty -name '*.pileup.vcf' > pileup_list.txt &&
      vcf-concat -f pileup_list.txt > $(inputs.input_align.nameroot).merged.vcf &&
      bcftools call -c $(inputs.input_align.nameroot).merged.vcf > $(inputs.input_align.nameroot).bcf.called.vcf


inputs:
  input_align:
    type: File
    secondaryFiles: [ { pattern: ".crai", required: false }, { pattern: ".bai", required: false }, { pattern: "^.bai", required: false } ]
  chr_list: File
  reference_fasta:
    type: File
    secondaryFiles: ['.fai']
  snp_bed: File

outputs:
  bcf_call:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.nameroot).bcf.called.vcf"
