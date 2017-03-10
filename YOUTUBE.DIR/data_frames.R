# Author: Steve Pittard wsp@emory.edu, ticopittard@gmail.com
# This file is in support of the Youtube video designed to introduce data frames in R

# R Class - Data Frames - Part 1 http://www.youtube.com/watch?v=PSuvMBtvJcA

names=c("P1","P2","P3","P4","P5")
temp=c(98.2,101.3,97.2,100.2,98.5)
pulse=c(66,72,83,85,90)
gender=c("M","F","M","M","F")


for (ii in 1:length(gender)) {  
      print.string = c(names[ii],temp[ii],pulse[ii],gender[ii])
      print(print.string)
}

my_df = data.frame(names,temp,pulse,gender) # Much more flexible

class(my_df)
plot(my_df$pulse ~ my_df$temp,main="Pulse Rate",xlab="Patient",ylab="BPM")
sapply(my_df[,2:3],mean)

# SLIDE #4

smoker = c("Y","N","N","Y","N")



# SLIDE #5

df1=data.frame(id=c('P1','P2','P3'),m1=c(12.34,34.12,11.12),m2=c(90.32,23.90,78.23))

df2=data.frame(id=c('P4','P5','P6'),m1=c(12.34,43.12,12.11),m2=c(90.32,23.90,78.23))
rbind(df1,df2)

# SLIDE #6

tb1 = data.frame(indiv_id = 1:4, snp1 = c(1,1,0,1), snp2 = c(1,1,0,0)) 

tb2 = data.frame(indiv_id = c(1,3,4,6), cov1 = c(1.14,4.50,0.80,1.39), cov2 = c(74.6,79.4,48.2,68.1))

merge(tb1,tb2,by="indiv_id",all=TRUE)

# SLIDE #12  You can query the names of columns and/or set the names

names(mtcars)     # See the column names/attributes/variables
head(mtcars,3)  # List the first 3 lines of the data frame

nrows(mtcars)
head(mtcars)
 

mtcars$cyl          # Extract the cylinder column and print it
mtcars[,c("mpg","hp")] # Extract the columns mpg and hp


# SLIDE #13

mtcars[,-11]
mtcars[,-3:-5]	# Print all columns except for columns 3 through 5
mtcars[,c(-3,-5)] # Print all columns except for colums 3 AND 5

# SLIDE #14

mtcars[mtcars$mpg >= 30.0,]
mtcars[mtcars$mpg >= 30.0,2:6]
mtcars[mtcars$mpg >= 30.0 & mtcars$cyl < 6,]


# SLIDE #15

subset(mtcars, mpg >= 30.0)   # Get all records with MPG > 30.0
subset(mtcars, mpg >= 30.0, select=c(mpg:drat) )# Get all columns from mpg to drat
subset(mtcars, mpg >= 30.0 & cyl < 6 ) # Get all records with MPG >=30 and cyl <6


# SLIDE #17  Adjust some of the variables types

mtcars$cyl = factor(mtcars$cyl,labels=c("Tin_Can","Mid_Size","Gas_Hog"))
mtcars$am  = factor(mtcars$am, labels=c("Auto","Manu"))

table(mtcars$cyl)
table(mtcars$cyl,mtcars$am)


# SLIDE # 19  Use the transform command

transform(mtcars,wt=(wt*1000),qsec=round(qsec))

# SLIDE #20

data1 = read.table("http://www.ats.ucla.edu/stat/r/notes/hs0.csv",header=T,sep=",")
head(data1)
sapply(data1,class)  	# Applies the “Class” function to all columns

# SLIDE #21  Impose data types as you read the data in

myclasses = c("character","integer","integer","integer","character","factor","integer","integer","integer","integer","numeric")
data1 = read.table("http://www.ats.ucla.edu/stat/r/notes/hs0.csv",header=T,sep=",",colClasses = myclasses)
sapply(data1,class)              

# SLIDE #22  Sort the data frame

newdata = mtcars[order(mtcars$mpg),] 
newdata

order(mtcars$mpg)
mtcars[order(mtcars$mpg),] 


# SLIDE #27
summary(mtcars)

tapply(mtcars$mpg,mtcars$am,mean)
tapply(mtcars$mpg,list(mtcars$am,mtcars$cyl),mean)


# SLIDE #28  Let's do some aggregation


aggregate(mpg~am,mtcars,mean)
# Do the mean aggregation of MPG by Transmission and cylinder type
aggregate(mpg~am+cyl,mtcars,mean)

# SLIDE #29

aggregate(cbind(mpg,disp,hp,wt) ~ cyl, mtcars, mean)

# Note that column “am” is transmission type: 0 = auto, 1 = manual 

aggregate(cbind(mpg,disp,hp,wt) ~ am + cyl, mtcars, mean)

# SLIDE #30  Missing Values

data <- data.frame(x=c(1,2,3,4), y=c(5, NA, 8,3),z=c("F","M","F","M"))
na.omit(data)  # Omit those rows that aren’t complete.

# SLIDE #31  Missing Values and Missing Cases

data <- data.frame(x=c(1,2,3,4), y=c(5, NA, 8,3),z=c("F","M","F","M"))
complete.cases(data)
sum(complete.cases(data))  # total number of complete cases
sum(!complete.cases(data)) # total number of incomplete cases
data[complete.cases(data),]

# SLIDE #32  Sample Randomly from a data frame

my_records = sample(1:nrow(mtcars), 10, replace = FALSE)
my_records

sample_of_ten = mtcars[my_records,]
sample_of_ten

# SLIDE #33   

# Check out the attach command. It can save you typing but it can also be dangerous

mpg
attach(mtcars)
mpg
plot(mpg,wt)
detach(mtcars)
mpg

# Or use the with command to temporarily load the dataset for just a single command

with(mtcars,plot(mpg,wt))


# SLIDE #36  - Many functions let you specify the data frame you are working with

my.lm = lm(mpg ~ wt,mtcars)   # instead of 
my.lm = lm(mtcars$mpg ~ mtcars$wt)   


