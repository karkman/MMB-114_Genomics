# Day 3: Genome assembly

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## PART 1

### Submitting the genome assembly jobs

The first thing we will do is to launch the genome assembly jobs as they take some time to run. We will do this using the Taito batch job system. This is different from the Taito-shell in that jobs go to a queue and are executed when the required resources are available. We use the Taito batch system instead of the Taito-shell when we are running jobs which 1) take longer to run, so we can logout the system and come back when the job has finished; 2) require more resources than the Taito-shell provides (which is set at 4 cores and 128 GB of RAM).  

First, let's copy the SPADES batch script to your course folder:

```bash
cd $WRKDIR/MMB-114
cp /wrk/stelmach/SHARED/MMB-114/spades.sh .
```

Take a look at the script using **less**. This is how a batch script looks like. Don't worry about it now, we will go through it in detail later. For the moment let's submit the SPADES script to the batch job system:

```bash
sbatch spades.sh
```

Now let's copy the VELVET batch script to your course folder. In the code below, change "XX" to the kmer that was given to you:

```bash
cp /wrk/stelmach/SHARED/MMB-114/velvet_XX.sh .
```

And now we submit the VELVET script (remember to change "XX" again):

```bash
sbatch velvet_XX.sh
```

To see the status of our jobs, we can do:

```bash
squeue -l -u $USER
```

If the system has enough resources available, jobs will run as soon as they were submitted. If it doesn't, jobs will pend until the resources become available. Remember to write down the numbers that appear in the column "JOBID". We will need them later to check that the jobs have finished succesfully and to get information about the efficiency of the allocated resources.

## PART 2

### Evaluating the quality of the assemblies

First let's check if the assembly jobs have finished. Run the command twice after changing "JOBID" to each of the numbers you wrote down before:

```bash
seff JOBID
```

If it shows "State: COMPLETED (exit code 0)", then it means the job has finished succesfully without errors. Take a look also at the fields "CPU Efficiency" and "Memory Efficiency". Based on these values we can adjust our future scripts to allocate less resources. In Taito, the more resources you use the higher the costs to the project and potential waiting time in the queue.  

Now we will run a program called QUAST to evaluate the quality of the assemblies. We start by connecting to the Taito-shell and loading **biokit**:

```bash
sinteractive
module load biokit
```

Now let's make a new folder for QUAST and copy the assembled contigs from VELVET and SPADES there. Remember to change "XX" to the kmer that was given to you:

```bash
cd $WRKDIR/MMB-114
mkdir QUAST
cd QUAST

cp ../SPADES/contigs.fasta spades_contigs.fasta
cp ../VELVET_XX/contigs.fa velvet_contigs.fasta
```

And now let's run QUAST:

```bash
quast.py spades_contigs.fasta velvet_contigs.fasta -o . -t 4
```

When QUAST has finished, exit the Taito-shell and move the following files to your computer with FileZilla:

* report.html
* report.pdf
* icarus.html
* icarus_viewers (folder)

Open the file "report.html" in a web browser. How do assemblies look like?

*	More contigs?
*	Longer assembly?
*	Better N50?
*	Longer contigs?
* Which one would you choose?
