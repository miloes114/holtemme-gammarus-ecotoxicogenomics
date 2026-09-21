args <- commandArgs(trailingOnly = TRUE)
project_dir <- normalizePath(Sys.getenv("HOLTEMME_PROJECT_DIR", unset = getwd()), winslash = "/", mustWork = TRUE)
if (getRversion() != "4.4.3") stop("This workflow was validated with R 4.4.3; found ", getRversion(), ".")
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
}
renv::restore(project = project_dir, prompt = FALSE)
if (!requireNamespace("EchoGO", quietly = TRUE) || utils::packageVersion("EchoGO") != "0.1.4") {
  stop("renv restore did not provide the required EchoGO 0.1.4 dependency.")
}
cat("Bootstrap completed for ", project_dir, "\n", sep = "")

