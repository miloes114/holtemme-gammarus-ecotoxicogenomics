project_dir <- normalizePath(Sys.getenv("HOLTEMME_PROJECT_DIR", unset = getwd()), winslash = "/", mustWork = TRUE)
lockfile <- file.path(project_dir, "renv.lock")
if (!file.exists(lockfile)) stop("Missing renv.lock.")
if (!requireNamespace("renv", quietly = TRUE)) stop("renv is required to audit renv.lock.")
lock <- renv:::renv_lockfile_read(lockfile)
echo <- lock$Packages$EchoGO
if (is.null(echo) || !identical(echo$Version, "0.1.4") || !identical(echo$Source, "GitHub") || !identical(echo$RemoteSha, "dcf41371b20cccb2914852dc2c0436ecba62c559")) {
  stop("renv.lock does not contain the validated immutable EchoGO 0.1.4 pin.")
}
cat("R lock: ", lock$R$Version, "\n", sep = "")
cat("Locked packages: ", length(lock$Packages), "\n", sep = "")
cat("EchoGO: ", echo$Version, " @ ", echo$RemoteSha, "\n", sep = "")

