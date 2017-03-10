# Install the rvest package

library(rvest)
url <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"

my_html <- read_html(url)

# We'll access the first table from the web page. In this case this is
# easy since there is only one table. On pages with many tables this will
# be a trial and error process

my_tables <- html_nodes(my_html,"table")[[1]]
populous_table <- html_table(my_tables)

populous_table <- populous_table[,-4:-6]
populous_table$Population <- as.numeric(gsub(",","",populous_table$Population))/100000

names(populous_table) = c("Rank","Country","Population")

# Let's plot the first 10 rows

library(lattice)
xyplot(Population ~ as.factor(Country), populous_table[1:10,],
       scales = list(x = c(rot=60)),type="h",main="Most Densely Populated Countries")

