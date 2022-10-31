# Day 2: Read trimming

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Setting up the the course workspace

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

Now we are ready to move to the `/scratch` folder and make our working directory there. 
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

Then move to your own folder with `cd` and clone the course github repository in your own folder.  

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

If you feel lost, don't worry. Breathe, relax, think and check once more with `pwd`.   
You can always get to your home folder with typing only `cd` and pressing enter. 

Actually everyone can do that and well open the whole course folder to the `Explorer` tab in VS Code.  
When you are in your home folder, open the `Explorer`tab on the left and click `Open Folder`. 
Paste this path, but change `$USER` to your actual username. 

```
/scratch/project_2006616/$USER/MMB-114_Genomics
```

Now you should see the files and folders on the left. Also you terminal shoul dbe there as well.  
Let's continue from here. 

## The sequencing data

Next you will copy the sequence data to your own `Data` folder. So everyone will have their own copy. The sequencing data can be found from `Data` folder under the course `scratch` folder.   
List the content of our `Data` folder and only copy the R1 and R2 reads.    
The command `cp` will copy the files to a speficified location, so make sure you have the `.` at the end (`.` means "here").

```bash
cd Data
# list the files
ls /scratch/project_2006616/Data/
# copy one set of sequencing reads. Replace the names below and copy both R1 and R2 files. 
cp /scratch/project_2006616/Data/R1_FILE_NAME_HERE .
cp /scratch/project_2006616/Data/R2_FILE_NAME_HERE .
```

Now you can check what is in your `Data` folder.  
You should see two GZIP files (**.gz**), one for the R1 and one for the R2 reads of our genome. GZIP is a compressed file like a ZIP file.
And before the `.gz` you can see that they have another ending, `fastq`, this is a sequence file format that has in addition to the sequence also the sequence quality values (PHRED scores encoded as ASCII charaters).

Compressing sequence files with GZIP is advisable, since the files might be very big. And most bioinformatic software can handle compressed sequence files. But this time we'll decompress them just because we can. And because they are easier to view then. And anyways they are not that big in our case. And we will compress them again during trimming. 

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
fastqc  # R1_reads here
fastqc  # R2 reads here
```

After all tasks are completed, we exit the interactive partition by typing:

```bash
exit
```

One of the outputs of FASTQC is a HTML document. Let's look at it by moving it to your laptop. Yuo should see them on the left. Right-click it and select `Download ...`.  
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
First, let's connect to the interactive partition and load **biokit**:

```bash
sinteractive -A project_2006616
module load cutadapt/3.5
```

And now we run CUTADAPT. But first, take a moment to familiarize yourself the tool. Look at the command below and see which flags (**-LETTER**) we are passing to CUTADAPT (**DO NOT RUN**):

```bash
cutadapt -a CTGTCTCTTATACACATCT
         -A CTGTCTCTTATACACATCT
         -o MMB-114_trimmed_1.fastq.gz
         -p MMB-114_trimmed_2.fastq.gz
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
         -o MMB-114_trimmed_1.fastq.gz \
         -p MMB-114_trimmed_2.fastq.gz \
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
But first we need to unload the cutadapt module and reload biokit module

```bash
module purge
module load biokit
```

```bash
fastqc MMB-114_trimmed_1.fastq.gz 
fastqc MMB-114_trimmed_2.fastq.gz
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
