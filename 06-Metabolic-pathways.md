# Day 6: Metabolic pathway analysis

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## Mapping annotations to KEGG pathways

Here we will use KEGG-tools again to put the annotations in the context of the KEGG pathways.

```bash
cd $WRKDIR/MMB-114

KEGG/KEGG-tools summarise -i SPADES_diamond_KOtable.txt -o . -k KEGG -m no
```

Once KEGG-tools is finished, transfer the files "SPADES_diamond_KOtable_pathways_lvl3.txt" and "SPADES_diamond_KOtable_modules_lvl4.txt" to your computer using FileZilla. Open them in Excel and investigate the pathways found:

* How does the strain
  * Gets energy
  * Survive in stress
  * Does it use nitrogen? Sulfate? Iron?
* Look for the phosphotransferase system (PTS)
  * Is our strain able to carry out the uptake of the sugars metabolized in the biochemical tests?

## Investigating further the predicted pathways

One of the problems of pathway analysis is that a lot of genes have roles in multiple pathways. The presence of a gene involved, for example, in methane metabolism, does not necessarily mean that the cell is actually capable of metabolizing methane.

To investigate the pathways further and see if all or most of the necessary genes are present we will use a tool from KEGG called "KEGG mapper":

* Download to your computer the file "SPADES_diamond_KOtable_pathways_lvl4.txt" using FileZilla
* Go to https://www.genome.jp/kegg/tool/map_pathway1.html
* Either copy the contents of the file and paste it in the box or upload the file using the "Choose file" dialogue.
* Uncheck the "Display objects not found in the search" option
* Click "Exec"
* Find the pathway you want to investigate further and click on it.
* See the genes involved in the pathway. Genes showed in red are the ones found in our genome. Everything else was not (well, at least was not annotated). Do you think that the cell would be able to carry out this pathway?

Another way of identifying spurious (incomplete) pathways is with a tool called "MinPath". First we need to make a list of the KEGG annotation in the format that MinPath wants:

```bash
cd $WRKDIR/MMB-114

cut -f 1,3 SPADES_diamond_KOtable.txt > SPADES_diamond_KOtable_minpath.txt
```

* Download this file to your computer using FileZilla and upload it in http://omics.informatics.indiana.edu/MinPath/run.php
* Click "Send Request"
* Investigate "Results in html"
* Look at the column "MinPath". Everything in red was deemed incomplete by MinPath, meaning that one or more essential genes for this pathway are not found in the genome

With the KEGG mapper and MinPath results, revise the pathways and answer the questions again:

* How does the strain
  * Gets energy
  * Survive in stress
  * Does it use nitrogen? Sulfate? Iron?
* Look for the phosphotransferase system (PTS)
  * Is our strain able to carry out the uptake of the sugars metabolized in the biochemical tests?
