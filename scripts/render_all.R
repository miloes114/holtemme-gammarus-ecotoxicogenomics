args <- commandArgs(trailingOnly = TRUE)

read_arg <- function(flag, default) {
  pos <- match(flag, args)
  if (is.na(pos) || pos == length(args)) return(default)
  as.integer(args[[pos + 1L]])
}

from_step <- read_arg("--from", 1L)
to_step <- read_arg("--to", 8L)
if (is.na(from_step) || is.na(to_step) || from_step < 1L || to_step > 8L || from_step > to_step) {
  stop("Expected 1 <= --from <= --to <= 8.")
}

project_dir <- normalizePath(
  Sys.getenv("HOLTEMME_PROJECT_DIR", unset = getwd()),
  winslash = "/",
  mustWork = TRUE
)
setwd(project_dir)

project_library <- file.path(project_dir, "environment", "R-library")
if (dir.exists(project_library)) .libPaths(c(project_library, .libPaths()))
if (!requireNamespace("rmarkdown", quietly = TRUE)) stop("Package 'rmarkdown' is required.")

steps <- read.delim(
  file.path(project_dir, "config", "workflow_steps.tsv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
steps <- steps[steps$step >= from_step & steps$step <= to_step, , drop = FALSE]

for (i in seq_len(nrow(steps))) {
  step_i <- steps$step[[i]]
  message(sprintf("Rendering Step %02d: %s", step_i, steps$source[[i]]))
  params_i <- if (step_i == 6L) {
    list(qc_mode = "manuscript-lock", require_native_gene_trace_at_lock = FALSE)
  } else {
    NULL
  }
  rmarkdown::render(
    input = steps$source[[i]],
    output_file = file.path("reports", steps$report[[i]]),
    params = params_i,
    envir = new.env(parent = globalenv()),
    quiet = FALSE
  )
}

