# matrics are vectors with dimension

# basic
m <- matrix(1:6, nrow = 2, ncol = 3)
m
attributes(m)

# matrixize a vector

## start with vector
m <- 1:10

## apply dimensions
dim(m) <- c(2, 5)
m

data <- read.table("foo.csv")


# dput

y <- data.frame(a = 1, b = "a")
dput(y)
