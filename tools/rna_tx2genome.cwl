cwlVersion: v1.0
class: CommandLineTool
id: bcf_filter
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/uros_sipetic/rsem:1.3.1'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 16
    ramMin: 24000

baseCommand: [tar]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      -zxf $(inputs.genomeDir.path) &&
      rsem-tbam2gbam
      $(inputs.bam.path)
      $(inputs.bam.nameroot).converted.bam
      -p 16 &&
      samtools index $(inputs.bam.nameroot).converted.bam $(inputs.bam.nameroot).converted.bai

inputs:
  input_bam:
    type: File
  genomeDir: File

outputs:
  bcf_call:
    type: File
    outputBinding:
      glob: "$(inputs.bam.nameroot).converted.bam"
    secondaryFiles: [^.bai]
