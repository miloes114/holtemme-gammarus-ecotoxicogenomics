args <- commandArgs(trailingOnly = TRUE)
read_arg <- function(flag, default) {
  pos <- match(flag, args)
  if (is.na(pos) || pos == length(args)) return(default)
  as.integer(args[[pos + 1L]])
}
from_step <- read_arg("--from", 1L)
to_step <- read_arg("--to", 8L)
full_inputs <- "--full-inputs" %in% args
if (is.na(from_step) || is.na(to_step) || from_step < 1L || to_step > 8L || from_step > to_step) stop("Expected 1 <= --from <= --to <= 8.")
project_dir <- normalizePath(Sys.getenv("HOLTEMME_PROJECT_DIR", unset = getwd()), winslash = "/", mustWork = TRUE)
steps <- utils::read.delim(file.path(project_dir, "config", "workflow_steps.tsv"), stringsAsFactors = FALSE, check.names = FALSE)
selected <- steps[steps$step >= from_step & steps$step <= to_step, , drop = FALSE]
required_source_files <- c(selected$source, "support/workflow_helpers.R", "support/wgcna_finalisation_helpers.R", "metadata/station_crosswalk.csv", "metadata/contrast_crosswalk.csv", "renv.lock")
missing_source_files <- required_source_files[!file.exists(file.path(project_dir, required_source_files))]
packages <- trimws(unlist(strsplit(paste(readLines(file.path(project_dir, "DESCRIPTION"), warn = FALSE), collapse = "\n"), "[,\n]")))
imports_start <- grep("^Imports:", packages)
imports <- if (length(imports_start)) trimws(packages[(imports_start + 1L):length(packages)]) else character()
imports <- imports[nzchar(imports) & !grepl("^Suggests:|^Package:|^Title:|^Version:|^Description:|^Authors|^License:|^Encoding", imports)]
missing_packages <- imports[!vapply(imports, requireNamespace, logical(1), quietly = TRUE)]
echo_version <- if (requireNamespace("EchoGO", quietly = TRUE)) as.character(utils::packageVersion("EchoGO")) else NA_character_
seed_files <- c("01_metadata/FORMAS_Metadata.xlsx", "02_inputs/counts_raw_gene_level.tabular", "02_inputs/tmm_normalized_expression.tabular", "02_inputs/STU_log10STU_per_site.tsv", "02_inputs/TU_per_site-chemical.tsv", "02_inputs/TU_per_site-MoA.tsv", "03_reference/Trinotate_report.tsv", "03_reference/Trinotate_gene_annotation_collapsed.csv", "03_reference/transcriptome_filtered.fasta", "03_reference/gene_to_transcript_map.tabular")
missing_seeds <- seed_files[!file.exists(file.path(project_dir, seed_files))]
cat("Holtemme workflow preflight\nProject: ", project_dir, "\nSteps: ", from_step, " to ", to_step, "\nR: ", R.version.string, "\n", sep = "")
cat("Source files: ", length(required_source_files) - length(missing_source_files), "/", length(required_source_files), "\n", sep = "")
cat("Packages: ", length(imports) - length(missing_packages), "/", length(imports), "; EchoGO=", echo_version, "\n", sep = "")
if (length(missing_source_files)) cat("Missing source files:\n", paste0("  - ", missing_source_files, collapse = "\n"), "\n")
if (length(missing_packages)) cat("Missing packages:\n", paste0("  - ", missing_packages, collapse = "\n"), "\n")
if (!identical(echo_version, "0.1.4")) cat("EchoGO must be restored at version 0.1.4 from renv.lock.\n")
if (full_inputs) {
  cat("Frozen inputs: ", length(seed_files) - length(missing_seeds), "/", length(seed_files), "\n", sep = "")
  if (length(missing_seeds)) cat("Missing frozen inputs:\n", paste0("  - ", missing_seeds, collapse = "\n"), "\n")
}
if (length(missing_source_files) || length(missing_packages) || !identical(echo_version, "0.1.4") || (full_inputs && length(missing_seeds))) quit(status = 1L, save = "no")
cat("Preflight passed.\n")

