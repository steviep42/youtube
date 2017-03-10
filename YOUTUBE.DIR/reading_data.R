# Reading data from .csv files and other formats
# Data comes from Blanca Vargas-Govea, Juan Gabriel GonzÃ¡lez-Serna, Rafael Ponce-Mede

# There are a number of ways we can read files. But first here is a small review of how
# to use R commands to see what files you have in a given folder. You can always manage
# files externally if you want. For example you can download them and unzip them using
# your operating system. In RStudio you can move around your hard drive also and do things.
# But R has some commands you can use directly.

# list.files()                # Shows you files in your current directory
# dir.create("some_folder")   # Creates a new folder
# getwd()                     # Shows you what folder you are currently in
# setwd("some_folder_path")   # Changes to a new folder location


# Let's download a CSV file and then read it in.

download.file("http://steviep42.bitbucket.org/data/userprofile.csv","userprofile.csv")
file.info("userprofile.csv")  # Works on all Operating systems

# These next two are specific to UNIX and Mac OSX

system("ls -lh userprofile.csv")   # How big is the file ? 
system("wc -l userprofile.csv")    # How many lines does it have ? 

# Next we read it in. However, we have to first know if the file has a header row
# Sometimes we know this in advance or we can use our favorite operating system
# command to look at the first few lines of the file to see if there is a header

system("head -2 userprofile.csv")   # Specific to UNIX and Mac OSX

# Note that Windows users can install the GNU utilities to get access to many cool
# UNIX type commands. See http://unxutils.sourceforge.net/

# To read the file we can read it from the hard drive or directly from the
# internet

myFile <- read.table("userprofile.csv",header=T,sep=",")

# Or

url <- "http://steviep42.bitbucket.org/data/userprofile.csv"

myFile <- read.table(url,header=T,sep=",")

names(myFile)   # Get the names of the columns

str(myFile)  # Shows us the structure of each column.

# By default R turns strings into factors but if we don't want that we can 
# pass an option to indicate that

myFile <- read.table("userprofile.csv",header=T,sep=",",stringsAsFactors=FALSE)
str(myFile)

# Sometimes it is best to read in just a few lines of a file to see what types of
# data we have. This happens if we don't have access to a description or a code book 
# for the data

myFile <- read.table("userprofile.csv",header=T,sep=",",nrows=5)

# Once we see what type of data we have then we can go back in and read the
# entire file using the "colClasses" option to tell R what the types of columns are
# If we don't provide the colClasses argument then R will guess what format
# the types are. If we tell R what they are then it helps with memory allocation.

myFile <- read.table("userprofile.csv",header=T,sep=",",nrows=5)
classes <- sapply(myFile,class)
myFile <- read.table("userprofile.csv",header=T,sep=",",colClasses=classes)

# Note that you don't have to download the file. You can read it directly from the 
# Internet using the URL

url <- "http://steviep42.bitbucket.org/data/userprofile.csv"
mydata <- read.table(url,header=T,sep=",")

# We can also read zip files from within R but it is a bit more involved.

url <- "http://steviep42.bitbucket.org/data/SFFoodProgram_Complete_Data.zip"
dir.create("temp_dir")    # create a directory to hold the zip file

setwd("temp_dir")
download.file(url,"SFFood.zip")
system("unzip -l SFFood.zip")  # Lists the files - On MS Windows this won't work.

businesses  <- read.csv(unz("SFFood.zip","businesses_plus.csv"),header=T,stringsAsFactors=F)


## Reading spreadsheets 

# The recommended way is to save the ss to a .csv file
# and then read it in using read.table  There is a package that will try to directly
# read the spreadsheet itself. You need to install a package called "gdata"

library(gdata)
data <- read.xls("http://steviep42.bitbucket.org/data/example_excel_spreadsheet.xlsx")

# Listing files in a directory. Sometimes you know in advance what files you want to read in
# Other times you will download a zip file, unzip it, and then need to look through the filenames
# to decided which ones you want to open and process. 


