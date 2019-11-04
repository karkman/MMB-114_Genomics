# Day 5: Genome annotation

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## PART 1

### Annotating the genome using PROKKA

First we will annotate our genome using a program called PROKKA. Among other things, PROKKA uses a program called PRODIGAL to find genes and then annotates them using BLAST and HMMER. From now on we will work with the SPADES assembly only.  

Let's start by connecting to the Taito-shell, loading the biokit and PROKKA module, and navigating to the course folder:

```bash
sinteractive
module load biokit
module load prokka
cd $WRKDIR/MMB-114
```

Now let's run PROKKA:

```bash
prokka SPADES/contigs.fasta --outdir PROKKA --prefix PROKKA --cpus 4
```

Take a look inside the "PROKKA" folder using **ls**. To understand what are these files that PROKKA has created, take a look [here](https://github.com/tseemann/prokka#output-files).

Now take a look at the "PROKKA.txt" file using **less**. How many protein-coding genes (a.k.a coding sequences, CDSs) were found in each assembly? And how many rRNA genes/fragments?

## PART 2

### Annotating the contigs using KRAKEN

To check the taxonomy of the reads and the possible presence of contamination, we will annotate the contigs taxonomically using a program called KRAKEN.  

First we need to download and install KRAKEN:

```bash
cd $WRKDIR/MMB114

# Download the KRAKEN source code from GitHub
git clone https://github.com/DerrickWood/kraken.git

# Compile
cd kraken/

sh install_kraken.sh .

# Download and decompress the KRAKEN database
wget http://ccb.jhu.edu/software/kraken/dl/minikraken_20171019_4GB.tgz

tar zxf minikraken_20171019_4GB.tgz
```

Now let's run KRAKEN:

```bash
sinteractive
cd $WRKDIR/MMB114

kraken/kraken --preload --db kraken/minikraken_20171013_4GB SPADES/contigs.fasta --output kraken.txt --threads 4
kraken/kraken-translate --db kraken/minikraken_20171013_4GB kraken.txt > kraken_tax.txt
```

How many contigs (sequences) were classified?

Now let's see the taxonomy that was assigned to each contig in each of the assemblies:

```bash
awk -F ";" '{print $8}' kraken_tax.txt | sort | uniq -c
```

How many different genera the contigs were assigned to? What is the predominant genus? Does this agree with the expected taxonomy of our strain?

## PART 3

### Annotating the CDSs against the KEGG database

Now we will take the protein-coding genes found by PROKKA and annotate them further against the KEGG database using DIAMOND.  

Let's start by connecting to the Taito-shell and loading the biokit module. Here we need a specific version of biokit, so we need to specify it:

```bash
sinteractive
cd $WRKDIR/MMB114
module load biokit/4.9.3
```

Now let's copy the folder that contains the pre-formatted KEGG database:

```bash
cp -r /wrk/stelmach/MMB114/KEGG .
```

And now we run DIAMOND. Pay attention as it is a long command (you have to scroll to the right to see the full command):

```bash
diamond blastx --query PROKKA/PROKKA.ffn --out diamond.txt --db KEGG/PROKARYOTES --outfmt 6 --max-target-seqs 1 --max-hsps 1 --threads 4
```

Investigate the file "diamond.txt" using **less**. This is a typical BLAST table showing, among other things, the similarity between each of our CDSs to its best match in the KEGG database. For example, the second column shows the name of the KEGG sequence that our CDS matches to, and the third column shows the similarity between them.

The way that the name of the sequences are encoded in the KEGG database are not very informative. To get the actual gene names we will run a program called [KEGG-tools](https://github.com/igorspp/KEGG-tools) (written by yours truly). Tomorrow we will run KEGG-tools again to map the genes to the metabolic pathways they belong to, but for now let's just get the gene names:

```bash
KEGG/KEGG-tools assign.py -i diamond.txt -a KEGG
```

Look at the file "diamond_KOtable.txt" using **less**. Now we have got some proper gene names we can work with! Now let's join the PROKKA and KEGG annotations into one single file. Just copy and paste the code below (remember to scroll to the right to get the full command):

```bash
awk -F '\t' '{if ($2 == "CDS") {print}}' PROKKA/PROKKA.tsv | join -1 1 -2 1 -a 1 -t $'\t' - <(cut -f 1,4 diamond_KOtable.txt) > diamond_KEGG.txt
```

Now download the file "diamond_KEGG.txt" to your computer using FileZilla and open it in Excel. Scroll through the list and see:
* Which genes have been found? Do you see something interesting?
* Do the PROKKA and KEGG annotations agree with each other?
