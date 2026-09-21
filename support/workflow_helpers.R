sync_rstudio_pandoc <- function() {
  if (!nzchar(Sys.getenv("RSTUDIO_PANDOC"))) {
    pandoc_candidate <- "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools"
    if (dir.exists(pandoc_candidate)) {
      Sys.setenv(RSTUDIO_PANDOC = pandoc_candidate)
    }
  }
}

get_station_crosswalk <- function(project_dir = getwd()) {
  readr::read_csv(
    file.path(project_dir, "metadata", "station_crosswalk.csv"),
    show_col_types = FALSE
  )
}

get_contrast_crosswalk <- function(project_dir = getwd()) {
  readr::read_csv(
    file.path(project_dir, "metadata", "contrast_crosswalk.csv"),
    show_col_types = FALSE
  )
}

validate_holtemme_station_labels <- function(station_tbl, contrast_tbl) {
  expected_station_map <- c(
    "HOL01" = "H2",
    "HOL02" = "H3",
    "HOL03" = "H4",
    "HOL04" = "H5",
    "HOL05" = "H6",
    "HOL06" = "H7"
  )
  observed_station_map <- stats::setNames(
    as.character(station_tbl$station_tag),
    as.character(station_tbl$legacy_site_id)
  )

  if (
    !all(names(expected_station_map) %in% names(observed_station_map)) ||
    !identical(
      unname(observed_station_map[names(expected_station_map)]),
      unname(expected_station_map)
    )
  ) {
    stop(
      "Invalid Holtemme station crosswalk. Expected HOL01-HOL06 to map ",
      "exactly to H2-H7, with HOL01/H2 as the upstream reference and ",
      "HOL06/H7 as the furthest downstream site."
    )
  }

  expected_contrast_labels <- c(
    "HOL02_vs_HOL01" = "H3 vs H2",
    "HOL03_vs_HOL01" = "H4 vs H2",
    "HOL04_vs_HOL01" = "H5 vs H2",
    "HOL05_vs_HOL01" = "H6 vs H2",
    "HOL05_vs_HOL04" = "H6 vs H5",
    "HOL06_vs_HOL01" = "H7 vs H2"
  )
  observed_contrast_labels <- stats::setNames(
    as.character(contrast_tbl$display_label),
    as.character(contrast_tbl$contrast_id)
  )

  if (
    !all(names(expected_contrast_labels) %in% names(observed_contrast_labels)) ||
    !identical(
      unname(observed_contrast_labels[names(expected_contrast_labels)]),
      unname(expected_contrast_labels)
    )
  ) {
    stop(
      "Invalid Holtemme contrast labels. The canonical reference is H2/HOL01 ",
      "and the furthest downstream contrast is H7 vs H2/HOL06_vs_HOL01."
    )
  }

  invisible(TRUE)
}

get_publication_labels <- function(project_dir = getwd()) {
  station_tbl <- get_station_crosswalk(project_dir)
  contrast_tbl <- get_contrast_crosswalk(project_dir)
  validate_holtemme_station_labels(station_tbl, contrast_tbl)

  list(
    site_levels_legacy = station_tbl$legacy_site_id,
    site_levels_simple = station_tbl$station_tag,
    site_label_map = stats::setNames(station_tbl$station_tag, station_tbl$legacy_site_id),
    site_display_map = stats::setNames(station_tbl$display_label, station_tbl$legacy_site_id),
    contrast_label_map = stats::setNames(contrast_tbl$display_label, contrast_tbl$contrast_id),
    station_tbl = station_tbl,
    contrast_tbl = contrast_tbl
  )
}

get_reference_site_id <- function(project_dir = getwd(), station_tag = "H2") {
  station_tbl <- get_station_crosswalk(project_dir)
  station_tbl$legacy_site_id[match(station_tag, station_tbl$station_tag)]
}

map_site_tags <- function(x, project_dir = getwd()) {
  labels <- get_publication_labels(project_dir)
  out <- labels$site_label_map[as.character(x)]
  ifelse(is.na(out), as.character(x), unname(out))
}

map_contrast_labels <- function(x, project_dir = getwd()) {
  labels <- get_publication_labels(project_dir)
  out <- labels$contrast_label_map[as.character(x)]
  ifelse(is.na(out), as.character(x), unname(out))
}

make_results_dir <- function(project_dir = getwd(), step_id, step_stub) {
  file.path(project_dir, sprintf("Results_%02d_%s", step_id, step_stub))
}

