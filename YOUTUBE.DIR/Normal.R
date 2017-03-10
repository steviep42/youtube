# Pittard, Steve August 2014 - wsp@emory.edu
# Code to demonstrate the Normal distribution

# The formula for the Normal Probability Density Function is:

normpdf <- expression(paste(frac(1, sigma*sqrt(2*pi)), plain(e)^{frac(-(x-mu)^2, 2*sigma^2)}, sep=""))
par(mfrow=c(1,1))

plot(1:3,1:3,type="n",axes=F,ylab="",xlab="")
text(1.5,2,normpdf,cex=1.8)

# If the mean is 0 and the standard deviation is 1 then the formula can be 
# is called the Standard normal probability distribution function and can be 
# plotted like:

snormpdf <- expression(paste(frac(1, sqrt(2*pi)), plain(e)^{frac(-x^2, 2)}, sep=""))
text(2.5,2,snormpdf,cex=1.8)

# Using the second form of the function let's generate a sequence of numbers between 
# -4 and 4 in increments of .1

x <- seq(-4,4,.1)
y <- 1/sqrt(2*pi)*exp(-x^2/2)

# Plot the x,y pairs. Does the resulting curve look familiar ? 

par(mfrow=c(1,2)) # Put the two plots side by side

plot(x,y,lwd=1,,type="p",col="blue",cex=0.6,pch=19,main=snormpdf)
xlen <- length(x)
legend("topright",paste("N = ",xlen),cex=0.8)
grid()

# Let's get more x values - increments of 0.01

x <- seq(-4,4,.01)
y <- 1/sqrt(2*pi)*exp(-x^2/2)
plot(x,y,type="p",col="blue",cex=0.6,pch=19,main=snormpdf)
xlen <- length(x)
legend("topright",paste("N = ",xlen),cex=0.8)
grid()

# Let's work with the second version - I'll draw this a few times so I'll put it
# into a function for convenience.

drawNorm <- function(xs,style="l") {
  par(mfrow=c(1,1))
  ys <- 1/sqrt(2*pi)*exp(-xs^2/2)
  plot(xs,ys,lwd=2,type=style,col="blue",cex=0.6,pch=19,main=snormpdf,xaxt="n")
  axis(1,-4:4)
  xlen <- length(xs)
  legend("topright",paste("N = ",xlen),cex=0.8)
  legend("topleft","Total area under curve is 1",cex=0.8)
  abline(v=0,lty=3)
  grid()
}

drawNorm(x)

# Let's say we wanted to find the area underneath the curve
# in the shaded region.

xvals <- x[x > -4 & x < -1]
yvals <- 1/sqrt(2*pi)*exp(-xvals^2/2)
polygon(c(-4,xvals,-1),c(0,yvals,0),col="gray")
text(-1.5,0.05,"?",cex=1.5)

# Well we can integrate the function from -4 to -1 to give the answer
# Lucky for us R has an Integrate function.

func2integrate <- function(xvals) {
  return(1/sqrt(2*pi)*exp(-xvals^2/2))
}

results <- integrate(func2integrate,-4,-1)
round(results$value,2)    # Should be around 0.16

# What is the area of the curve between -1 and 4 ? Easy.
# 1 - 0.16 = 0.84

# So what if we wanted to determine the area for curves
# starting from -4 to -3, -4 to 3.0, -4 to -2, ... -4,4 ? 
# We could do our integration in a loop.

xvals <- seq(-4,4,1) 
areavec <- vector()
for (ii in xvals) {
  areavec <- c(areavec,integrate(func2integrate,-4,ii)$value)
}
areavec <- round(areavec,3)
names(areavec) <- paste(-4,-4:4,sep="_to_")
areavec

# Note we have symmetry 

drawNorm(x)
abline(v=0)

# Area under curve from -4 to 0 is 0.5. And the area from 0 to 4 is also 0.5
 
areavec

# If this symmetry is true then the area, for example, from -4 to -2 should then
# be the same as the area from 2 to 4 

# Let's put the polygon stuff into a function to make drawing the shaded 
# regions more convenient

shady <- function(vec,lim1,lim2,color="gray") {
  xs <- vec[vec > lim1 & vec < lim2]
  ys <- 1/sqrt(2*pi)*exp(-xs^2/2)
  polygon(c(lim1,xs,lim2),c(0,ys,0),col=color)  
}

shady(x,-4,-2,"green")
shady(x,2,4,"green")

# What is the area from -4 to -2 ? Approximately 0.023

areavec[3]

# To get the area from 2 to 4 we can subtract the area value
# corresponding to the integegration from -4 to 2 from 1

1 - areavec[7]
all.equal(as.numeric(areavec[3]),as.numeric(1-areavec[7]))

# It turns out that these areas represent probabilities. So we can
# start to ask questions like what is the probability associated with
# observing a value of 1.47 or less. we already know how to do this !
# do the integration.

drawNorm(x)
shady(x,-4,1.47,"green")
text(0,0.1,"?",cex=3)

probval <- integrate(func2integrate,-4,1.47)$value
text(0,0.2,round(probval,3))

# What then is the probability of observing a value of greater than 1.47 ?
# Super easy 

1 - probval 
1 - integrate(func2integrate,-4,1.47)$value

# Or this too - just change the limits on the integration

integrate(func2integrate,1.47,4)$value

# But we'll graph the problem anyway.

drawNorm(x)
shady(x,1.47,4)
text(2,0.02,"?")
text(2.5,0.1,round(integrate(func2integrate,1.47,4)$value,2))


# What is the probability of observing a value between -1 and 1 ?
# Graph it 

drawNorm(x)
shady(x,-1,1,col="blue")

# This is all getting to be too easy isn't it ? 

integrate(func2integrate,-1,1)$value

# Or 

integrate(func2integrate,-4,1)$value - integrate(func2integrate,-4,-1)$value

# Okay but R has some functions that will do this for us. That is 
# we don't need to do integration explicitly every time
# Check the pnorm function. It gives F(x) = P(X <= x)

pnorm(1) - pnorm(-1) # Probability of getting a number between -1 and 1

pnorm(1.47)  # Probability of getting a number of 1.47 or less

1 - pnorm(1.47) # Probability of getting a number > 1.47

pnorm(1.47,lower.tail=FALSE)

all.equal(pnorm(1.47,lower.tail=FALSE), 1 - pnorm(1.47) )

# Note that unless you tell pnorm otherwise it will assume a standard
# normal distribution with mean 0 and sd of 1. 

# What percentage of the data is contained within one standard of 
# the mean ? We did this already

integrate(func2integrate,-1,1)$value
pnorm(1) - pnorm(-1)

# What about two standard deviations ?

integrate(func2integrate,-2,2)$value
pnorm(2) - pnorm(-2)

# What about three ?

integrate(func2integrate,-3,3)$value
pnorm(3) - pnorm(-3)

# So use pnorm from now on. Also if we want to provide a bunch of x values
# as input to the standard normal function we can use the built in dnorm 
# function. So this:

somex <- seq(-4,4,.01)
normys <- 1/sqrt(2*pi)*exp(-somex^2/2)

# is more easily done as: 

dnormys <- dnorm(seq(-4,4,.01))

all.equal(normys,dnormys)

# Say we have some Normally distributed data that isn't 
# standardized - As long as we are confident that it's normal
# we can scale it / standardize it. (x - u) / sd()

somegrades <- dget("http://steviep42.bitbucket.org/YOUTUBE.DIR/grades")
summary(somegrades)

# Okay sowhat is the probability of someone getting a grade of 82 
# or less ?

standard <- (82 - mean(somegrades))/sd(somegrades)

# Cool so now we can use the pnorm function to find the prob associated
# with 1.215573 (which is what standard winds up being)

pnorm(standard)

# But hey ! pnorm takes arguments so we don't have to do the intermediate
# step with the standardization process.

pnorm(82,mean(somegrades),sd(somegrades))

all.equal(pnorm(standard),pnorm(82,mean(somegrades),sd(somegrades)))


# DONT USE INTEGRATE USE PNORM HERE !!!!!!!

# Let's reconisder the section from above where wanted to integrate
# regions from like -4 to -3, -4 to -2, -4 to -1,... -4 to 4 except here
# we will use a smaller increment so as to get more xvalues / granularity.

xvals <- seq(-4,4,0.1) 
areavec <- vector()
for (ii in xvals) {
  areavec <- c(areavec,pnorm(ii))
}
areavec <- round(areavec,3)

# Let's plot this. Does it look familiar ?

plot(xvals,areavec,type="l",lwd=2,main="Cumulative Distribution",xaxt="n")
axis(1,-4:4)
grid()

# How is this useful ? Well it let's us find the value associated with a
# given probability value. So what value from the standard normal distribution
# corresponds to the 50th percentile ? Easy - its 0. We learned this earlier 
# but we can easily read it off the graph. Or look into the areavec vector
# to see what element corresponds to 0.5

obs <- which(areavec-.50 == 0)
xvals[obs]

segments(-4,0.5,0,.5,lty=2)
segments(0,0,0,.5,lty=2)
#
xvals <- seq(-4,4,0.1) 
areavec <- vector()
for (ii in xvals) {
  areavec <- c(areavec,pnorm(ii))
}
areavec <- round(areavec,3)
