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

rankstate <- function(statedata, outcome, num, variable_col, hospital_col) {

  # num validation
  if (is.numeric(num) && num > nrow(statedata)) {
    state <- statedata[1, ][["State"]]
    return(data.frame(hospital = NA, state = state))
  }

  order <- order(
    xtfrm(statedata[, variable_col]),
    xtfrm(statedata[, hospital_col])
  )
  ordered <- statedata[order, ]

  # Return the name for the hospital at the given rank
  if (num == "best") {
    num <- 1
  } else if (num == "worst") {
    num <- nrow(ordered)
  }

  df <- ordered[num, c(hospital_col, "State")]
  colnames(df) <- c("hospital", "state")
  df
}

# Returns a 2-column data frame containing 1) the name of the hospital with the
# given rank for the given outcome in each state, and 2) the state abbrev (e.g.
# "TX")
rankall <- function(outcome, num = "best") {
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

  base_name <- "Hospital.30.Day.Death..Mortality..Rates.from"
  variable_col <- paste(base_name, process_name(outcome), sep = ".")
  hospital_col <- "Hospital.Name"

  # Subset data to only the columns for hospital name and the given outcome
  cols <- c(hospital_col, "State", variable_col)
  mortality <- subset(data, select = cols)

  # Coerce outcome column to numeric and remove missing cases
  mortality[, variable_col] <- as.numeric(mortality[, variable_col])
  mortality <- mortality[complete.cases(mortality), ]

  statelist <- tapply(
    mortality,
    mortality$State,
    rankstate,
    outcome,
    num,
    variable_col,
    hospital_col
  )

  do.call(rbind, statelist)
}
