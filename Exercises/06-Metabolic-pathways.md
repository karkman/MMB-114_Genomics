# Day 6: Metabolic pathway analysis

## Investigating metabolic pathways

To investigate the pathways further we will use a tool from KEGG called "KEGG mapper". For this:

* Download to your computer the file `kegg_ids.txt`.
* Go to https://www.genome.jp/kegg/mapper/search.html
* Copy and paste the file in the box
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

What other interesting traits can you find from your genome?  

## Secondary metabolites

If you're interested on the secondary metabolites your strain produces (such as antibiotics or other bioactive molecules), you can submit the assembled genome (fasta file) to [antiSMASH server](https://antismash.secondarymetabolites.org/). antiSMASH identifies, annotates and analyses secondary metabolite biosynthesis gene clusters from bacterial (and fungal) genomes.