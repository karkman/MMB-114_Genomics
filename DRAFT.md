# 04-03-19: Linux and CSC

## Basic UNIX commands

```bash
# 1_day1_handson.docx

1. First go to your home directory
cd
2. Check what is in the folder
ls
3. Make a folder (new directory) called KURSSI
mkdir KURSSI
4. GO to KURSSI folder
cd KURSSI
5.Check what is in the folder
ls

6.Make a textfile called myfile.txt
nano myfile.txt
write some text
Exit with ctrl-x and save


7. Check what is now in the folder
ls
8. go to home directory
cd .. OR cd
9. make a subdirectory KURSSI2
mkdir KURSSI2

10. copy myfile.txt to KURSSI2 and rename as mynewfile.txt
cp KURSSI/myfile.txt KURSSI2/mynewfile.txt

11. other way to copy: go to KURSSI2
cd KURSSI2
12. Copy myfile.txt from KURSSI . What does the . mean?
cp ../KURSSI/myfile.txt .

13. check where you are
pwd

14. remove myfile.txt
rm myfile.txt

15. go back one level
cd ..

16. remove directory KURSSI
rmdir KURSSI

17. Let’s get some data from NCBI: ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/, Choose your favorite bacteria
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Lactobacillus_reuteri/latest_assembly_versions/GCF_000010005.1_ASM1000v1/GCF_000010005.1_ASM1000v1_genomic.fna.gz

HELP e.g.

man gunzip
gunzip -h
```

## Downloading the genome data

Go to your work directory and make a new folder for the course:

```bash
cd /wrk/<yourCSCusername> #ALTERNATIVELY: cd $WRKDIR

mkdir MMB-114
```

Copy the FASTQ files to your course folder:

```bash
cp /wrk/stelmach/SHARED/MMB-114/***FILE*** MMB-114
```

Make a new folder for the raw data and move the FASTQ files there:

```bash
cd MMB-114

mkdir RAW_DATA

mv ***FILE*** RAW_DATA
```

Uncompress the FASTQ.gz files

```bash
gunzip ***FILE***
```



#####

18. Unzip the file
gunzip GCF_000010005.1_ASM1000v1_genomic.fna.gz

19. Is it unzipped?
ls

20. Let’s look how the sequence look like, what does less, more, tail print to the screen? exit with q

less GCF_000010005.1_ASM1000v1_genomic.fna
more GCF_000010005.1_ASM1000v1_genomic.fna
tail GCF_000010005.1_ASM1000v1_genomic.fna

21. How many contigs?
grep –c “>” GCF_000010005.1_ASM1000v1_genomic.fna

22. Search for certain characters, for example “TAA”
less GCF_000010005.1_ASM1000v1_genomic.fna

23. in the screen, type
/TAA enter
```

# 06-03-19: Genome trimming and assembly

```bash
# 2_day2_QC.docx

Quality control

1. open interactive node for computing
interactive

and go to your wrk directory
cd /wrk/yourcscusername

or

cd $WRKDIR

2. go to directory RAW
cd RAW
3. Load biokit module
module load biokit
4. Check how much you have used of your computing CPUs
quota
saldo

5.Check what is in the folder
ls

6. Run program called fastqc for quality assessment of the fastq-files
fastqc A083-R1-TAATAGCG-Hultman-gen-run20180309R_S83_L001_R1_001.fastq

fastqc A083-R1-TAATAGCG-Hultman-gen-run20180309R_S83_L001_R2_001.fastq

7. Output of FASTQC is a zip archive and an HTML document, lets look at the HTML document by moving it to your laptop with file transfer program WINSCP/Cyberduck

 View the HTML in web browser and discuss in pairs:
 Where is the best quality sequence? (Begin, middle, end?)
 Are there adapters?
 What are adapters? Why to remove?
 Differences in R1 and R2?
 Forward and reserve reads
 How many sequences are in R1? In R2?


8. Quality filtering with Cutadapt http://cutadapt.readthedocs.io/en/stable/
module load biopython-env

9. When looking at the cutadapt manual, which flags (=“-letter”) are for
 Length trimming	 	____
 3’ adapter 			____
 Paired end 3’adapter		____
 Quality score			____
 Output name			____
 Paired end output		____

 cutadapt -h

10. Run cutadapt. Write the command to one line, no line change (=enter)

cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A CTGTCTCTTATACACATCTGACGCTGCCGACGA –o R1_q20_m60.fastq –p R2_q20_m60.fastq -q 20 -m 60 A083-R1-TAATAGCG-Hultman-gen-run20180309R_S83_L001_R1_001.fastq.gz A083-R1-TAATAGCG-Hultman-gen-run20180309R_S83_L001_R2_001.fastq.gz > log_cutadapt.txt

11. Run fastqc for trimmed reads
fastqc R1_q20_m60.fastq
fastqc R2_q20_m60.fastq

12. Compare results to the untrimmed reads.  What kind of differences you see? How many reads remained?  Did the length change?  Quality curve?
```

# 07-03-19: Genome assembly

```bash
# 4_assembly.docx

Assembly

1. open interactive node for computing
sinteractive

and go to your wrk directory
cd /wrk/yourcscusername/KURSSI

or

cd $WRKDIR
cd KURSSI

2. Load biokit module
module load biokit
3. Check how much you have used of your computing CPUs
quota
saldo
4. Make directory for Velvet assembly
mkdir VELVET_ASSEMBLY
cd VELVET_ASSEMBLY
5. Combine R1 and R2 reads
shuffleSequences_fastq.pl ../TRIMMED/R1_q20_m60.fastq ../TRIMMED/R2_q20_m60.fastq R1_R2_shuffle.fastq
6. Check Velvet manual
velveth –h
7. Run velvet with kmer Jenni gave to you, my kmer is _____
mkdir KXX
velveth KXX XX -shortPaired –fastq R1_R2_shuffle.fastq
8. Run velvetg
velvetg KXX/ -cov_cutoff 50 -exp_cov 220 -ins_length 300 -min_contig_lgth 1000

# 3_assembly QC.docx

Assembly QC

1. First go to your wrk directory
cd /wrk/yourcscusername

or

cd $WRKDIR

2. go to directory KURSSI and make directory QUAST, go there
cd KURSSI
mkdir QUAST
cd QUAST

3. Run QUAST
/homeappl/home/cscusername/appl_taito/quast-4.0/quast.py spades_contigs.fasta velvet_contigs.fa

Move with winSCP to your computer
 report.pdf
 Icarus.html
 icarus_viewers/contig_size_viewer.html

Compare the assemblies:
•	More contigs?
•	Longer assembly?
•	Better N50?
•	More long contigs?
Which would you choose?

4. Check how much you have used of your computing CPUs
quota
saldo


ANNOTATION

5.change contig names in QUAST folder
awk '/^>/{print ">" ++i; next}{print}' < velvet_contigs.fa > velvet_short_contigs.fasta
awk '/^>/{print ">" ++i; next}{print}' < spades_contigs.fasta > spades_short_contigs.fasta

6. load following modules
module load biokit
module load bioperl
module load prokka

7. Run PROKKA

prokka velvet_contigs.fa
prokka spades_contigs.fa

View the gff-file with less
Move the gff-file to your computer
http://www.sanger.ac.uk/science/tools/artemis
–	Use the online tool to visualize the annotation
–	File -> open file manager
•	Go to where the gff is, open prokka.gff
–	3 panels: feature map (top), sequence (middle), feature list (bottom)
–	Click right-mouse-button on bottom panel and select Show products
–	Zoom
Feature list has information on the contigs
```

# 11-03-19: Annotation

```bash

```


```bash

```


```bash

```


```bash

```

```bash

```


```bash

```
