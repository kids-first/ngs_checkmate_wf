cwlVersion: v1.0
class: CommandLineTool
id: samtools_sort_index_bam
doc: Utility to sort and index a genome file
requirements:
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'kfdrc/samtools:1.9'
  - class: ResourceRequirement
    coresMin: 16

baseCommand: [samtools, sort]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -@ 16 -m 1G
      $(inputs.input_align.path)
      > $(inputs.input_align.nameroot).sorted.bam &&
      samtools index
      -@ 16 $(inputs.input_align.nameroot).sorted.bam
      $(inputs.input_align.nameroot).sorted.bai

inputs:
  input_align: File

outputs:
  sorted_bam:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.nameroot).sorted.bam"
  sorted_bai:
    type: File
    outputBinding:
      glob: "$(inputs.input_align.nameroot).sorted.bai"

