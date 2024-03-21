pollutantmean <- function(directory, pollutant, id = 1:332) {

  rows <- 0
  sum <- 0

  for (i in id) {
    filename <- paste(sprintf("%03d", i), ".csv", sep = "")
    data <- read.csv(file.path(directory, filename))
    pollutant_data <- data[pollutant]
    pollutant_data <- pollutant_data[!is.na(pollutant_data)]

    sum <- sum + sum(pollutant_data)
    rows <- rows + length(pollutant_data)
  }

  sum / rows
}
