# Day 2: Read trimming

## Connecting to Taito

See the instructions [here](01-Linux-and-CSC.md#connecting-to-Taito).

## PART 1

### Downloading the raw genome data of our *Lactobacillus* strain

First let's create a folder for the course in our work directory **($WRKDIR)**:

```bash
cd $WRKDIR
mkdir MMB-114
cd MMB-114
```

Now let's create a folder for the raw genome data and copy them there from my CSC account **(remember: don't just copy the code, but don't write everything either; use the tabulator!)**:

```bash
mkdir RAW
cd RAW
cp /wrk/stelmach/SHARED/MMB-114/Hultman_kurssinayte_MiSeq-20190221R.tar.gz .
```

The raw genome data was given to us by the sequencing facility as a tar archive (**.tar.gz**). So the first thing we need to do is extract the archive:

```bash
tar -zxf Hultman_kurssinayte_MiSeq-20190221R.tar.gz
```

Investigate the contents of the folder. We can see that two GZIP files (**.gz**) were extracted from the tar archive (one for the R1 and the other for the R2 reads). GZIP is a compressed file much like a ZIP file, so to continue we have to uncompress them first. We will do this with the command **gunzip**:

```bash
gunzip A024-Lct2-CAACTATC-AAGACACC-Hultman-run20190221R_S24_L001_R1_001.fastq.gz
gunzip A024-Lct2-CAACTATC-AAGACACC-Hultman-run20190221R_S24_L001_R2_001.fastq.gz
```

Investigate the contents of the folder again. Do you see that the FASTQ files are now uncompressed?  

Now let's take a look at the FASTQ files to see how they look like:

```bash
# head
# tail
# less
# more
```

### Performing a quality assessment of the raw data

Now we will run a program called FASTQC for quality assessment of the raw genome data. The tasks we are performing from now on require more memory than simple commands. Running them on the login node would make the system slow, and if a task takes more than 30 minutes to complete, it is cancelled by the system. Instead, we have to connect to another node, called the Taito-shell:

```bash
sinteractive
```

**Load biokit:**

```bash
module load biokit
```

And now we run FASTQC:

```bash
cd $WRKDIR/MB-114/RAW

fastqc A024-Lct2-CAACTATC-AAGACACC-Hultman-run20190221R_S24_L001_R1_001.fastq
fastqc A024-Lct2-CAACTATC-AAGACACC-Hultman-run20190221R_S24_L001_R2_001.fastq
```

After both tasks are completed, we exit the Taito-shell by typing:

```bash
exit
```

One of the outputs of FASTQC is a HTML document. Let's look at it by moving it to your laptop with the file transfer program FileZilla. Remember to download the files for both the R1 and the R2 reads. In your computer, double-click to open them in your favourite web browser.  

Take a look at the FASTQC reports. How does the data look like?

* How many sequences are in R1? In R2?
* The "Per base sequence quality" module shows a problem. Why?
* Which part of the reads have the best quality? Beginning, middle, end?
* What is the mean sequence quality for the majority of the reads?
* The "Per base sequence content" module shows a problem. Why?
* The "Adapter content" module also shows a problem. Why?
* Are there adapters in our reads? In which part of the reads? What are adapters and why should we remove them?
* Do you see differences between the R1 and R2 reads?

To help you answering the questions above, you can read more about the FASTQC report [here](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/).

## PART 2

### Trimming adapters and low-quality regions

Now we will run a program called CUTADAPT to trim the reads of adapters and low-quality regions.

Connect to the Taito shell

```bash
sinteractive
```

**Load biokit:**

```bash
module load biokit
```

Let's create a new folder for the trimmed genome data:

```bash
cd $WRKDIR/MB-114
mkdir TRIMMED
cd TRIMMED
```

And now we run CUTADAPT. But first, take a moment to familiarize yourself the tool. Look at the command below and see which flags (**-LETTER**) we are passing to CUTADAPT (**DO NOT RUN**):

```bash
cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC
         -A CTGTCTCTTATACACATCTGACGCTGCCGACGA
         -o R1_q20_m60.fastq
         -p R2_q20_m60.fastq
         -q 20
         -m 60
```

Now let's take a look at the help page for CUTADAPT to understand what each of these flags are doing:

```bash
cutadapt -h | less

# You can scroll down by hitting "backspace".
# To quit, hit "q"
```

You can also read more about CUTADAPT [here](https://cutadapt.readthedocs.io/en/stable/guide.html).  

Now that we understand well what we are doing, let's run CUTADAPT. Pay attention as it is a long command **(you have to scroll to the right to see the full command)**:

```bash
cutadapt -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A CTGTCTCTTATACACATCTGACGCTGCCGACGA -o R1_q20_m60.fastq -p R2_q20_m60.fastq -q 20 -m 60 ../RAW/A024-Lct2-CAACTATC-AAGACACC-Hultman-run20190221R_S24_L001_R1_001.fastq ../RAW/A024-Lct2-CAACTATC-AAGACACC-Hultman-run20190221R_S24_L001_R2_001.fastq > log_cutadapt.txt
```

When CUTADAPT has finished, list the contents of the directory. Why do the names look so different from before? Also, take a look at the file "log_cutadapt.txt" with **less**. How many times adapters were trimmed in R1 and R2? How many reads were removed because they were too short? How many low-quality bases were trimmed?


Now let's run FASTQC again, this time using the trimmed genome data:

```bash
fastqc R1_q20_m60.fastq
fastqc R2_q20_m60.fastq
```

After both tasks are completed, we exit the Taito-shell:

```bash
exit
```

Move the HTML documents to your laptop with FileZilla and open them in a web browser. Compare these with the FASTQC reports for the raw genome data. What kind of differences you see?

* Do the "Per base sequence quality" plots look different now? Why?
* What is the mean sequence quality for the majority of the reads now?
* The "Sequence length distribution" module shows a warning now. Have the read lengths changed? Why?
* Are there still adapter sequences in our reads?
