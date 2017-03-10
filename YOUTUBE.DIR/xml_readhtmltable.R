# Pittard, Steve
# 11/17/14 - Reading Tables from web pages using readHTMLTable from the XML package

# The XML package has a number of capabilities one of which is to read and parse HTML
# from arbitrary webpages. Let's get the population table on the following Wikipedia page
# http://en.wikipedia.org/wiki/List_of_countries_by_population Maybe we would like to 
# turn this into a data frame within R. 


library(XML)  # Load the package
url <- "https://en.wikipedia.org/wiki/List_of_countries_by_population"

# We need to tell the readHTMLTable function what table we want to read in.
# There appears to be only 1 table on the page so let's provide that info

poptable <- readHTMLTable(url,which=1)
head(poptable)  

# We have a data frame with the desired information although
# the classes of the columns aren't quite what we want.

str(poptable)   # Every column is a factor. That's not what we want. 

# We'll we could work with the data after the fact and transform it. As an example
# we could use the gsub command to eliminate the commas in the numbers

mean(poptable$Population)    # Fails because Population is a factor
poptable$Population[1:5]    # Shows the first 5 values in the Population vector
poptable$Population <- gsub(",","",poptable$Population)
mean(poptable$Population)
str(poptable$Population) 


# Oh so the Population is still a character. We need to turn it into a numeric

poptable$Population <- as.numeric(poptable$Population)
mean(poptable$Population)
str(poptable$Population)

# This could get tedious if we had a lot things we had a lot of columns that needed
# similar processing. It's easier to use the colClasses argument when reading the table.
# We tell readHTMLTable what type each column should be.

# In addition to the usual "integer", "numeric", "logical", "character", etc. names of R 
# data types, one can use "FormattedInteger", "FormattedNumber" and "Percent" to specify 
# that format of the values are numbers possibly with commas (,) separating groups of 
# digits or a number followed by a percent sign (%).

# We can also tell the function that we don't want character strings to be automatically
# changed to factors. use the "stringsAsFactors" argument

classes <- c("integer","character","FormattedNumber","character","Percent","character")
poptable <- readHTMLTable(url,which=1,colClasses=classes,stringsAsFactors=F)

str(poptable)    # Looks pretty good now.

# What about the date field ? Well unfortunately there is no way to easily convert that
# using colClasses. So if we really want to convert it to a date we have to do it manually
# But it isn't hard. We just need to match the format given in the data. Look at the help
# page for strptime for more information on what tokens to use.

poptable$Date <- strptime(poptable$Date,format="%B %d, %Y")
str(poptable$Date)

# That's cool. The Date variable is now a "real" date. If we wanted to we could do date
# arithmetic or filter on date ranges. But here we don't really need to.

poptable$Date > strptime("07/04/14",format="%m/%d/%y")

# If you look at all the Dates you will see that a few of them are NA because the way
# they appeared in the original table did not conform to the format. %m/%d/%y. 
# For example looking at Kosovo you see they have just "2014" as the date. So
# to handle these then you would need to write some logic to handle this but that is
# left as an exercise. 

