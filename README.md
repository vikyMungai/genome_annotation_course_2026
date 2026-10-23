# Genome annotation 
Genome annotation of the Arabidopsis thaliana assembly, which was performed during the "genome assembly" course at the Univeristy of Bern. 

## Project workflow 
1. [Retreive Flye and Trinity assembly](#1-retreive-data) 

### 1. Retreive data 
The assembly.fasta was downloaded from the previous repository. The assembly Flye was choosen, as it was the best across the three tools used: Flye, Hifiasm and LJA. 
```shell 
cp /data/users/vmungai/assembly-annotation-course2026/results/assembly/flye/assembly.fasta /data/users/vmungai/genome_annotation_course_2026/data/raw_data/assemblies/flye
```
The Trinity assembly was also downloaded from the same git repository. 
```shell 
cp /data/users/vmungai/assembly-annotation-course2026/results/assembly/trinity.Trinity.fasta /data/users/vmungai/genome_annotation_course_2026/data/raw_data/assemblies/trinity
```

The link to the repository, where the assembly where taken from: https://github.com/vikyMungai/assembly-annotation-course2026.git 


#### Script 08-run_maker.sh 
copy the files in WORKDIR:
```shell  
WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
DATA_DIR="${WORKDIR}/data/maker"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
mkdir -p "$DATA_DIR"
cp -r "${COURSEDIR}/tools/MAKER/control_files/" ${DATA_DIR}
```


I think this is not actually needed 
```shell 
cd /data/users/vmungai/assembly-annotation-course2026/data/raw_data/fastq_folder
ln -s /data/courses/assembly-annotation-course/raw_data/Ice-1 .
ln -s /data/courses/assembly-annotation-course/raw_data/RNAseq_Sha . 
```


# TODO: file that should be in the repo 
- genome_annotation_course_2026/output/EDTA/assembly.fasta.mod.EDTA.TEanno.sum
- genome_annotation_course_2026/output/TEsorter/Copia_sequences.fa.rexdb-plant.cls.tsv
- genome_annotation_course_2026/output/TEsorter/Gypsy_sequences.fa.rexdb-plant.cls.tsv

### Author 
Vittoria Mungai 
vittoria.mungai@students.unibe.ch
