# Day 2: Read trimming

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Downloading the raw genome data

Let's make a new folder for the course, but this time in the `/scratch` folder for the course. But first, let's see where we are; how to do that?

<details>
<summary>
HINT (CLICK TO EXPAND)
</summary>

> pwd

</details>  

---

If you are in your home directory (**/users/yourusername**), then you're golden. Let's now check that the folder we created yesterday is still there; how to do that?

<details>
<summary>
HINT (CLICK TO EXPAND)
</summary>

> ls

</details>  

---

Now we are ready to move to the `/scratch´ folder and make a working directory there. 
To find the path to this folder we can first list all available projects with `csc-workspcases`.

```bash
csc-workspaces
```

Then look for the `/scratch` folder under the project `project_2006616 "MMB-114_Genomics"` and move there with `cd`. 

After that check once more where you are with `pwd`.  
If you are in the right folder, make a subfolder for yourself. Name it with your username (`$USER`).

```bash
mkdir $USER
```

Then move to your own folder with `cd` and clone the github repository under your own folder. 
```bash
cd $USER
git clone https://github.com/karkman/MMB-114_Genomics.git
```

Now you should have your own copy of the repository in Puhti.  
Next we make a folder for the raw sequencing data, copy the data (or actually make a link to it to avoid having multiple copies of the same files) and then we are ready to start working on it. 

```bash
cd MMB-114_Genomics
mkdir Data
```

Now let's copy the raw genome data from the main project's folder **(remember: don't just copy the code, but don't type everything either; use the tabulator!)**:

```bash
cd Data
ln -s /scratch/project_2006616/Data/* .
```

Now you can check what is in yourr `Data` folder. You should have links to two sequence files containing the R1 and R2 reads.

The raw genome data was given to us by the sequencing facility as a tar archive (**.tar.gz**). So the first thing we need to do is extract the archive:

```bash
tar -zxf Hultman_MiSeq-20211021.tar.gz
```

Investigate the contents of the folder. We can see that six GZIP files (**.gz**) were extracted from the tar archive (one for the R1 and one for the R2 reads of each genome). GZIP is a compressed file like a ZIP file, so to continue we have to decompress them first. We will do this with the command **gunzip**:

```bash
gunzip A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq.gz
gunzip A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R2_001.fastq.gz

gunzip A381-Lilith-TGCTTGAT-GTGACTGG-Hultman-run20211021R_S381_L001_R1_001.fastq.gz
gunzip A381-Lilith-TGCTTGAT-GTGACTGG-Hultman-run20211021R_S381_L001_R2_001.fastq.gz

gunzip A382-Salla-TAATAGCG-AGTAGGCT-Hultman-run20211021R_S382_L001_R1_001.fastq.gz
gunzip A382-Salla-TAATAGCG-AGTAGGCT-Hultman-run20211021R_S382_L001_R2_001.fastq.gz
```

Investigate the contents of the folder again. Do you see that the FASTQ files are now uncompressed? What has changed?  

Now let's take a look at the FASTQ files to see how they look like. Here we will use three useful commands for visualizing text files (**head**, **tail** and **less**):

```bash
head A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq
tail A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq
less A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq

# In less, scroll down by hitting the space bar
# To quit, hit "q"
```

## Performing a quality assessment of the raw data

Now we will run a program called FASTQC for quality assessment of the raw genome data. The tasks we are performing from now on require more memory than simple bash commands. Running them on the login node would make the system slow, and if a task takes more than 30 minutes to complete, it is killed automatically. Instead, we have to connect to another node, called the interactive partition:

```bash
sinteractive -A project_2006616
```

It might take a couple of seconds to minutes until the needed resources become available.  

The next step is to load the **biokit** environment, which is a module in CSC containing several programs widely used in bioinformatics:

```bash
module load biokit
```
And now we run FASTQC, once for each FASTQ file:

```bash
fastqc A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq
fastqc A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R2_001.fastq
fastqc A381-Lilith-TGCTTGAT-GTGACTGG-Hultman-run20211021R_S381_L001_R1_001.fastq
fastqc A381-Lilith-TGCTTGAT-GTGACTGG-Hultman-run20211021R_S381_L001_R2_001.fastq
fastqc A382-Salla-TAATAGCG-AGTAGGCT-Hultman-run20211021R_S382_L001_R1_001.fastq
fastqc A382-Salla-TAATAGCG-AGTAGGCT-Hultman-run20211021R_S382_L001_R2_001.fastq
```

After all tasks are completed, we exit the interactive partition by typing:

```bash
exit
```

One of the outputs of FASTQC is a HTML document. Let's look at it by moving it to your laptop with the file transfer program FileZilla. Remember to download the HTML files for the R1 and the R2 reads of all three genomes. In your computer, double-click to open them in your favourite web browser.  

Take a look at the FASTQC reports. How does the data look like?  
**(To help you answering the questions below, you can read more about the FASTQC report [here](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/))**

* How many sequences we have for each genome? Are these numbers the same for the R1 and R2 files?
* Is the length of the reads the same in the R1 and R2 files?
* The "Per base sequence quality" module shows a problem. Why?
  * Which part of the reads have the best quality? Beginning, middle, end?
* What is the mean sequence quality for the majority of the reads?
* The "Per base sequence content" module shows a problem. Why?
* The "Adapter content" module also shows a problem. Why?
  * Are there adapters in our reads?
  * In which part of the reads?
  * What are adapters and why should we remove them?
* Which of the three genomes has the best sequence quality?

## Trimming adapters and low-quality regions

Now we will run a program called CUTADAPT to trim the reads of adapters and low-quality regions. From now on we will work only with Antton's genome.

First, let's connect to the interactive partition and load **biokit**:

```bash
sinteractive -A project_2006616
module load biokit
```

And now we run CUTADAPT. But first, take a moment to familiarize yourself the tool. Look at the command below and see which flags (**-LETTER**) we are passing to CUTADAPT (**DO NOT RUN**):

```bash
cutadapt -a CTGTCTCTTATACACATCT
         -A CTGTCTCTTATACACATCT
         -o Matilda_R1_trimmed.fastq
         -p Matilda_R2_trimmed.fastq
         -q 30
         -m 50
         A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq
         A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R2_001.fastq
```

Now let's take a look at the help page for CUTADAPT to understand what each of these flags are doing:

```bash
cutadapt -h | less

# You can scroll down by hitting the space bar
# To quit, hit "q"
```

You can also read more about CUTADAPT [here](https://cutadapt.readthedocs.io/en/stable/guide.html).  

Now that we understand well what we are doing, let's run CUTADAPT. Pay attention as it is a long command. You can either type everything in one line or you can use the backslash (**\\**) to break it into several lines:

```bash
cutadapt -a CTGTCTCTTATACACATCT \
         -A CTGTCTCTTATACACATCT \
         -o Matilda_R1_trimmed.fastq \
         -p Matilda_R2_trimmed.fastq \
         -q 30 \
         -m 50 \
         A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R1_001.fastq \
         A380-Matilda-CTTATGCT-TCGGTAAT-Hultman-run20211021R_S380_L001_R2_001.fastq > cutadapt_log.txt
```

When CUTADAPT has finished, list the contents of the directory. Which files have been created?

Now take a look at the file "cutadapt_log.txt" with the command **less**:

* How many times adapters were trimmed in R1 and R2?
* How many reads were removed because they were too short?
* How many low-quality bases were trimmed?

Now let's run FASTQC again, this time using the trimmed genome data:

```bash
fastqc Matilda_R1_trimmed.fastq
fastqc Matilda_R1_trimmed.fastq
```

After both tasks are completed, we exit the interactive partition:

```bash
exit
```

Move the new HTML documents to your laptop with FileZilla and open them in a web browser. Compare these with the FASTQC reports for the raw genome data. What kind of differences you see?

* Do the "Per base sequence quality" plots look different now? Why?
* What is the mean sequence quality for the majority of the reads now?
* The "Sequence length distribution" module shows a warning now. Have the read lengths changed? Why?
* Are there still adapter sequences in our reads?

**Now, can you figure out how to run CUTADAPT and FASTQC for the other two geneomes?**
