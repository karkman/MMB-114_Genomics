# Extra activities

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## Mapping reads to the contigs using BOWTIE

```bash
sinteractive
module load biokit

# Make new folder
cd $WRKDIR/MMB-114
mkdir mapping
cd mapping

# Make an indexed database from the contigs
bowtie2-build ../SPADES/contigs.fasta SPADES_db

# Map the reads to the indexed database
bowtie2 -p 4 -x SPADES_db -1 ../TRIMMED/R1_q20_m60.fastq -2 ../TRIMMED/R2_q20_m60.fastq -S SPADES_map.sam

# Convert SAM TO BAM
samtools view -F 4 -bS SPADES_map.sam > SPADES_map.bam

# Sort and index BAM
samtools sort SPADES_map.bam -o SPADES_map_sorted.bam
samtools index SPADES_map_sorted.bam
```

Transfer the files "SPADES_map_sorted.bam" and "SPADES_map_sorted.bam.bai" to your computer and open them in [TABLET](https://ics.hutton.ac.uk/tablet/).

## Browsing the genome annotation in RAST

* Go to http://rast.nmpdr.org/
* Login with User **guest** and Password **guest**
* Scroll down and locate Job **699550**
* Click on "view details"
