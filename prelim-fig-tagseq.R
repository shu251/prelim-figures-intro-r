# Migrate to working directory (or start up R Project)
setwd("YOUR-PATH/prelim-figures-intro-r/")
# Install these packages:
library(dplyr);library(reshape2);library(ggplot2);library(cowplot);library(tidyverse)
#
####
# Import into RStudio
####
#
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
#
####
# Get basic stats on data
####
#
# View data frame attributes:
class(asv_counts) # your data is in R as a dataframe
str(asv_counts) # What type of data is each column? Integers
head(asv_counts) # Print out first few lines
summary(asv_counts) # Summary of dataframe
colnames(asv_counts) # What are all of my columns named?
View(asv_counts) #Opens new window to show what data frame looks like
#
# I'm going to keep all ASV assignments, as the confidence intervals are all above 0.7. To remove the "Confidence" column, I will execute this command
asv_counts$Confidence <- NULL # the "$" designates that I'm selecting a column
#
### IIa. Make basic plots - first look at data and basic data wrangling
#
## Convert wide format into long format
asv_counts_long <- melt(asv_counts)
?melt() # Pull up the Help menu for this command.
head(asv_counts_long) # lets look at the data now, sample IDs from columns are now in a column called "variable"
#
# let's do a first round of data wrangling. This is a basic plot first to show the value (sequence count) as the y axis and each of my samples (variable column) as the x axis.
ggplot(asv_counts_long, aes(x = variable, y = value)) + geom_bar(stat = "identity")
#
# ggplot is a la carte! So let's add on some information to modify the x-axis labels. FYI - these ggplot will get fancier and fancier as we go along.
#
ggplot(asv_counts_long, aes(x = variable, y = value)) + #Input dataframe info
  geom_bar(stat = "identity") + #Designates bar plot!
  theme(axis.text.x = element_text(angle = 90)) #Theme aesthetic stuff.
#
# Create new columns by separating out what is in the variable column, this will help us sort everything.
# Let's break this plot out a bit by separating the variable column 
unique(asv_counts_long$variable) # What are all of my sample names?
asv_counts_long_cols <- separate(data = asv_counts_long, col = variable, into = c("SAMPLE", "SAMPLE_NUMBER", "SITE", "SITE_NAME", "YEAR"), sep = "_", remove = FALSE)
head(asv_counts_long_cols)
# We got a warning message, this is because my sample names were inconsistent with how many underscores they had. So after doing this, let's see which columns ended up with NAs
#
unique(asv_counts_long_cols$SAMPLE) # this just says "Sample" over and over, we can remove it
asv_counts_long_cols$SAMPLE <-NULL # removed!
#
unique(asv_counts_long_cols$SAMPLE_NUMBER) # a list of numbers!
str(asv_counts_long_cols$SAMPLE_NUMBER) # Make sure it is kept as characters though, "chr"
#
unique(asv_counts_long_cols$SITE) 
unique(asv_counts_long_cols$SITE_NAME)
unique(asv_counts_long_cols$YEAR) # This is where the NAs are, the control samples, which are "CTRL" under the SITE column do not have Year designations. 
#
#
#### _How many sequences are in each of my samples? What about ASVs or OTUs?_
# Make a set of first look plots
#
# Lets repeat the ggplot with our new dataframe, but add in a color schematic that designates SITE. I've also added a facet_grid line that allows you to panel your plot.
#
ggplot(asv_counts_long_cols, aes(x = variable, y = value, fill = SITE)) + #Input dataframe info, Added SITE as a fill aesthetic!
  geom_bar(stat = "identity") + #Designates bar plot!
  theme(axis.text.x = element_text(angle = 90))+ #Theme aesthetic stuff
  facet_grid(.~YEAR, scales = "free", space = "free")
#
# Let's do a bit of data wrangling. Let's make a new table that has the total number of sequences per sample and the total number of ASVs per sample.We're going to use dplyr for this.
# To showcase how the dplyr syntax works, watch how this table gets modified (a bunch of lines of code strung together with "%>%"):
head(asv_counts_long_cols)
asv_counts_summary <- asv_counts_long_cols %>%   # Assign a new table
  group_by(variable, SITE, SITE_NAME, YEAR) %>%  # Assign how you're going to "group your samples" - include variable that will remain unique in your output table.
  summarise(SUM = sum(value)) %>%   #Function to perform, in this case add up the value column
  data.frame #convert new table into a dataframe
head(asv_counts_summary) # New table includes all the variables I had above
#
## We can do the same thing, but add a function to add up the total number of ASVs per sample. This means count the number of times in the "value" column is greater than 0.
#
asv_counts_summary <- asv_counts_long_cols %>%  
  group_by(variable, SITE, SITE_NAME, YEAR) %>%
  filter(value > 0) %>%   # Removes rows where the value was = 0
  summarise(SUM = sum(value), ASV_COUNT = length(value)) %>% # added an ASV_COUNT column to count up all the entries for value. Which doesn't include any zeroes.
  data.frame
head(asv_counts_summary)
#
# Now we have a complete data frame that has both the sum of sequences and the total number of ASVs for each sample. Let's plot this. These are similar to above, but now I'm setting the plot equal to a plot object.
#
seq_count_plot <- ggplot(asv_counts_summary, aes(x = variable, y = SUM, fill = SITE)) + #Input dataframe info, Added SITE as a fill aesthetic!
  geom_bar(stat = "identity") + #Designates bar plot!
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))+ #Theme aesthetic stuff
  facet_grid(.~YEAR, scales = "free", space = "free")
seq_count_plot
###
# Let's repeat this, but plot the total number of ASVs, replace the y=
asv_count_plot <- ggplot(asv_counts_summary, aes(x = variable, y = ASV_COUNT, fill = SITE)) + #Input dataframe info, Added SITE as a fill aesthetic!
  geom_bar(stat = "identity") + #Designates bar plot!
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))+ #Theme aesthetic stuff
  facet_grid(.~YEAR, scales = "free", space = "free")
asv_count_plot
#
# Let's modify the x and y axis labels, add a plot title and combine these plots. We can build off of the plot object that we previously set.
seq_count_plot + labs(x = "Samples", y = "Total number of reads", title = "Total reads per sample")
asv_count_plot + labs(x = "Samples", y = "Total number of ASVs", title = "Total ASVs per sample")
#
#
# Let's add a different color schematic.
library(RColorBrewer)
display.brewer.all() # See all the available options
# See how I incorporate a custom color scale. We will go into more detail below.
seq_count_plot + 
  labs(x = "Samples", y = "Total number of reads", title = "Total reads per sample") +
  scale_fill_brewer(palette = "Set1")
asv_count_plot + 
  labs(x = "Samples", y = "Total number of ASVs", title = "Total ASVs per sample") +
  scale_fill_brewer(palette = "Set1")
#
# To combine these plots we can use a command from the cowplot package. We can comma separate the plots we made from above.
plot_grid(seq_count_plot + labs(x = "Samples", y = "Total number of reads", title = "Total reads per sample") + scale_fill_brewer(palette = "Set1"), 
          asv_count_plot + labs(x = "Samples", y = "Total number of ASVs", title = "Total ASVs per sample") + scale_fill_brewer(palette = "Set1"))
#
# One more set of modifications: (1) Make the scale on the total reads per sample plot a log scale. and (2) add A and B labels to this 2 panel plot:
plot_grid(seq_count_plot + labs(x = "Samples", y = "Total number of reads", title = "Total reads per sample") + scale_fill_brewer(palette = "Set1") + scale_y_log10(), 
          asv_count_plot + labs(x = "Samples", y = "Total number of ASVs", title = "Total ASVs per sample") + scale_fill_brewer(palette = "Set1"), labels = c("a", "b"))
#
#
#
#
#
## III. Data wrangling & processing

# REMOVE
### IIIa. _Consider blank samples_
library(decontam); library(phyloseq)
#
# Lets start using phyloseq and consider our Control samples to remove contaminants.

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


