#!/usr/bin/Rscript
#script to simplify feelnc classifications
args <- commandArgs(TRUE)
feelnc_classification<-args[1]
output_dir<-args[2]

write(feelnc_classification,stdout())

best_classifications<-read.table(feelnc_classification,header=T, stringsAsFactors=F)
best_classifications<-best_classifications[best_classifications$isBest==1,]
modified_classification<-best_classifications[,c(1:5,8)]
position<-best_classifications$location
position[position=="exonic"] <- "overlapping"
position[position=="intronic"] <- "overlapping"
modified_classification$strand<-best_classifications$direction
modified_classification$position<-position

summary_class<-matrix(,dim(modified_classification)[1])
for (i in 1:dim(modified_classification)[1]){
if ((modified_classification$strand[i] == "antisense") && (modified_classification$position[i]=="upstream") && (modified_classification$distance[i] <=2000)) {
summary_class[i]<-"divergent"
} else if ((modified_classification$strand[i] == "antisense") && (modified_classification$position[i]=="upstream") && (modified_classification$distance[i] >2000)){
summary_class[i]<-"upstream antisense"
} else if ((modified_classification$strand[i] == "antisense") && (modified_classification$position[i]=="downstream")){
summary_class[i]<-"downstream antisense"
} else if ((modified_classification$strand[i] == "antisense") && (modified_classification$position[i]=="overlapping")){
summary_class[i]<-" antisense"
} else if ((modified_classification$strand[i] == "sense") && (modified_classification$position[i]=="overlapping")){
summary_class[i]<-"overlap sense"
} else if ((modified_classification$strand[i] == "sense") && (modified_classification$position[i]=="downstream")){
summary_class[i]<-"downstream sense"
} else if ((modified_classification$strand[i] == "sense") && (modified_classification$position[i]=="upstream")){
summary_class[i]<-"upstream sense"
}
}
modified_classification$summary_class<-summary_class

write.csv(modified_classification, paste(output_dir, "/final_lcnrna_classification.csv", sep=""))
