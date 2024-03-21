x <- c("a", "b", "c", "c", "d", "a")
x[1]
x[1:4]
x[x > "a"]

u <- x > "a"
x[u]
u
x > "a"

x <- list(foo = 1:4, bar = 0.6)
x[1]

x[[1]]

x$bar
x[["bar"]]

x["bar"]

x <- list(foo = 1:4, bar = 0.6, baz = "hello")

x[c(1, 3)]

x <- matrix(1:6, 2, 3)
x
x[1, 2] # just returns vector of length 1
x[, 2]

x[1, 2, drop = FALSE] # preserves dimensions

x <- list(aardvark = 1:5)
x$a

x[["a"]]
x[["a", exact = FALSE]]

# removing NA values

x <- c(1, 2, NA, 4, NA, 5)
bad <- is.na(x)
x[!bad]

good <- !is.na(x)
x[good]

y <- c("a", "b", NA, "d", NA, "f")

good <- complete.cases(x, y)
good
x[good]
y[good]

# vectorized operations
x <- 1:4
y <- 6:9
x + y

x <- 4L
class(x)

x <- c(4, "a", TRUE)
class(x)
x

x <- c(1, 3, 5)
y <- c(3, 2, 10)

z <- rbind(x, y)
z

x <- list(2, "a", "b", TRUE)
x[[2]]
x[2]

x <- 1:4
y <- 2:3
z <- x + y
class(z)

x <- c(3, 5, 1, 10, 12, 6)
x[x <= 5] <- 0
x

x <- list(2, "a", "b", TRUE)
x[[1]]
class(x[[1]])

x <- 1:4
y <- 2
x + y

x <- c(3, 5, 1, 10, 12, 6)
#x[x < 6] <- 0
#x[x <= 5] <- 0
x[x %in% 1:5] <- 0
x


#data <- read.csv("hw1_data.csv", skip=151, nrow = 2)
data <- read.csv("hw1_data.csv")
data

ozone <- data[["Ozone"]]
ozone
missing <- is.na(ozone)
ozone[missing]
length(ozone[missing])
ozone[!missing]
mean(ozone[!missing])

newdata <- subset(data, Ozone > 31 & Temp > 90)
mean(newdata[["Solar.R"]])

newdata <- subset(data, Month == 6)
mean(newdata[["Temp"]])

newdata <- subset(data, Month == 5)
ozone <- newdata[["Ozone"]]
missing <- is.na(ozone)
ozone[!missing]
max(ozone[!missing])

x <- c(4, TRUE)
x
class(x)
