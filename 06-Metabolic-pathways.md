# Day 6: Metabolic pathway analysis

## Connecting to Taito

See the instructions [here](01-UNIX-and-CSC.md#connecting-to-taito).

## Mapping annotations to KEGG pathways

```bash
KEGG/KEGG-tools summarise -i SPADES_diamond_KOtable.txt -o . -k KEGG -m no
```
Transfer the files "SPADES_diamond_KOtable_pathways_lvl3.txt" and "SPADES_diamond_KOtable_modules_lvl4.txt" to your computer using FileZilla. Open them in Excel and investigate the pathways found.

### KEGG mapper

Go to https://www.genome.jp/kegg/tool/map_pathway1.html


## RAST
* Go to http://rast.nmpdr.org/
* Login with User **guest** and Password **guest**
* Scroll down and locate Job **699550**
* Click on "view details"


## MINPATH

```bash
cd $WRKDIR/MMB-114

cut -f 1,3 SPADES_diamond_KOtable.txt > SPADES_diamond_KOtable_clean.txt
```


```
