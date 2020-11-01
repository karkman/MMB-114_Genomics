# Day 5: Genome annotation

## Connecting to Puhti

See the instructions [here](https://github.com/igorspp/MMB-114/blob/master/01-UNIX-and-CSC.md#connecting-to-puhti).

## Annotating the genome using PROKKA

First we will annotate our genome using a program called PROKKA. Among other things, PROKKA uses a program called PRODIGAL to find genes and then annotates them using BLAST and HMMER.  

Let's start by connecting to the interactive partition and configuring the PROKKA installation. Now we will need a little bit more memory than what we get as default, so we need to specify that:

```bash
sinteractive -A project_2001379 --mem 10000

export PROJAPPL=/projappl/project_2001379
module load bioconda
source activate prokka
```

Now let's run PROKKA:

```bash
prokka SPADES_ANTTON/contigs.fasta \
       --outdir PROKKA_ANTTON \
       --prefix ANTTON \
       --cpus 4
```

Take a look inside the "PROKKA_ANTTON" folder using **ls**. To understand what are these files that PROKKA has created, take a look [here](https://github.com/tseemann/prokka#output-files).

Now take a look at the "ANTTON.txt" file using **less**. How many protein-coding genes (a.k.a coding sequences, CDSs) were found ? And how many rRNA genes/fragments?

## Annotating the CDSs against the KEGG database

Now we will take the protein-coding genes found by PROKKA and annotate them further against the KEGG database using DIAMOND.  

Let's start by loading the biokit module:

```bash
module load biokit
```

And now we run DIAMOND (this will take some time, be patient):

```bash
diamond blastx --query PROKKA_ANTTON/ANTTON.ffn \
               --out KEGG_ANTTON.txt \
               --db /projappl/project_2001379/KEGG/PROKARYOTES \
               --outfmt 6 qseqid sseqid stitle pident qcovhsp evalue bitscore \
               --max-target-seqs 1 \
               --max-hsps 1 \
               --threads 4
```

Investigate the file "KEGG_ANTTON.txt" using **less**. This is a typical BLAST table showing, among other things, the similarity between each of our CDSs to its best match in the KEGG database. In our case, the columns are the following:

1. **qseqid:** query sequence id (i.e. the id of our gene)
2. **sseqid:** subject sequence id (i.e. the id of the gene in the database)
3. **stitle:** subject title (i.e. the title of the gene in the database)
4. **pident:** percentage of identical matches (i.e. how similar our gene is to the gene in the database)
5. **qcovhsp:** query coverage (i.e. how much of our gene aligns with the gene in the database)
6. **evalue:** expect value
7. **bitscore:** bit score

Don't know what the evalue and bit score mean? Take a look [here](https://sites.google.com/site/wiki4metagenomics/tools/blast/evalue).

Now copy the file "KEGG_ANTTON.txt" to your computer using FileZilla and open it on excel. Do the same for the file "ANTTON.tsv" from PROKKA and compare the annotations. Scroll through the lists and check:
* Which genes have been found? Do you see something interesting?
* What does "hypotethical protein" mean?
* Do the PROKKA and KEGG annotations agree with each other in general?
