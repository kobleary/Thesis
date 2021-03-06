library(stringr)

# ------------------- Recode bathrooms ------------------------
# Assumes that the bathrooms have been joined and are in the following ex. form: "HB1'FB1|HB2"
bths <- unique(testjoint5$bath)

# Initialize columns: f.baths = total full baths, h.baths = total half baths
testjoint5$f.baths <- NA
testjoint5$h.baths <- NA

extractBaths <- function(string){
  if(is.na(string)){c(fb = NA, hb = NA)}
  else{
    str <- strsplit(string, "[[:punct:]]")[[1]]
    str <- sort(str)
    fb <- str[grepl("FB", str)]
    hb <- str[grepl("HB", str)]
    nfb <- sum(as.numeric(gsub("FB", "", fb)))
    nhb <- sum(as.numeric(gsub("HB", "", hb)))
    c(fb = nfb, hb = nhb)
  }
}

# Create 2 x 34480 matrix of number of bathrooms
bath_matrix <- sapply(testjoint5$bath, extractBaths)
testjoint5$f.baths <- bath_matrix[1,]
testjoint5$h.baths <- bath_matrix[2,]


# ------------------- Recode fireplaces ------------------------
# I chose to treat all the fireplaces as the same and count the number of fireplaces/hearth
# That is fireplaces coded as MD2 = MODULAR 2 and BK1 = BRICK 1.
# Did this because it seems reasonable to think that differing styles/types of fireplaces
# won't have a measurable effect on property values. Can come back 
# to this decision, & check out the firelu table. 


extractHearth <- function(string){
  if(is.na(string)){NA}
  else{
    str <- strsplit(string, "[[:punct:]]")[[1]]
    length(str)
  }
}

testjoint5$n_fireplaces <- sapply(testjoint5$fireplace, extractHearth)



