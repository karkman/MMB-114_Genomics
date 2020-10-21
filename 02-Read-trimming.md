# Day 2: Read trimming

## Connecting to Puhti

See the instructions [here](https://github.com/igorspp/MMB-114/blob/master/01-UNIX-and-CSC.md#connecting-to-puhti).

## PART 1

### Downloading the raw genome data

First let's create a folder for the course in the home directory. Your home directory is located in **/users/yourusername**. How to check that you are in the right place?

<details>
<summary>
HINT (CLICK TO EXPAND)
</summary>

> pwd

</details>  

---

If you are in your home directory, create the folder using:

```bash
mkdir MMB114
```

If you're not, you have to go there fist. The home directory can also be accessed using the shortcut **~** or the variable **$HOME**:

```bash
cd $HOME # or cd ~/MMB114

mkdir MMB114
```

And now let's enter this folder:

```bash
cd MMB114
```

Now let's copy the raw genome data from my folder **(remember: don't just copy the code, but don't type everything either; use the tabulator!)**:

```bash
cp /users/stelmach/MMB114/Lundell_MiSeq-20201016.tar.gz .
```

The raw genome data was given to us by the sequencing facility as a tar archive (**.tar.gz**). So the first thing we need to do is extract the archive:

```bash
tar -zxf Lundell_MiSeq-20201016.tar.gz
```

Investigate the contents of the folder. We can see that six GZIP files (**.gz**) were extracted from the tar archive (one for the R1 and one for the R2 reads of each genome). GZIP is a compressed file like a ZIP file, so to continue we have to decompress them first. We will do this with the command **gunzip**:

```bash
gunzip A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq.gz
gunzip A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R2_001.fastq.gz

gunzip A290-Suvi-ACAGACAT-TGCGAGTC-Taina-Lundell-run20201016R_S290_L001_R1_001.fastq.gz
gunzip A290-Suvi-ACAGACAT-TGCGAGTC-Taina-Lundell-run20201016R_S290_L001_R2_001.fastq.gz

gunzip A291-Alvar-2-CTTATGCT-TCCTGCCA-Taina-Lundell-run20201016R_S291_L001_R1_001.fastq.gz
gunzip A291-Alvar-2-CTTATGCT-TCCTGCCA-Taina-Lundell-run20201016R_S291_L001_R2_001.fastq.gz
```

Investigate the contents of the folder again. Do you see that the FASTQ files are now uncompressed? What has changed?  

Now let's take a look at the FASTQ files to see how they look like. Here we will use three useful commands for visualizing text files (**head**, **tail** and **less**):

```bash
head A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq
tail A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq
less A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq

# In less, scroll down by hitting the space bar
# To quit, hit "q"
```

### Performing a quality assessment of the raw data

Now we will run a program called FASTQC for quality assessment of the raw genome data. The tasks we are performing from now on require more memory than simple bash commands. Running them on the login node would make the system slow, and if a task takes more than 30 minutes to complete, it is killed automatically. Instead, we have to connect to another node, called the interactive partition:

```bash
sinteractive -A project_2001379
```

It might take a couple of seconds to minutes until the needed resources become available.  

The next step is to load the **biokit** environment, which is module in CSC containing several programs widely used in bioinformatics:

```bash
module load biokit
```
And now we run FASTQC, once for each FASTQ file:

```bash
fastqc A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq
fastqc A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R2_001.fastq
fastqc A290-Suvi-ACAGACAT-TGCGAGTC-Taina-Lundell-run20201016R_S290_L001_R1_001.fastq
fastqc A290-Suvi-ACAGACAT-TGCGAGTC-Taina-Lundell-run20201016R_S290_L001_R2_001.fastq
fastqc A291-Alvar-2-CTTATGCT-TCCTGCCA-Taina-Lundell-run20201016R_S291_L001_R1_001.fastq
fastqc A291-Alvar-2-CTTATGCT-TCCTGCCA-Taina-Lundell-run20201016R_S291_L001_R2_001.fastq
```

After all tasks are completed, we exit the interactive partition by typing:

```bash
exit
```

One of the outputs of FASTQC is a HTML document. Let's look at it by moving it to your laptop with the file transfer program FileZilla. Remember to download the HTML files for the R1 and the R2 reads of both genomes. In your computer, double-click to open them in your favourite web browser.  

Take a look at the FASTQC reports. How does the data look like?

* How many sequences we have for each genome? Are these numbers the same for the R1 and R2 files?
* The "Per base sequence quality" module shows a problem. Why?
  * Which part of the reads have the best quality? Beginning, middle, end?
* What is the mean sequence quality for the majority of the reads?
* The "Per base sequence content" module shows a problem. Why?
* The "Adapter content" module also shows a problem. Why?
  * Are there adapters in our reads?
  * In which part of the reads?
  * What are adapters and why should we remove them?
* Do you see differences between the R1 and R2 reads?

To help you answering the questions above, you can read more about the FASTQC report [here](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/).

## PART 2

### Trimming adapters and low-quality regions

Now we will run a program called CUTADAPT to trim the reads of adapters and low-quality regions. From now on we will work only with Antton's genome.

First, let's connect to the interactive partition and load **biokit**:

```bash
sinteractive -A project_2001379
module load biokit
```

And now we run CUTADAPT. But first, take a moment to familiarize yourself the tool. Look at the command below and see which flags (**-LETTER**) we are passing to CUTADAPT (**DO NOT RUN**):

```bash
cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC
         -A CTGTCTCTTATACACATCTGACGCTGCCGACGA
         -o Antton_R1_trimmed.fastq
         -p Antton_R2_trimmed.fastq
         -q 30
         -m 50
         A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq
         A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq
```

Now let's take a look at the help page for CUTADAPT to understand what each of these flags are doing:

```bash
cutadapt -h | less

# You can scroll down by hitting the space bar
# To quit, hit "q"
```

You can also read more about CUTADAPT [here](https://cutadapt.readthedocs.io/en/stable/guide.html).  

Now that we understand well what we are doing, let's run CUTADAPT. Pay attention as it is a long command **(you have to scroll to the right to see the full command)**:

```bash
cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A CTGTCTCTTATACACATCTGACGCTGCCGACGA -o Antton_R1_trimmed.fastq -p Antton_R2_trimmed.fastq -q 30 -m 50 A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R1_001.fastq A289-Antton-GAGGATAT-GGATGTAC-Taina-Lundell-run20201016R_S289_L001_R2_001.fastq > cutadapt_log.txt
```

When CUTADAPT has finished, list the contents of the directory. Which files have been created?

Now take a look at the file "cutadapt_log.txt" with the command **less**:

* How many times adapters were trimmed in R1 and R2?
* How many reads were removed because they were too short?
* How many low-quality bases were trimmed?

Now let's run FASTQC again, this time using the trimmed genome data:

```bash
fastqc Antton_R1_trimmed.fastq
fastqc Antton_R2_trimmed.fastq
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
