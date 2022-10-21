# Day 3: Genome assembly

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Navigating to the  right folder

First things first.  
When you connect to Puhti, you will be in your home folder and you have all your course data in your own folder under the course projects `/scratch` folder. So by using commands like `csc-workspaces`, `cd`, `ls` and `pwd` make sure you are in the right folder before you start working. 
When you are in the right folder, by running `pwd`, you should get somnething like this,  where `$USER` is your own username. 

Use the `Explorer` tab to open the right folder. Again remeember to add your actual username in place of `$USER`.

```bash
/scratch/project_2006616/$USER/MMB-114_Genomics
```

When your ready and can see your own course folder, you can move on. 

## Submitting the genome assembly jobs

The first thing we will do is to launch the genome assembly job. We will do this using the batch job system. This is different from the interactive partition in that jobs go to a queue and are executed when the required resources are available. We use the batch system when we are running jobs which 1) take longer to run, so we can logout the system and come back when the job has finished; 2) require more resources than the interactive partition provides (which is set at 8 cores and 76 GB of RAM).  

The assembly batch job script can be found from the `Scripts` folder inside the course repository.  
Have a look at the content. Either by clicking it on the left tab.  
Or on the command line:

```bash
cd Scripts
cat spades.sh
cd ..
```

Now let's submit the Spades script to the batch job system. Make sure you're in the course repository main folder. 

```bash
sbatch Scripts/spades.sh
```

To see the status of our job, we can do:

```bash
squeue -l -u $USER
```

If the system has enough resources available, jobs will run as soon as they were submitted. If it doesn't, jobs will queue until the resources become available. Remember to write down the numbers that appear in the column "JOBID". We will need them later to check that the jobs have finished succesfully and to get information about the efficiency of the allocated resources.

Let's check if the assembly jobs have finished. Run the command after changing "JOBID" to the number you wrote down before:

```bash
seff JOBID
```

If it shows "State: COMPLETED (exit code 0)", then it means the job has finished succesfully without errors. Take a look also at the fields "CPU Efficiency" and "Memory Efficiency". Based on these values we can adjust our future scripts to allocate less resources. In Puhti, the more resources you use the higher the costs to the project and potential waiting time in the queue.  

After the assembly is ready, we can have a look at the output Spades printed for us. Also, if something went wrong, we can try to track the reason from the log files. 

Make sure there are some log files and that they are not both empty:
```bash
ls - l slurm_logs/
```

One will have the standard output and the other the standard error output. Neither is the assembly, they contain the information Spades prints normally to the screen when it runs. 

```bash
more slurm_logs/*out*
more slurm_logs/*err*
```

If all looks ok, we can move to the assembly QC.

## Evaluating the quality of the assemblies

Now we will run a program called QUAST to evaluate the quality of the assemblies. We start by connecting to the interactive partition and loading **biokit**:

```bash
sinteractive -A project_2006616
module load biokit
```

And now let's run QUAST:

```bash
quast.py results/SPADES/contigs.fasta -o results/QUAST
```

When QUAST has finished, you can close the interactive session with `exit` and download the following files from the QUAST output folder (`QUAST`). Right-click the files in the `Explorer` and click `Download...`.

* report.html
* report.pdf
* icarus.html
* icarus_viewers (folder)

Open the file "report.html" in a web browser. How does the assemblies look like?

* How many contigs?
* What is the longest contig?
* Total size of the assembly? Is this more or less in the ballpark of what you expected for these genomes?

## Assembly graphs

Spades also outputs soemthing called an assembly graph. It's a visual representation of the assembly.  
Download the file `*.gfa` and open it with `Bandage`.

We will go thru the steps together once the file is loaded in `Bandage`.

## OPTIONAL: Possible contamination and rough taxonomy using sourmash

We will use a program called [Sourmash](https://sourmash.readthedocs.io/en/latest/) to quickly search our assembly against the Genome Taxonomy Database ([GTDB](https://gtdb.ecogenomic.org/)). Sourmash uses k-mers and hash sketches (signatures in sourmash) to speed up the search and can be used for very large data sets (raw reads, metagenomes, ...). You can read more about sourmash and hash sketches by following the link.  
GTDB is a database and an effort to standardise microbial taxonomy based on genome information. We will use a pre-compiled version suitable for sourmash.   
Sourmash is not (yet) available in Puhti, so we will run it from a Singularity container. You don't need to worry about what Singularity containers are. In short and simplified, containers enable to pack all the needed software in a single file that can be used to run the program on e.g. Puhti.  
The Singularity container can be found from The `Env` folder and the GTDB database from `DB` folder. 

First we need to build a hash sketchs from our assembly. And we need an interactive session for that. 

```bash
sinteractive -A project_2006616 -m 10000 
```

Then the signature. 

```bash
singularity exec --bind $PWD:$PWD \
    /scratch/project_2006616//Envs/sourmash_4.4.0.sif \
    sourmash sketch dna \
    -p scaled=1000,k=31 \
    results/SPADES/contigs.fasta \
    -o results/MMB114.sig
```

When we have the signature, we can run a search against the database. 

```bash
singularity exec --bind $PWD:$PWD,/scratch/project_2006616/DB/sourmash:/db \
    /scratch/project_2006616//Envs/sourmash_4.4.0.sif \
     sourmash search \
     results/MMB114.sig \
     /db/gtdb-rs207.genomic-reps.dna.k31.zip \
     -n 20
```

You should get a list of possible matches in the database and how simialr they are.

The `search` command in sourmash finds only hits with high similarity in terms of shared kmers.  
You can also use another command `gather` in sourmash to look for more broadly marching signatures in the database. 

```bash
singularity exec --bind $PWD:$PWD,/scratch/project_2006616/DB/sourmash:/db \
    /scratch/project_2006616//Envs/sourmash_4.4.0.sif \
     sourmash gather \
     results/MMB114.sig \
     /db/gtdb-rs207.genomic-reps.dna.k31.zip \
     -n 20  \
     2> NULL
```

Some questions:
* Did you find a good match for our genome?
* Does it seem that there was contamination in the sequences? 
* What else could you do to find out which speciees our strain is?