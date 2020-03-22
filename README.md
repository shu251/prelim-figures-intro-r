# Generate figures from tag-sequencing data
Introduction to using R to compile, analyze, and interpret tag-sequencing data. The below details how to use R to import an OTU or ASV table and generate a preliminary set of tables and figures for interpretation.  

### _Prerequisites:_
* Installation of github, R (Rstudio), anaconda (optional)
* _Some_ familiarity with R - have RStudio installed (v3.6.1)
* OTU or ASV data (recommend to use test data provided here for first-timers!)
* _A little_ command line knowledge required

### How to use   
Recommended to run through with the test data completely so you have a sense of what input files and information are needed before starting.   
* **New R users* or *first timers to analyzing tag-sequencing data**: download and run through the entire script with test data. The code will follow along with the readme directions below and provide additional explanations and helpful links.
* **Familiar with R & want to use my own data**: Download the R script and run through in R Studio. Explanations for code are complete in the code itself, use the readme below to ensure you are importing data the same way.

## Set up in R
#### Input data and files
Download this repo including test data () or work with our own data table. Required input is an OTU or ASV table in this format:   
![headcount](https://github.com/shu251/figs/blob/master/headcount_output.png)   
Where each row is an _unique_ OTU or ASV (taxonomic designation or protein/gene ID) and columns represent your various samples. For this tutorial, we will walk through how to input a separate table with metadata to match up to the sample names.   

#### Installation of R, using R Studio
I prefer to install via [Anaconda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#). I've written a [blog post here](https://alexanderlabwhoi.github.io/post/anaconda-r-sarah/) that details how to manage different versions of R on your computer. However, there are several other ways to install and manage R on your computer (see [R projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects)).   

Below was written with *R version 3.6.1*. While other versions of R will likely work, I cannot guarantee all code will function properly.

#### Clone this repo
To get the information and code from this github repo to your local computer:
```
git clone https://github.com/shu251/prelim-figures-intro-r.git

cd $PATH/prelim-figures-intro-r/

# Open 'prelim-fig-tagseq.R' in RStudio

```   

#### Navigating RStudio

In RStudio, migrate to this github repo or your working directory. Alternatively, spin up an RProject using the provided code: *prelim-fig-tagseq.R*.   


Your RStudio should look like this:

##### INSERT image    


_Explaination of above image_:   
The Rcode is listed in the *top left* in this image. When you place your cursor in this code area, **execute a line of code by: *COMMAND + ENTER* (Mac) or *CTRL + ENTER* (Windows)**. When a line of code is executed, it is "sent" to the console shown below. This way you can write whole workflows of code, save it as a script (*.R*) and be able to re-open it and modify. To the right of the code and console are 2 other windows. The top right is a print out of your 'Global Environment'. As you "import" things with your code this will populate with some basic information about what you've got loaded up. Bottom right has several other tabs, a help menu will pop-up here when you execute a help command and when we get to plotting below, this is where the plots show up. How fun. Please read up on other things RStudio has to offer - it is great and constantly open on my computer. [See this tutorial from Software Carpentry](https://swcarpentry.github.io/r-novice-gapminder/01-rstudio-intro/). 
The Rcode shown here needs to be able to find all the files you want to work with. So you need to either open it via a Rproject from your working directory or execute a line of code to tell it where to look on your computer:
```
# Set your working directory to this repo by modifying this line of code:
setwd("YOUR-PATH/prelim-figures-intro-r/")

# For example, mine looks like this:
setwd("/Users/sarahhu/Desktop/Projects/prelim-figures-intro-r/")
```

#### R packages
If you followed my blog post for using R with conda, most of these are likely installed. Please import all required libraries, example below. But also [see how to troubleshoot this](https://support.rstudio.com/hc/en-us/articles/200554786-Problem-Installing-Packages).
```
# Required:
library(dplyr);library(reshape2);library(ggplot2);library(cowplot);library(tidyverse)

# Example to install & load:
install.packages("dplyr") # Follow instructions that follow
library(dplyr)
```

## I. Import into RStudio
I've written test data in two types of ASV/OTU table formats, *.csv* or *.txt*. If you've followed my other [instructions for making ASV or OTU tables](https://github.com/shu251/tagseq-qiime2-snakemake), then the output data is in the *.txt* format. When you use your own data with this tutorial, either make sure your data are similarly structured to one of these file types OR read up on _read.csv_ and _read.delim_ in R so you can import on your own.   

Two options listed below. Comment or uncomment using *#* to execute each line of code.
```
# Import ASV table in .csv format and view:
asv_counts <- read.csv("test-input-asvtable.csv") #Automatically imports .csv file because command knows how .csv files are encoded.
# ?read.csv() # Read help menu
head(asv_counts)
# View(asv_counts)
#
# Import ASV table in .txt. format and view:
asv_counts <- read.delim("test-input-asvtable.txt", sep = " ", header = TRUE) # this command requires additional input from you on what your data table looks like, e.g., columns are separated by a space, therefore use: sep = " ". 
# ?read.delim # Read help menu
head(asv_counts)
# View(asv_counts)
```
Both of these import the provided ASV or OTU table into R as a _data frame_.

## II. Get basic stats on data

A common track is to be familiar with Excel and then migrate to R. To give you an idea of what these data frames look like in R (because in Excel you are manually staring and modifying your data frame), get used to using these commands. These are my recommendations - others exist.
```
class(asv_counts) # your data is in R as a dataframe
str(asv_counts) # What type of data is each column? Integers
head(asv_counts) # Print out first few lines
summary(asv_counts) # Summary of dataframe
colnames(asv_counts) # What are all of my columns named?
View(asv_counts) #Opens new window to show what data frame looks like
```

### IIa. Make basic plots - first look at data

#### _How many sequences are in each of my samples? What about ASVs or OTUs?_
#### _What is the distribution of small ASVs or OTUs?_

## III. Data wrangling & processing

### IIIa. _Convert data frame to long format_
Sum by sample only and make a bar plot to show the total number 


### IIIb. _Remove a sample_
Remove sample that didn't sequence well

### IIIc. _Consider blank samples_
library(decontam)

### IIId. _Add/include metadata_
Import separate table with additional Site information

## IV. Data visualization

ggplot2

### IVa. _Sum data by diffrent attributes - barplot_
geom_bar

### IVb. _Make my plot fancy_
Factoring, themes in ggplot, facet grid

### IVc. _Bubble plot_
geom_point

### IVd. _Area plot_
geom_area

### IVe. _Box plot_
geom_boxplot

## V. Data normalization - best practices!

### Va. Alpha and beta diversity

### Vb.  MDS, PCoA, clustering

### Vc. Interpretation of tag-sequencing data
