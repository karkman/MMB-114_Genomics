# Day 6: Metabolic pathway analysis

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## Mapping annotations to KEGG pathways

Here we will use KEGG-tools again to put the annotations in the context of the KEGG pathways:

```bash
sinteractive
module load biopython-env/2.7.13
cd $WRKDIR/MMB114

KEGG/KEGG-tools-assign.py -i diamond.txt -a KEGG --summarise
```

Once KEGG-tools is finished, transfer the files "diamond_pathways_level3.txt" and "diamond_modules_level4.txt" to your computer using FileZilla. Open them in Excel and investigate the pathways found:

* How does the strain
  * Gets energy
  * Survives in stress
  * Does it use nitrogen? Sulfate? Iron?
* Look for the "phosphotransferase system (PTS)" and "Saccharide, polyol, and lipid transport system" modules
  * Can you find the genes that carry out the uptake of the sugars metabolized in the biochemical tests?

## Investigating further the predicted pathways

One of the problems of pathway analysis is that most genes have roles in multiple pathways. The presence of a gene involved, for example, in methane metabolism, does not necessarily mean that the cell is actually capable of metabolizing methane.

To investigate the pathways further and see if all or most of the necessary genes are present we will use a tool from KEGG called "KEGG mapper":

* Download to your computer the file "diamond_pathways_level4.txt" using FileZilla and open it on Excel
* Go to https://www.genome.jp/kegg/tool/map_pathway1.html
* Copy only the 4th column ("KO") from Excel (without the header) and paste it in the box
* In "Search mode", select **Reference**
* Click "Exec"
* Find the pathway you want to investigate further and click on it.
* See the genes involved in the pathway. Genes showed in red are the ones found in our genome. Everything else was not (well, at least was not annotated). Do you think that the cell would be able to carry out this pathway?

In moodle under "Course data 2019 fall" you will find a folder called "Genome work". Download the two files there to you computer and take a look at them. The excel file describes the results of a tool for predicting bacterial phenotypes called PhenDB (https://phen.csb.univie.ac.at/phendb/). The png file comes from another tool called KEGGDecoder (https://github.com/bjtully/BioData/tree/master/KEGGDecoder) which looks at the KEGG annotations and determine which pathways are complete.

With these new results in mind, revise the pathways and answer the questions again:

* How does the strain
  * Gets energy
  * Survives in stress
  * Does it use nitrogen? Sulfate? Iron?
* Look for the "phosphotransferase system (PTS)" and "Saccharide, polyol, and lipid transport system" modules
  * Can you find the genes that carry out the uptake of the sugars metabolized in the biochemical tests?
