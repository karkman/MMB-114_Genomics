# Day 6: Metabolic pathway analysis

## Connecting to Puhti

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-puhti).

## Mapping annotations to KEGG pathways

First we will use a tool called keggR (written by yours truly) to parse the KEGG annotations that we obtained on the last class.  
This will allow us to put the gene annotations in the context of metabolic pathways.  
keggR is actually an R package (if you don't know what R is take a look [here](https://www.computerworld.com/article/2497143/business-intelligence-beginner-s-guide-to-r-introduction.html)).  
To use R in Puhti we actually have to configure a bunch of stuff first:

```bash
# First we launch the interactive partition
sinteractive -A project_2001379

# Then we set up the bioconda environment
export PROJAPPL=/projappl/project_2001379
module load bioconda

# And then we load keggR
source activate /projappl/project_2001379/bioconda3_env/keggR
```

Because we don't want to go through the learning curve of having to learn R now so late in the game, let's just copy a script I have prepared for you that will run keggR for us:

```bash
cd MMB114

cp /projappl/project_2001379/keggR_salla.R .

Rscript keggR_salla.R
```

If everything went well we now have a new file called "KEGG_SALLA_KO.txt" in our directory.  
Take a look at this file using **head** and make a nicer output using **column**:

```bash
head KEGG_SALLA_KO.txt | column -t -s $'\t'
```

The file looks similar to what we had before, but now we have a new column with things like "K12262".  
These are known as KO identifiers and is how we link genes to metabolic pathways in the KEGG database.  

## Investigating metabolic pathways

To investigate the pathways further we will use a tool from KEGG called "KEGG mapper". For this:

* Download to your computer the file "KEGG_SALLA_KO.txt" using FileZilla and open it on Excel
* Go to https://www.genome.jp/kegg/mapper/search.html
* Copy only the KO column from Excel and paste it in the box
* In "Search mode", select **Reference**
* Click "Exec"
* Find the pathway you want to investigate further and click on it.
* See the genes involved in the pathway. Genes showed in red are the ones found in our genome. Everything else was not (well, at least was not annotated). Do you think that the cell would be able to carry out this pathway?

By looking at the different metabolic pathways encoded by our genome, let's try to answer:

* How does the strain
  * Gets energy
  * Gets carbon and nitrogen
  * Survives in stress
  * Move around

This will be a collaborative effort. Once you found something interesting, add it to our metabolic map [here](https://docs.google.com/presentation/d/1nCq1Yl28ZZykUqmTc27VGXakXMjugi6wybRPUBTwiWc/edit?usp=sharing).
