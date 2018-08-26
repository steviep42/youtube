# dplyr and pipes

library(dplyr)

data(mtcars)

mtcars

mtcars[mtcars$mpg > 17 & mtcars$am ==1, ]

# same as

subset(mtcars,mpg > 17 & am ==1)

# dplyr 

filter(mtcars, mpg > 17 & am == 1)

# same as 

mtcars %>% filter(mpg > 17 & am ==1 )

# Can write "programs" on one line
# Let's do some aggregation

mtcars %>% filter(mpg > 17 & am ==1 ) %>% 
  group_by(cyl) %>% 
  summarize(avg.mpg=mean(mpg))

# group by cyl, gear and summarize mpg

mtcars %>% filter(mpg > 17 & am ==1 ) %>% 
  group_by(cyl,gear) %>% 
  summarize(avg.mpg=mean(mpg))

# group by cyl, gear and summarize mpg and then sort by avg mpg descending

mtcars %>% filter(mpg > 17 & am ==1 ) %>% 
  group_by(cyl,gear) %>% 
  summarize(avg.mpg=mean(mpg)) %>%
  arrange(desc(round(avg.mpg,2)))

# Doing it the "old" way

mtcars.2 <- mtcars[mtcars$mpg > 17 & mtcars$am == 1,]
mtcars.2.agg <- aggregate(mpg~cyl+gear,mtcars.2,mean)
mtcars.2.agg[order(-mtcars.2.agg$mpg),]

# The pipes are good for generalizing

mtcars %>% ggplot(aes(x=mpg,fill=cyl)) + 
  geom_histogram(bins=12) + 
  labs(title="MPG Histogram", x="Miles per gallon", y="Count", 
       fill="# of Cylinders")

mtcars %>% ggplot(aes(x=mpg,fill=factor(cyl))) + 
  geom_histogram(bins=12) + 
  labs(title="MPG Histogram", x="Miles per gallon", y="Count", 
                                 fill="# of Cylinders")


mtcars %>% mutate(cyl=factor(cyl)) %>% ggplot(aes(x=mpg,fill=cyl)) + 
  geom_histogram(bins=12) + 
  labs(title="MPG Histogram", x="Miles per gallon", y="Count", 
       fill="# of Cylinders")
