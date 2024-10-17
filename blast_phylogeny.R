source("~/Desktop/script/ggplot_theme.R")
library(taxonomizr)
library(dplyr)
library(ggplot2)


prepareDatabase('accessionTaxa.sql')
#blastAccessions<-c("Z17430.1","Z17429.1","X62402.1") 
#ids<-accessionToTaxa(blastAccessions,'accessionTaxa.sql')
#getTaxonomy(ids,'accessionTaxa.sql')

blastResults<-read.table('/home/bpx/Desktop/primer.fasta.blast',header=FALSE,stringsAsFactors=FALSE)

# Filter the data to exclude those below 95
filtered_blastResults <- blastResults %>%
  filter(V3 > 95)  # Column 3 corresponds to the percent identity


# Filter the data to exclude those below 95
filtered_blastResults <- blastResults %>%
  filter(V4 > 17)  # Column 4 corresponds to the query length


# Filter the data to exclude those below 95
filtered_blastResults <- blastResults %>%
  filter(V12 > 37)  # Column 12 corresponds to the bitscore
filtered_blastResults 

#grab the 4th |-separated field from the reference name in the second column
accessions<-sapply(strsplit(filtered_blastResults [,2],'\\|'),'[',4)

idss<-accessionToTaxa(accessions,'accessionTaxa.sql')
taxlist= getTaxonomy(idss,'accessionTaxa.sql')
head(taxlist)
cltax=cbind(filtered_blastResults ,taxlist) #bind BLAST hits and taxonomy table
colnames(cltax)


jpeg("/home/bpx/Desktop/percent_identity.jpg", units="in", family="Times",  width=5, height=5, res=300, pointsize = 6) #pointsize is font size| increase image size to see the key

#ggplot for top hits or percent identity of each species
ggplot(data=cltax) + aes(x = species, y = V3) +
geom_point(alpha=0.3, color="tomato", position = "jitter") +
  #geom_boxplot(alpha=0) + coord_flip()
labs(title = "BLAST hits list", x = "Virus", y = "Perc.Ident")
dev.off()


jpeg("/home/bpx/Desktop/Alignment_length.jpg", units="in", family="Times",  width=5, height=5, res=300, pointsize = 6) #pointsize is font size| increase image size to see the key
#ggplot for Alignment_length
ggplot(data=cltax) + aes(x = species, y = V4) +
  geom_point(alpha=0.3, color="tomato", position = "jitter") +
  #geom_boxplot(alpha=0)+
  labs(title = "BLAST hits list", x = "Virus", y = "Alignment_length")
dev.off()


spec <- table(subset(taxlist, select = "species"))
# Convert spec vector to data frame
data <- data.frame(
  Virus = names(spec),
  Value = as.numeric(spec)
)


# Filter the data to exclude those below 50
filtered_data <- data %>%
  filter(Value >= 1)



yy <- max(filtered_data$Value)
source("ggplot_theme.R")

jpeg("/home/bpx/Desktop/blast_phylogeny.jpg", units="in", family="Times",  width=5, height=5, res=300, pointsize = 6) #pointsize is font size| increase image size to see the key

# Create the plot
ggplot(filtered_data, aes(x = reorder(Virus, -Value), y = Value, fill = Virus)) +
  geom_bar(stat = "identity", width=0.5) +
  labs(title = "BLAST hits list", x = "Virus", y = "Count") +
  scale_y_continuous(limits = c(0, yy+20),expand = expansion(mult = c(0, 0)))+
  my_theme("x")
dev.off()
