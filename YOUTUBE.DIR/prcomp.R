# Author: Steve Pittard - wsp@emory.edu, ticopittard@gmail.com 
# This video is in support of the following YouTube video:

# Using prcomp and varimax for PCA in R www.youtube.com/watch?v=PSuvMBtvJcA 

library(lattice)
url <- "https://raw.githubusercontent.com/steviep42/youtube/master/YOUTUBE.DIR/wines.csv"
my.wines <- read.csv(url, header=TRUE)

# Look at the correlations

library(gclus)
my.abs     <- abs(cor(my.wines[,-1]))
my.colors  <- dmat.color(my.abs)
my.ordered <- order.single(cor(my.wines[,-1]))
cpairs(my.wines, my.ordered, panel.colors=my.colors, gap=0.5)

# Do the PCA 

my.prc <- prcomp(my.wines[,-1], center=TRUE, scale=TRUE)
screeplot(my.prc, main="Scree Plot", xlab="Components")
screeplot(my.prc, main="Scree Plot", type="line" )

# DotPlot PC1

load    <- my.prc$rotation
sorted.loadings <- load[order(load[, 1]), 1]
myTitle <- "Loadings Plot for PC1" 
myXlab  <- "Variable Loadings"
dotplot(sorted.loadings, main=myTitle, xlab=myXlab, cex=1.5, col="red")

# DotPlot PC2

sorted.loadings <- load[order(load[, 2]), 2]
myTitle <- "Loadings Plot for PC2"
myXlab  <- "Variable Loadings"
dotplot(sorted.loadings, main=myTitle, xlab=myXlab, cex=1.5, col="red")

# Now draw the BiPlot
biplot(my.prc, cex=c(1, 0.7))

# Apply the Varimax Rotation
my.var <- varimax(my.prc$rotation)

