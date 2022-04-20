cwlVersion: v1.0
class: CommandLineTool
id: ngs_checkmate
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'pgc-images.sbgenomics.com/d3b-bixu/ngscheckmate:1.3'
  - class: InitialWorkDirRequirement
    listing: $(inputs.input_vcf)
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 2
    ramMin: $(inputs.ram)

baseCommand: [python]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      /NGSCheckMate/ncm.py
      -V
      -d ./
      -bed $(inputs.snp_bed.path)
      -O ./
      -N $(inputs.output_basename) &&
      mv output_corr_matrix.txt $(inputs.output_basename)_corr_matrix.txt

inputs:
  input_vcf:
    type: File[]
  snp_bed: File
  output_basename: string
  ram:
    type: ['null', int]
    default: 4000

outputs:
  match_results:
    type: File
    outputBinding:
      glob: "$(inputs.output_basename)_all.txt"

  correlation_matrix:
    type: File
    outputBinding:
      glob: "$(inputs.output_basename)_corr_matrix.txt "

