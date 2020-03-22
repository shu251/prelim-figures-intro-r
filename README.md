# Generate figures from tag-sequencing data
Introduction to using R to compile, analyze, and interpret tag-sequencing data. The below details how to use R to import an OTU or ASV table and generate a preliminary set of tables and figures for interpretation.  

### _Prerequisites:_
* Installation of github, R, anaconda (optional)
* _Some_ familiarity with R
* OTU or ASV data (recommend to use test data provided here for first-timers!)
* _Little_ command line knowledge required

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
```
