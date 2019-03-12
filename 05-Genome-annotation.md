# Day 5: Genome annotation

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## PART 1

### Annotating the genome using PROKKA

First we will annotate our genome using a program called PROKKA. Among other things, PROKKA uses a program called PRODIGAL to find genes and then annotates them using BLAST and HMMER. We will run PROKKA on both the SPADES and VELVET assemblies for comparison.  

Let's start by connecting to the Taito-shell and loading the biokit and PROKKA modules:

```bash
sinteractive
module load biokit
module load prokka
```

Now let's run PROKKA (remember to change "XX" to the kmer that was given to you):

```bash
cd "$WRKDIR"/MMB-114

prokka SPADES/contigs.fasta --outdir PROKKA_SPADES --prefix "SPADES" --cpus 4
prokka VELVET_XX/contigs.fa --outdir PROKKA_VELVET --prefix "VELVET" --cpus 4

# If PROKKA gives an error about contig names you might want to add this to the command:
--centre X --compliant
```

Take a look inside the "PROKKA_SPADES" and "PROKKA_VELVET" folders using **ls**. To understand what are these files that PROKKA has created, take a look [here](https://github.com/tseemann/prokka#output-files).

Now take a look at the "SPADES.txt" and "VELVET.txt" files using **less**. How many protein-coding genes (a.k.a coding sequences, CDSs) were found in each assembly? And how many rRNA genes/fragments?

## PART 2

### Annotating the contigs using KRAKEN

To check the taxonomy of the reads and the possible presence of contamination, we will annotate the contigs taxonomically using a program called KRAKEN.  

First we need to download and install KRAKEN:

```bash
cd "$WRKDIR"/MMB-114

# Download the KRAKEN source code from GitHub
git clone https://github.com/DerrickWood/kraken.git

# Compile
cd kraken/

sh install_kraken.sh .

# Download and decompress the KRAKEN database
wget http://ccb.jhu.edu/software/kraken/dl/minikraken_20171019_4GB.tgz

tar zxf minikraken_20171019_4GB.tgz

rm -f minikraken_20171019_4GB.tgz
```

Now let's run KRAKEN (remember to change "XX" to the kmer that was given to you):

```bash
sinteractive
cd "$WRKDIR"/MMB-114

kraken/kraken --preload --db kraken/minikraken_20171013_4GB SPADES/contigs.fasta --output SPADES_kraken.txt --threads 4
kraken/kraken-translate --db kraken/minikraken_20171013_4GB SPADES_kraken.txt > SPADES_kraken_tax.txt

kraken/kraken --preload --db kraken/minikraken_20171013_4GB VELVET_XX/contigs.fa --output VELVET_XX_kraken.txt --threads 4
kraken/kraken-translate --db kraken/minikraken_20171013_4GB VELVET_XX_kraken.txt > VELVET_XX_kraken_tax.txt
```

How many contigs were classified in each of the assemblies?

Now let's see the taxonomy that was assigned to each contig in each of the assemblies:

```bash
awk -F ";" '{print $10}' SPADES_kraken_tax.txt | sort | uniq -c
awk -F ";" '{print $10}' VELVET_XX_kraken_tax.txt | sort | uniq -c
```
How many different species the contigs were assigned to in each of the assemblies? What is the predominant species? Does this agree with the expected taxonomy of our strain?

## PART 3

### Annotating the CDSs against the KEGG database

Now we will take the protein-coding genes found by PROKKA and annotate them further against the KEGG database using DIAMOND. From now on we will work only with the SPADES assembly, as the VELVET one seems to be very problematic.  

Let's start by connecting to the Taito-shell and loading the biokit module. Here we need a specific version of biokit, so we need to specify it:

```bash
sinteractive
module load biokit/4.9.3
```

Now let's copy the folder that contains the pre-formatted KEGG database:

```bash
cd "$WRKDIR"/MMB-114

cp -r /wrk/stelmach/SHARED/MMB-114/KEGG .
```

And now we run DIAMOND. Pay attention as it is a long command (you have to scroll to the right to see the full command):

```bash
diamond blastx --query PROKKA_SPADES/SPADES.ffn --out SPADES_diamond.txt --db KEGG/KEGGdb --outfmt 6 --max-target-seqs 1 --max-hsps 1 --threads 4
```

Investigate the file "SPADES_diamond.txt" using **less**. This is a typical BLAST table showing, among other things, the similarity between each of our CDSs to its best match in the KEGG database. For example, the second column shows the name of the KEGG sequence that our CDS matches to, and the third column shows the similarity between them.

The way that the name of the sequences are encoded in the KEGG database are not very informative. To get the actual gene names we will run a program called [KEGG-tools](https://github.com/igorspp/KEGG-tools) (written by yours truly). Tomorrow we will run KEGG-tools again to map the genes to the metabolic pathways they belong to, but for now let's just get the gene names:

```bash
KEGG/KEGG-tools assign -i SPADES_diamond.txt -o . -k KEGG
```

Look at the file "SPADES_diamond_KOtable.txt" using **less**. Now we have got some proper gene names we can work with! Now let's join the PROKKA and KEGG annotations into one single file. Just copy and paste the code below (remember to scroll to the right to get the full command):

```bash
awk -F '\t' '{if ($2 == "CDS") {print}}' PROKKA_SPADES/SPADES.tsv | join -1 1 -2 1 -a 1 -t $'\t' - <(cut -f 1,4 SPADES_diamond_KOtable.txt) > SPADES_combined_annotation.txt
```

Now download the file "SPADES_combined_annotation.txt" to your computer using FileZilla and open it in Excel. Scroll through the list and see:
* Which genes have been found? Do you see something interesting?
* Do the PROKKA and KEGG annotations agree with each other?
