cwlVersion: v1.2
class: CommandLineTool
id: bcf_filter
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'staphb/bedtools:2.31.0'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 4000

baseCommand: [bedtools, intersect, -wa]
arguments:
  - position: 0
    shellQuote: false
    valueFrom: >-
  - position: 1
    shellQuote: false
    valueFrom: >-
      > $(inputs.input_bed.nameroot)_$(inputs.filter_bed.nameroot).subset.bed

inputs:
  input_bed: { type: File, doc: "Bed file to subset", inputBinding: { position: 0, prefix: "-a"} }
  filter_bed: { type: File, doc: "Bed file to used to subset input_bed", inputBinding: { position: 0, prefix: "-b" } }

outputs:
  subset_bed:
    type: File
    outputBinding:
      glob: "*.subset.bed"
