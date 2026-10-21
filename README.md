# Genome annotation 



## Project workflow 

### Retreive data 

#### Assemblies 

The assemblies created during the course of genome assembly are used. 
They were copied from the results folder of the other github to this one. 

The tool `Flye` was used for the assembly. 

#### Script 08-run_maker.sh 
copy the files in WORKDIR:
```shell  
WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
DATA_DIR="${WORKDIR}/data/maker"
COURSEDIR="/data/courses/genome_annotation_resources/2026"
mkdir -p "$DATA_DIR"
cp -r "${COURSEDIR}/tools/MAKER/control_files/" ${DATA_DIR}
```



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
