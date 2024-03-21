corr <- function(directory, threshold = 0) {

  complete_cases <- complete(directory)
  above_threshold <- subset(complete_cases, nobs > threshold)
  ids <- above_threshold[["id"]]

  corrs <- numeric()
  for (i in ids) {
    filename <- paste(sprintf("%03d", i), ".csv", sep = "")
    data <- read.csv(file.path(directory, filename))
    completed <- data[complete.cases(data), ]
    nitrate_data <- completed[["nitrate"]]
    sulfate_data <- completed[["sulfate"]]

    corr <- cor(nitrate_data, sulfate_data)
    corrs <- c(corrs, corr)
  }

  corrs
}
