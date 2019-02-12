cwlVersion: v1.0
class: CommandLineTool
id: rna_tx2genome_bam
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'images.sbgenomics.com/uros_sipetic/rsem:1.3.1'
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 16
    ramMin: 24000

baseCommand: [tar, -xzf]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      $(inputs.genomeDir.path) &&
      rsem-tbam2gbam
      $(inputs.input_bam.path)
      $(inputs.input_bam.nameroot).converted.bam
      -p 16 &&
      samtools index $(inputs.input_bam.nameroot).converted.bam $(inputs.input_bam.nameroot).converted.bai

inputs:
  input_bam: File
  genomeDir: File

outputs:
  bcf_call:
    type: File
    outputBinding:
      glob: "$(inputs.input_bam.nameroot).converted.bam"
    secondaryFiles: [^.bai]
