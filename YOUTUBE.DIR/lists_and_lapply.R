surname <- "Jones"
numofchild <- 2
ages <- c(5,7)
measles <- c("Y","N")

# Unnamed list 

family1 <- list(surname,numofchild,ages,measles)
family1[1]
family1[[1]]

family1[[3]]

# Named List

family1 <- list(name="Jones",numofchild=2,ages=c(5,7),measles=c("Y","N"))

lapply(family1, function(x) {if (is.numeric(x)) mean(x)})

myfunc <- function(x) {
  if (is.numeric(x)) {
    mean(x)
  }
} 

lapply(family1, myfunc)

for (ii in 1:length(family1)) {
  if (is.numeric(family1[[ii]])) {
     print(mean(family1[[ii]]))
  }
}

family2 <- list(name="Espinoza",numofchild=4,ages=c(5,7,9,11),measles=c("Y","N","Y","Y"))
family3 <- list(name="Ginsberg",numofchild=3,ages=c(9,13,18),measles=c("Y","N","Y"))
family4 <- list(name="Souza",numofchild=5,ages=c(3,5,7,9,11),measles=c("N","Y","Y","Y","N"))

allfams <- list(f1=family1,f2=family2,f3=family3,f4=family4)
str(allfams)

allfams$f3$ages

lapply(allfams, function(x) mean(x$ages))

unlist(lapply(allfams, function(x) mean(x$ages)))

mean(unlist(lapply(allfams, function(x) mean(x$ages))))

data(mtcars)
head(mtcars)

unique(mtcars$cyl)
mean(mtcars$mpg)

mtcars[mtcars$cyl==4,]
mtcars[mtcars$cyl==4,]$mpg

mean(mtcars[mtcars$cyl==4,]$mpg

mydfs <- split(mtcars,mtcars$cyl)
lapply(mydfs,function(x) mean(x$mpg))

lapply(split(mtcars,mtcars$cyl),function(x) mean(x$mpg))

unlist(lapply(split(mtcars,mtcars$cyl),function(x) mean(x$mpg)))

