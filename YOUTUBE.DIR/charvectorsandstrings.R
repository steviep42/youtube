# BIOS 545 
# Character vectors vs cahracter strings
# Pittard

dna <- c("A","A","C","G","A","C","C","C","G",
        "G","A","T","G","A","C","T","G","A","A","C")

my.str <- paste(dna,collapse="")

length(my.str)

my.str

rev(my.str)

str(my.str)  

my.str <- paste(dna,collapse="")

substr(my.str,1,1)

substr(my.str,1,2)

substr(my.str,1,3)

substr(my.str,1,4)

gsub("G","TG",my.str)


my.str

substr(my.str,2,8)

substr(my.str,2,8) = "TTTTTTT"

my.str


nchar(my.str)

for (ii in 1:nchar(my.str)) {
  cat(substr(my.str,ii,ii))
}

for (ii in nchar(my.str):1) {
   cat(substr(my.str,ii,ii))
}


# Recipe to get the "collapsed" string back into a vector with
# separate elements for each letter

unlist(strsplit(my.str,""))

