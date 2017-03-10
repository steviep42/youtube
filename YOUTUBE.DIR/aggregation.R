#
# Steve Pittard - wsp@emory.edu, 03/19/12
# Code to illustrate motivations for using apply function
#
# This file is in support of the youtube video: 
# Data summary with R using apply, by, tapply, aggregate - P1 www.youtube.com/watch?v=PSuvMBtvJcA

# Additional references include:
# http://statland.org/R/R/Rpulse2.htm , http://www.cyclismo.org/tutorial/R/tables.html#manipulations
# http://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/
# 

my.snps <- read.table("http://steviep42.bitbucket.org/YOUTUBE.DIR/nsnps.csv",header=F,sep=" ")
names(my.snps) <- c("X1", "X2", "SNP1", "SNP2")
new.snps       <- cbind(my.snps, co=sample(c("case","control"), 30, TRUE))

# Begin Initializations - Let's generate some matrices for example use. 
# To do this I actually use some of the functions that I'm trying to 
# explain in the video. So, at first, just ignore this first section.

new.snps <- read.csv("new_snps.csv", sep=",", header=TRUE)

test = list()
length(test) = 6  # number of data frame columns
test = sapply(test,function(x) rnorm(10,mean=2.5,sd=1))
mat.1K  = replicate(6,rnorm(1000,mean=5,sd=1))   # 1,000 rows by 6 cols
colnames(mat.1K)=paste(rep("B",6),1:6,sep="")
mat.10K =  replicate(6,rnorm(10000,mean=5,sd=8)) # 10,000 rows by 6 cols
# End initializations

##
# Given a matrix like those above (e.g. mat.1K) 
# The goal is to compute relative percentages down each column (across all rows)
# Each element is divided by the sum of the column times 100
#
# Here is one way that a newcomer to R might approach this problem. Its okay if
# you do this because this would be commonly done in other languages.
##

hold.df = mat.1K
rows = nrow(mat.1K)
for (jj in 1:nrow(hold.df)) {
  for (kk in 1:ncol(hold.df)) {
    hold.df[jj,kk] = mat.1K[jj,kk]/sum(mat.1K[1:rows,kk])*100
  }
}

# Verify that it worked - all columns should add up to 100

for (ii in 1:ncol(hold.df)) {
  print(sum(hold.df[,ii]))
}

# And we might put this into a function definition for later reuse

my.first.percent.func = function(temp.mat) {
  hold.mat = temp.mat
  rows = nrow(temp.mat)
  for (jj in 1:nrow(hold.mat)) {
    for (kk in 1:ncol(hold.mat)) {
      hold.mat[jj,kk] = temp.mat[jj,kk]/sum(temp.mat[1:rows,kk])*100
    }
  }
  return(hold.mat)
}

# Convince yourself that it worked by printing out the sum of the columns
# They should all be equal to 100

hold.df = my.first.percent.func(mat.1K)

for (ii in 1:ncol(hold.df)) {
  print(sum(hold.df[,ii]))
}

# We can eliminate the outer for-loop if we know something about bracket notation
# when referencing matrices in R. It now looks somewhat cleaner.

hold.df = mat.1K
for (ii in 1:ncol(hold.df)) {
  hold.df[,ii] = hold.df[,ii]/sum(hold.df[,ii])*100
}


# Let's update the previous function

my.second.percent.func = function(temp.df) {
   for (ii in 1:ncol(temp.df)) {
        temp.df[,ii] = temp.df[,ii]/sum(temp.df[,ii])*100
   }
   return(temp.df)
}

# all.equal compares the values of its arguments to see if they are in fact equal

all.equal(my.first.percent.func(mat.1K),my.second.percent.func(mat.1K))

# Let's see if this change made the timing any better... It should !

system.time(my.first.percent.func(mat.1K))    # has 2 for loops
system.time(my.second.percent.func(mat.1K))   # has 1 for loop

# But what do you do if you want to compute percents for each row across all the columns ?
# We could transpose the matrix.

row.perc = t(my.second.percent.func(t(mat.1K)))

# But if we don't want to do this then we need to recode the logic. 
# Let's add an argument called "rc" that lets us provide a 1 or 2 to correspond to "row" or "column" respectively
# 

my.third.percent.func = function(temp.df,rc) {
  if (rc == 1) {     # rc of 1 means rows
    for (ii in 1:nrow(temp.df)) {
      temp.df[ii,] = temp.df[ii,]/sum(temp.df[ii,])*100
    }
  } else {                        # We lazily assume that if it isn't 1 then it must be 2
    for (ii in 1:ncol(temp.df)) {
     temp.df[,ii] = temp.df[,ii]/sum(temp.df[,ii])*100
   }
  }
  return(temp.df)
}

all.equal(my.first.percent.func(mat.1K),my.second.percent.func(mat.1K),my.third.percent.func(mat.1K,2))

# Nice work. But what if we wanted to change what it is we are computing ? We would have to make
# an argument for that.
#
# But there is a "cleaner" way to do this. Check out the apply function

col.mat = apply(mat.1K,2,function(x) x/sum(x)*100)  # The "2" represents columns

# The following should be equal

all.equal(col.mat,my.third.percent.func(mat.1K,2))

system.time(my.first.percent.func(mat.1K))    # Two for loops
system.time(my.second.percent.func(mat.1K))   # One for loop
system.time(apply(mat.1K,2,function(x) x/sum(x)*100))  # no for loops

# Now let's look at the timings for the 10,000 row matrix

system.time(my.first.percent.func(mat.10K))   # Two for loops
system.time(my.second.percent.func(mat.10K))  # One for loop
system.time(apply(mat.10K,2,function(x) x/sum(x)*100))  # no for loops

# What if you wanted to apply your percentage function to the rows ?
# Or what if you wanted to change the function ? No recoding required.

row.df = apply(mat.1K,1,function(x) x/sum(x)*100) # The "1" represents rows

# Note - you will need to take the transpose of row.df to get the matrix to look
# like the original. This is because apply across rows returns a transpose. 

apply(mat.1K,2,mean)
apply(mat.1K,2,summary)
apply(mat.1K,1,mean)

by(mtcars$mpg, list(am=mtcars$am, cyl=mtcars$cyl), mean)
by(mtcars[,c('hp','wt')], list(am=mtcars$am), mean)
by(mtcars['mpg'], list(am=mtcars$am, cyl=mtcars$cyl), mean)

tapply(mtcars$mpg,mtcars$am,mean)
tapply(mtcars$mpg,list(mtcars$am,mtcars$cyl),mean)


###
# Let's talk about aggregation now that we know something about the apply functions
###

# Simple tables

letters[1:10]                   # Built in letters char vector
my.sample = sample(letters[1:10],20,replace=TRUE)   # sample 20 times from the 1st 10 letters with replacement
table(my.sample)   # Counts frequency of letters

# The table is much simpler than writing a for loop
# We will now use the internal mtcars data set - assumes some factors are present

table(new.snps$SNP1,new.snps$co)
my.mtcars = transform(mtcars,am=factor(am,labels=c("auto","manual")))
my.table = table(my.mtcars$cyl,my.mtcars$am)

# We can even add in another group - Let's try number of gears
my.3d.table = table(my.mtcars$cyl,my.mtcars$am,my.mtcars$gear)
my.3d.table

# Here we create some categories on the fly using cut
with(my.mtcars,table(cut(mpg,quantile(mpg)),cyl))
with(my.mtcars,table(cut(mpg,quantile(mpg),labels=c("Big Gas Hog","Gas Hog","Not Bad","The Best")),cyl))


# The xtabs function also summarizes things. It uses a formula notation

xtabs(~SNP1 + SNP2,new.snps)
xtabs(~am + cyl,my.mtcars)
xtabs(~am + cyl + gear,my.mtcars)


class(my.table)
my.table

# Tables are easily visualized

barplot(my.table,legend=T,col=c("red","blue","green"),ylim=c(0,20))
plot(my.table,col=c("red","blue","green"),main="Mosaic Plot")

# You can see the margin totals

addmargins(my.table)
addmargins(my.table,1)
addmargins(my.table,2)

# Working with table proportions

addmargins(prop.table(my.table))
addmargins(prop.table(my.table,2))  # Look at proportions columnwise
addmargins(prop.table(my.table,1))  # Look at proportions row wise

##
# Let's explore the aggregate function
##



# The aggregate function in this case is "mean" but could be something else

aggregate(mtcars['mpg'],list(Transmission=mtcars$am),mean)
aggregate(mtcars[c('mpg','hp')],list(Transmission_Type=mtcars$am),mean)
aggregate(mtcars[c('mpg','hp')],list(Transmission_Type=mtcars$am,Cylinders=mtcars$cyl),mean)

#
aggregate(mpg~am,my.mtcars,mean)


# Do the mean aggregation of MPG by Transmission and cylinder type
aggregate(mpg~am+cyl,my.mtcars,mean)

# Do the mean aggregation of MPG & weight by transmission and cylinder type
aggregate(cbind(mpg,wt,hp)~am+cyl,my.mtcars,mean) 

# Look at the SNP data
aggregate(cbind(X1,X2)~co+SNP1+SNP2,new.snps,mean)

# Aggregate has an alternative calling sequence
aggregate(my.mtcars[c('mpg','wt','hp')],by=list(am=my.mtcars$am,cyl=my.mtcars$cyl),mean)

# The Reshape package

library(reshape)
my.melt = melt(my.mtcars,id.vars=c("cyl","am"))
my.melt

cast(my.melt, cyl ~ variable, mean)

cast(my.melt, cyl ~ variable| am, mean,subset=variable %in% c("hp","wt"))

# Let's work with some SNP data

cast(melt(new.snps,id.vars=c("SNP1","SNP2","co")),SNP1 +SNP2 + co ~ variable,mean)

aggregate(new.snps[c('X1','X2')],by=list(SNP1=new.snps$SNP1,SNP2=new.snps$SNP2,CO=new.snps$co),mean)

# But we can provide our own function as an argument. In this case the mean and standard deviation

f = function(x) {mx=mean(x);sdx=sd(x);mz=c(mean=mx,sd=sdx)}
aggregate(new.snps[c('X1','X2')],by=list(SNP1=my.snps$SNP1,SNP2=my.snps$SNP2),f)

# What would the reshape solution look like ?

cast(melt(new.snps,id.vars=c("SNP1","SNP2","co")),SNP1 +SNP2 ~ variable,f)

# Using the R SQLDF Library
options(gsubfn.engine = "R")
library(sqldf)
DF = my.snps
sqldf("select SNP1,SNP2,avg(X1),avg(X2),stdev(X1),stdev(X2) from DF group by SNP1,SNP2")

# Let's labels things better using SQL
sqldf("select SNP1,SNP2,avg(X1) as 'Mean X1',avg(X2) as 'Mean X2',stdev(X1) as 'Stdev X1', stdev(X2) as 'Stdev X2' from DF group by SNP1,SNP2",drv="SQLite")

DF = my.mtcars
tempdf = sqldf("select * from DF where mpg < 20 and am = 'manual'")


sqldf("select avg(mpg),avg(hp) from (select * from DF where am == 'auto')")
sqldf("select avg(mpg),avg(hp) from (select * from DF where am == 'manual')")
