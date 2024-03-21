complete <- function(directory, id = 1:332) {

  complete_cases <- data.frame(id = numeric(0), nobs = numeric(0))

  for (i in id) {
    filename <- paste(sprintf("%03d", i), ".csv", sep = "")
    data <- read.csv(file.path(directory, filename))
    newrow <- data.frame(id = i, nobs = sum(complete.cases(data)))
    complete_cases <- rbind(complete_cases, newrow)
  }

  complete_cases
}
