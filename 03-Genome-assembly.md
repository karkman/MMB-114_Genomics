# Day 3: Genome assembly

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Submitting the genome assembly jobs

The first thing we will do is to launch the genome assembly jobs. We will do this using the batch job system. This is different from the interactive partition in that jobs go to a queue and are executed when the required resources are available. We use the batch system when we are running jobs which 1) take longer to run, so we can logout the system and come back when the job has finished; 2) require more resources than the interactive partition provides (which is set at 4 cores and 128 GB of RAM).  

First, let's copy the SPADES batch scripts to your course folder:

```bash
cd MMB114
cp /projappl/project_2001379/spades_Matilda.sh .
cp /projappl/project_2001379/spades_Lilith.sh .
cp /projappl/project_2001379/spades_Salla.sh .
```

Now let's submit the SPADES script to the batch job system:

```bash
sbatch spades_Matilda.sh
sbatch spades_Lilith.sh
sbatch spades_Salla.sh
```

To see the status of our job, we can do:

```bash
squeue -l -u $USER
```

If the system has enough resources available, jobs will run as soon as they were submitted. If it doesn't, jobs will pend until the resources become available. Remember to write down the numbers that appear in the column "JOBID". We will need them later to check that the jobs have finished succesfully and to get information about the efficiency of the allocated resources.

## Evaluating the quality of the assemblies

First let's check if the assembly jobs have finished. Run the command after changing "JOBID" to the number you wrote down before:

```bash
seff JOBID
```

If it shows "State: COMPLETED (exit code 0)", then it means the job has finished succesfully without errors. Take a look also at the fields "CPU Efficiency" and "Memory Efficiency". Based on these values we can adjust our future scripts to allocate less resources. In Puhti, the more resources you use the higher the costs to the project and potential waiting time in the queue.  

Now we will run a program called QUAST to evaluate the quality of the assemblies. We start by connecting to the interactive partition and loading **biokit**:

```bash
sinteractive -A project_2001379
module load biokit
```

And now let's run QUAST:

```bash
quast.py SPADES_MATILDA/contigs.fasta SPADES_LILITH/contigs.fasta SPADES_SALLA/contigs.fasta -o QUAST
```

When QUAST has finished, exit the interactive partition and move the following files to your computer with FileZilla:

* report.html
* report.pdf
* icarus.html
* icarus_viewers (folder)

Open the file "report.html" in a web browser. How does the assemblies look like?

* How many contigs?
* What is the longest contig?
* Total size of the assembly? Is this more or less in the ballpark of what you expected for these genomes?

