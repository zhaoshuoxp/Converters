#!/usr/bin/env Rscript
#####################################
# Basic function to convert mouse to human gene names
convertMouseGeneList <- function(x){
 
require("biomaRt")
human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
 
genesV2 = getLDS(attributes = c("mgi_symbol"), filters = "mgi_symbol", values = x , mart = mouse, attributesL = c("hgnc_symbol"), martL = human, uniqueRows=T)
#print(genesV2)
humanx <- unique(genesV2[, 2])

return(genesV2)
}

# Basic function to convert human to mouse gene names
convertHumanGeneList <- function(x){
 
require("biomaRt")
human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
 
genesV2 = getLDS(attributes = c("hgnc_symbol"), filters = "hgnc_symbol", values = x , mart = human, attributesL = c("mgi_symbol"), martL = mouse, uniqueRows=T)
 
humanx <- unique(genesV2[, 2])

return(genesV2)
}
 

mus2rm <- function(x){
	
require("biomaRt")
monkey = useMart("ensembl", dataset = "mmulatta_gene_ensembl")
mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
	
genesV2 = getLDS(attributes = c("mgi_symbol"), filters = "mgi_symbol", values = x , mart = mouse, attributesL = c("hgnc_symbol"), martL = monkey, uniqueRows=T)
#print(genesV2)
humanx <- unique(genesV2[, 2])
	
return(genesV2)
}


options<-commandArgs(trailingOnly = T)
dat<-read.table(file=options[1],header=F)
out_name<-unlist(strsplit(options[1],'.',fixed=T))[1]

dat$V1->mus
#convertMouseGeneList(mus)->hum
mus2rm(mus)->rm
write.table(rm, file=paste(out_name, 'hum.txt', sep='2'), row.names=F, sep="\t", quote=F, col.names=T)