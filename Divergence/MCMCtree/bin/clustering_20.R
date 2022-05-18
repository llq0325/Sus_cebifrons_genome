#a- get data in R
library("cluster")
t=as.matrix(read.table("matrix_distance.txt",row.names=1))

# b- run PCA
pc=prcomp(t, scale.=TRUE)
comp=pc$x[,c("PC1", "PC2")]

#c- cluster using PAM
clust=pam(comp, 20)

#d- ouput
write.table(clust$clustering, file="cluster.txt", quote=FALSE)

