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
      'bcftools mpileup --output /dev/stdout --fasta-ref $(inputs.reference_fasta.path) -r CH -T $(inputs.snp_bed.path) $(inputs.input_align.path) > $(inputs.input_align.nameroot).CH.pileup.vcf' &&
      find . -not -empty -name '*.pileup.vcf' > pileup_list.txt &&
      vcf-concat -f pileup_list.txt > $(inputs.input_align.nameroot).merged.vcf &&
      bcftools call -c $(inputs.input_align.nameroot).merged.vcf > $(inputs.input_align.nameroot).bcf.called.vcf


inputs:
  input_align:
    type: File
    secondaryFiles: |
        ${
          if (inputs.input_align.nameext == '.cram'){
            return inputs.input_align.basename + '.crai';
          }
        else {
          return inputs.input_align.basename + '.bai';
        }
        }
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
