# Format output name so it can be appended as part of the column name in the 
# dataset
# e.g. "heart attack" -> "Heart.Attack"
process_name <- function(name) {
  titled <- tools::toTitleCase(name)
  split <- strsplit(titled, " ")
  unlisted <- unlist(split)
  finished <- paste(unlisted, collapse = ".")
  finished
}

# Returns the name of the hospital with the given rank for the given outcome in
# the given state
rankhospital <- function(state, outcome, num) {
  # Outcome validation
  if (
    outcome != "heart failure"
    && outcome != "heart attack"
    && outcome != "pneumonia"
  ) {
    stop("invalid outcome")
  }

  # num validation if num is character
  if (is.character(num) && (num != "best" && num != "worst")) {
    stop("invalid num: must be integer (>= 1) or \"best\" or \"worst\"")
  }

  # num validation if num is numeric
  if (is.numeric(num) && (num < 1)) {
    stop("invalid num: must be integer (>= 1) or \"best\" or \"worst\"")
  }

  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

  # State validation
  states <- unique(data$State)
  if (! state %in% states) {
    stop("invalid state")
  }

  base_name <- "Hospital.30.Day.Death..Mortality..Rates.from"
  variable_col <- paste(base_name, process_name(outcome), sep = ".")
  hospital_col <- "Hospital.Name"

  # Subset data to only the given state
  state_data <- data[data$State == state, ]

  # Subset data to only the columns for hospital name and the given outcome
  cols <- c(hospital_col, variable_col)
  mortality <- subset(state_data, select = cols)

  # Coerce outcome column to numeric and remove missing cases
  mortality[, variable_col] <- as.numeric(mortality[, variable_col])
  mortality <- mortality[complete.cases(mortality), ]

  # num validation
  if (is.numeric(num) && num > nrow(mortality)) {
    return(NA)
  }

  order <- order(
    xtfrm(mortality[, variable_col]),
    xtfrm(mortality[, hospital_col])
  )
  ordered <- mortality[order, ]

  # Return the name for the hospital at the given rank
  if (num == "best") {
    num <- 1
  } else if (num == "worst") {
    num <- nrow(ordered)
  }

  ordered[num, ][[hospital_col]]
}
