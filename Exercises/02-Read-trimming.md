# Day 2: Read trimming

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Setting up the the course workspace

Let's make a new folder for the course, but this time in the `/scratch` folder for the course. But first, let's see where we are; how to do that?

<details><summary>HINT (CLICK TO EXPAND)</summary>pwd</details>  

If you are in your home directory (**/users/yourusername**), then you're golden. Let's now check that the folder we created yesterday is still there; how to do that?

<details><summary>HINT (CLICK TO EXPAND)</summary>ls</details>  

Now we are ready to move to the `/scratch` folder and make our working directory there.  
To find the path to this folder we can first list all available projects with `csc-workspcases`.

```bash
csc-workspaces
```

Then look for the `/scratch` folder under the project `MMB-114_Genomics` and move there with `cd`.  

After that check once more where you are with `pwd`.  
If you are in the right folder, make a subfolder for yourself. Name it with your username (`$USER`).

```bash
mkdir $USER
```

Then move to your own folder with `cd` and clone the course github repository in your own folder.  

```bash
cd $USER
git clone https://github.com/karkman/MMB-114_Genomics.git
```

Now you should have your own copy of the repository in Puhti.  
Next we make a folder for the raw sequencing data.  

```bash
cd MMB-114_Genomics
mkdir data
```

If you feel lost, don't worry. Breathe, relax, think and check once more with `pwd`.  
You can always get to your home folder with typing only `cd` and pressing enter.  

Actually everyone can do that and we'll open the whole course folder to the `Explorer` tab in VS Code.  
When you are in your home folder, open the `Explorer`tab on the left and click `Open Folder`.  
Paste this path, but change `$PROJECT` to the project code and `$USER` to your actual username.  

```bash
/scratch/$PROJECT/$USER/MMB-114_Genomics
```

Now you should see the files and folders on the left.  
When your ready and can see your own course folder, you can move on.  

To make things easier, we can assign the project number to an environmental variable. Otherwise you need to replace each `$PROJECT` in the commands.  

```bash
PROJECT="project_XXXXXXX"
echo $PROJECT
```

## The sequencing data

Next you will copy the sequence data to your own `data` folder. So everyone will have their own copy. The sequencing data can be found from `data` folder under the course `scratch` folder.  
List the content of our `Data` folder and only copy your own Nanopore reads (your own barcode). You can also copy the Illumina data, if you would like to analyse that as well. Choose one of the isolates.  
To keep things organised, we'll make separate folders for Nanopore and Illumina reads.  
The command `cp` will copy the files to a speficified location, so make sure you have the `.` at the end (`.` means "here").

```bash
cd data
# make folders for different data types
mkdir nanopore
mkdir illumina
# list the files
ls /scratch/$PROJECT/Data/nanopore
ls /scratch/$PROJECT/Data/illumina
# copy your own sequence file
cd nanopore
cp /scratch/$PROJECT/Data/nanopore/your_sequences .
cd ..
# copy one set of Illumina sequencing reads. Replace the names below and copy both R1 and R2 files. 
cd illumina
cp /scratch/$PROJECT/Data/illumina/R1_FILE_NAME_HERE .
cp /scratch/$PROJECT/Data/illumina/R2_FILE_NAME_HERE .
```

Now you can check what is in the folders inside your `data` folder.  
You should see GZIP files (**.gz**) in borth folders, one for your Nanopore reads and two for the Illumina (R1 & R2). GZIP is a compressed file like a ZIP file.
And before the `.gz` you can see that they have another ending, `fastq`, this is a sequence file format that has in addition to the sequence also the sequence quality values (PHRED scores encoded as ASCII charaters).

Uncompressing sequence files with GZIP is unnecessary, since the files might be very big and most bioinformatic software can handle compressed sequence files. But this time we'll decompress them just because we can. And because they are easier to view then. And anyways they are not that big in our case. And we will compress them again during trimming.  
Go to the nanopore folder and decompress the file.

```bash
gunzip # FILE_NAME_HERE
```

Now let's take a look at the FASTQ files to see how they look like. Here we will use three useful commands for visualizing text files (**head**, **tail** and **less**).

```bash
head # FILE_NAME_HERE
tail # FILE_NAME_HERE
less # FILE_NAME_HERE

# In less, scroll down by hitting the space bar
# To quit, hit "q"
```

## Quality control and trimming for Nanopore reads

The QC for the Nanopore reads can be done with NanoPlot and NanoQC. They are plotting tools for long read sequencing data and alignments. You can read more about them in: [NanoPlot](https://github.com/wdecoster/NanoPlot) and [NanoQC](https://github.com/wdecoster/nanoQC)

NanoPlot and NanoQC are not pre-installed to Puhti, but have been installed for the course using CSC software installation tool [Tykky](https://docs.csc.fi/computing/containers/tykky/).

Heavier computation should always be done at computing nodes on Puhti (you're on a login node when you connect). We need to allocate some resources from a computing node using the command `sinteractive`.  
It might take a couple of seconds to minutes until the needed resources become available.  

### Nanopore QC

```bash
sinteractive -A $PROJECT -m 20000
```

Now you're connected to a computing node in Puhti. The environmental variables are not inherited from the login node, so you should set the env variable for the project again.  
Or you can just type the project on each occassion where there is `$PROJECT` in the examples.  

```bash
PROJECT="project_XXXXXXXX"
echo $PROJECT
```

Generate graphs for visualizing read quality and length distribution
Make sure that your in the course folder (`/scratch/$PROJECT/$USER/MMB-114_Genomics`) before you run the command.  

```bash
/projappl/$PROJECT/nano_tools/bin/NanoPlot \
  -o nanoplot_out -f png --fastq path-to/your_raw_nanopore_reads.fastq
```

Transfer the nanoplot output folder to your computer and open the report `NanoPlot-report.html`

* How much sequencing data you have in base pairs?
* How many reads in total?
* How much of the data would be left if you would discard all reads that are below Q12?
* How does your quality distribution look like?
* And how about the length distribution?

Run the other QC program on your reads.  

```bash
/projappl/$PROJECT/nano_tools/bin/nanoQC -o nanoQC_out path-to/your_raw_nanopore_reads.fastq
```

Copy the resulting `nanoQC.html` file inside the ouput folder of nanoQC to your local computer and open it.  

* How is the quality at the beginning and at the end of the reads? How many bases would you cut from these regions?
* Can you estimate the GC % of your isolate? Does it match the GC % of the closest relatives?

### Trimming and quality filtering of reads

We'll use a program called [chopper](https://github.com/wdecoster/chopper) for quality filtering and trimming.  

The following command will trim the first 30 bases and the last 20 bases of each read, exclude reads with a phred score below 12 and exclude reads with less than 1000 bp. Depending on your own results, you should probably change these, so you won't end up discarding most of your reads.

```bash
mkdir trimmed_nanopore

cat path-to/your_raw_nanopore_reads.fastq |\
  /projappl/$PROJECT/nano_tools/bin/chopper -q 12 -l 1000 --headcrop 30 --tailcrop 20 |\
  gzip > trimmed_nanopore/nanopore.trimmed.fastq.gz
```

### Optional - Visualizing the trimmed data

```bash
/projappl/$PROJECT/nano_tools/bin/NanoPlot -o nanoplot_trimmed -f png --fastq trimmed_nanopore/nanopore.trimmed.fastq.gz
```

If everything looks ok, the sequence data is ready for assembly.  
We will assemble the genome on the next exercise session.  

## QC and trimming for Illumina reads (OPTIONAL)

Now we will run a program called FASTQC for quality assessment of the raw genome data. The tasks we are performing from now on require more memory than simple bash commands. Running them on the login node would make the system slow, and if a task takes more than 30 minutes to complete, it is killed automatically. Instead, we have to connect to another node, called the interactive partition:

```bash
sinteractive -A $PROJECT
```

The next step is to load the **biokit** module, which is a module in CSC containing several programs widely used in bioinformatics:

```bash
module load biokit
```

And now we run FASTQC, once for each FASTQ file:

```bash
fastqc  # R1_reads here
fastqc  # R2 reads here
```

One of the outputs of FASTQC is a HTML document. Let's look at it by moving it to your laptop. You should see them on the left. Right-click it and select `Download ...`.  
Remember to download the HTML files for both R1 and R2 reads. In your computer, double-click to open them in your favourite web browser.  

Take a look at the FASTQC reports. How does the data look like?  
**(To help you answering the questions below, you can read more about the FASTQC report [here](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/))**

* How many sequences we have for our genome? Are these numbers the same for the R1 and R2 files?
* Is the length of the reads the same in the R1 and R2 files?
* The "Per base sequence quality" module shows a problem. Why?
  * Which part of the reads have the best quality? Beginning, middle, end?
* What is the mean sequence quality for the majority of the reads?
* The "Per base sequence content" module shows a problem. Why?
* The "Adapter content" module also shows a problem. Why?
  * Are there adapters in our reads?
  * In which part of the reads?
  * What are adapters and why should we remove them?

## Trimming adapters and low-quality regions

Now we will run a program called CUTADAPT to trim the reads of adapters and low-quality regions.  
First, let's connect to the interactive partition and load the **cutadapt** module:

```bash
module purge
module load cutadapt/3.5
```

Then make folder for trimmed data.  

```bash
mkdir trimmed_illumina
```

And now we run CUTADAPT. But first, take a moment to familiarize yourself the tool. Look at the command below and see which flags (**-LETTER**) we are passing to CUTADAPT (**DO NOT RUN**):

```bash
cutadapt -a CTGTCTCTTATACACATCT
         -A CTGTCTCTTATACACATCT
         -o trimmed_illumina/MMB-114_trimmed_1.fastq.gz
         -p trimmed_illumina/MMB-114_trimmed_2.fastq.gz
         -m 50
         # R1_reads here
         # R2_reads here
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
         -o trimmed_illumina/MMB-114_trimmed_1.fastq.gz \
         -p trimmed_illumina/MMB-114_trimmed_2.fastq.gz \
         -m 50 \
         # R1_reads \
         # R2_reads \
         > cutadapt_log.txt
```

When CUTADAPT has finished, list the contents of the directory. Which files have been created?

Now take a look at the file "cutadapt_log.txt" with the command **less**:

* How many times adapters were trimmed in R1 and R2?
* How many reads were removed because they were too short?
* How many low-quality bases were trimmed?

Now let's run FASTQC again, this time using the trimmed genome data:
But first we need to unload the cutadapt module (`module purge`) and reload biokit module.  

```bash
module purge
module load biokit
```

And then run FASTQC on the trimmed sequence data.

```bash
fastqc trimmed_illumina/MMB-114_trimmed_1.fastq.gz 
fastqc trimmed_illumina/MMB-114_trimmed_2.fastq.gz
```

After both tasks are completed, we exit the interactive partition:

```bash
exit
```

Move the new HTML documents to your laptop and open them in a web browser. Compare these with the FASTQC reports for the raw genome data. What kind of differences you see?

* Do the "Per base sequence quality" plots look different now? Why?
* What is the mean sequence quality for the majority of the reads now?
* The "Sequence length distribution" module shows a warning now. Have the read lengths changed? Why?
* Are there still adapter sequences in our reads?

If everything looks ok, the sequence data is ready for assembly.  
We will assemble the genome on the next exercise session.  
