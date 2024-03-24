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

# Returns the name of the hospital with the best outcome for the given state
# and outcome
best <- function(state, outcome) {

  # Outcome validation
  if (
    outcome != "heart failure"
    && outcome != "heart attack"
    && outcome != "pneumonia"
  ) {
    stop("invalid outcome")
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

  # Order the dataframe first by outcome, then by hospital name
  order <- order(
    xtfrm(mortality[, variable_col]),
    xtfrm(mortality[, hospital_col])
  )
  ordered <- mortality[order, ]


  # Remove any rows with the same value for outcome
  # The hospital name with the "lowest" sort order will be left
  ordered <- ordered[rownames(unique(ordered[variable_col])), ]

  # Return the name for the first hospital in the data frame
  head(ordered, 1)[[hospital_col]]
}
