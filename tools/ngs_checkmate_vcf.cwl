cwlVersion: v1.0
class: CommandLineTool
id: ngs_checkmate
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'migbro/ngscheckmate:latest'
  - class: InitialWorkDirRequirement
    listing: $(inputs.input_vcf)
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 24000

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

outputs:
  match_reults:
    type: File
    outputBinding:
      glob: "$(inputs.output_basename)_all.txt"

  correlation_matrix:
    type: File
    outputBinding:
      glob: "$(inputs.output_basename)_corr_matrix.txt "

