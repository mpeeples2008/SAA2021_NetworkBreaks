library(statnet)
library(igraph)
library(deldir)
library(ggplot2)
library(FreeSortR)
library(parallel)
library(doParallel)
library(ecp)
library(reshape)

# set up cores for running in parallel
cl <- makeCluster(detectCores())
registerDoParallel(cl)

# assign attribute dataset and similarity matrix objects
coord1 <- read.csv('site_locations.csv', header=T, row.names=1)
sim1 <- as.matrix(read.csv('sim_matrix.csv', header=T, row.names=1))

# convert UTM locations into Euclidean distance matrix and reverse direction
d <- as.matrix(dist(coord1))

# Calculate Louvain clustering for the selected similarity network constrained across every percentile in the distance matrix
res <- matrix(NA,nrow(sim1),100)
for (i in 1:100) {
  d.mat <- event2dichot(d,method='quantile',thresh=1-(i/100))
  com.net <- d.mat*sim1
  G1 <- graph.adjacency(com.net, mode = "undirected", weighted = TRUE, diag = TRUE)
  res[,i] <- cluster_louvain(G1)$membership
}

# Calculate Adjusted Rand Index among every pair of percentile constrained partitions
rand.I <- foreach(i=1:100) %dopar% {
  res2 <- NULL
  for (j in 1:100) {
    res2[j] <- FreeSortR::RandIndex(res[,i],res[,j])$AdjustedRand
  }
  res2
}

rand.I <- matrix(unlist(rand.I), ncol = 100, byrow = TRUE)


## define breakpoints using aggolomerative algorithm in ecp package first across all distances
z1 <- e.agglo(rand.I,alpha=1.5) # calculate across all distances
z1.a <- z1$estimates-1
z2 <- e.agglo(rand.I[1:z1.a[2],1:z1.a[2]],alpha=1.5) # calculate partitions within first partition
z2.a <- z2$estimates-1

# combine and remove duplicates
z.a <- sort(unique(c(z1.a,z2.a)))
z.a[1] <- 1
z.a <- unique(z.a)

#calculate prototypical distances for each partition and create data frame
proto.typical <- NULL
for (i in 1:(length(z.a)-1)) {
  lv <-  z.a[i]:z.a[i+1]
  proto.typical[i] <-  lv[which.max(rowSums(rand.I[lv,lv]))]
}
z.p <- as.data.frame(proto.typical)
colnames(z.p) <- c('X')


## Plot Rand Index similarities with proto typical distances and partitions indicated
ggplot() + 
  scale_fill_viridis_c() +
  geom_tile(data = melt(rand.I), aes(x=X1, y=X2, fill=value)) +
  geom_vline(xintercept=z.a+0.5) +
  geom_hline(yintercept=z.a+0.5) +
  geom_point(data = z.p, mapping=aes(x=X,y=X), size=4, col='red') 


## Display prototypical distances in kilometers
quantile(d/1000,z.p/100)


## Create Voronoi polygons and divide based on partition membership
m <- 100 # set the percentile you would like to use for partitions and boundaries
dd <- deldir(coord1$Easting,coord1$Northing,z=as.factor(res[,m]))
plot(dd)

div.dd <- divchain(dd)

## Plot map with partition boundaries
plot(coord1, pch=16, col=res[,m])
plot(div.dd, add=T, col='orange', lw=2)
