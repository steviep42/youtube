# Using Colors with RColorBrewer

# See http://colorbrewer2.org/

# This exists to generate colors for maps but it can be used in
# other settings too. For example we can use colors to indicate
# increasing or decreasing values in a barplot. This is known
# as sequential colors. Rcolorbrewer generates palettes.

library(RColorBrewer)  # Load the library

# Create a table

library(ggplot2)
data(diamonds)
colortab <- table(diamonds$color)

# This produces a 7 element table which can be plotted using barplot

barplot(colortab)

# This can be improved considerably by 1) sort the table from hi to low
# and 2) by using a color scheme of related colors to indicate a decrease

# Let's sort the table from hi to low

colortab <- rev(sort(colortab))

colortab

# Okay so now the plot looks somewhat better but the monochrome colors
# doesn't help. 

barplot(colortab)

# Let's brew up some colors to help. We want what is known as a sequential
# set of colors. We'll need as many colors as there are bars in our plot
# 

# So first there is a command called display.brewer.all
brewer.pal(7,"Blues")

