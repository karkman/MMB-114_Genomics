# Day 5: Genome annotation

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Navigating to the  right folder

First things first.  
When you connect to Puhti, you will be in your home folder. You have all your course data in your own folder under the course projects `/scratch` folder. So by using commands like `csc-workspaces`, `cd`, `ls` and `pwd` make sure you are in the right folder before you start working.   
In Visual Studio Code you can use the `Explorer` tab to open the right folder. Again remember to add your actual username in place of `$USER`.

```bash
/scratch/project_2006616/$USER/MMB-114_Genomics
```

When your ready and can see your own course folder, you can move on. 

## Annotating the genome using Bakta

First we will annotate our genome using a program called [Bakta](https://github.com/oschwengers/bakta). Among other things, Bakta uses a program called PRODIGAL to find genes and then annotates them using several tools.s

Let's start by connecting to the interactive partition. Now we will need a little bit more memory than what we get as default, so we need to specify that (and let's also ask for some more CPUs):

```bash
sinteractive -A project_2006616 -m 10000 -c 4
```

Bakta is not found (yet) from Puhti, so I have installed it under the `Envs` folder on the course project folder.  
It also needs its own database files and that they can be found from the `DB` folder. 
We can also add some additional data about the strain to guide the annotation. So before running the annotation, we need to fill in some data or leave some options out. 

```bash
 /scratch/project_2006616/Envs/bakta/bin/bakta \
       results/SPADES/contigs.fasta \
       --db /scratch/project_2006616/DB/bakta/db/ \
       --prefix MMB114 \
       --gram \
       --genus \
       --locus MMB114 \
       --threads 4 \
       --output results/annotation
```

Take a look inside the output folder using **ls**. Or the `Explorer`. To understand what are these files that Bakta has created, take a look [here](https://github.com/oschwengers/bakta#output).

Now take a look at the `MMB114.tsv` file using **less**. How many protein-coding genes (a.k.a coding sequences, CDSs) were found? And how many rRNA genes/fragments?
Look for the 16S rRNA gene from the annotations. Can you locate it from the assembly? We will need this information later today. 

## Extracting KEGG annotations from Bakta output

Bakta also gives the KEGG IDs for different metabolic enzymes in our genome. To reconstruct metabolic pathways based on these annotations, we need to extract them from one the annotation files. 

```bash
grep -o "KEGG:K....." *.gff3 | tr ":" "\t" > MMB114_kegg_ids.txt 
```

Investigate the file `MMB114_kegg_ids.txt` using **less**. 
These are known as KO identifiers and is how we link genes to metabolic pathways in the KEGG database.  
This will allow us to put the gene annotations in the context of metabolic pathways.

## Visualising the annotations

We will use `IGV` to visualise the annotations and to extract genes for more exact taxonomic annotation.  
For this you need to download the `.fna` and `.gff3` files from bakta annotations folder to your own computer.  
We will go thru the steps in `IGV` together.  
