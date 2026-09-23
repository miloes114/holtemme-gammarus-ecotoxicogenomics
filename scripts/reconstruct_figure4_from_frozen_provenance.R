args <- commandArgs(trailingOnly = TRUE)
source_path <- args[[1L]]
out_dir <- args[[2L]]
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
suppressPackageStartupMessages({ library(ggplot2); library(dplyr); library(tidyr); library(patchwork) })
family_cells <- read.delim(source_path, sep = "\t", check.names = FALSE, stringsAsFactors = FALSE)
bool <- function(x) toupper(as.character(x)) %in% c("TRUE", "T", "1", "YES")
family_cells <- family_cells %>% mutate(display_in_figure = if ("display_in_figure" %in% names(.)) bool(display_in_figure) else TRUE, n_semantic_features_total = as.integer(n_semantic_features_total), n_target_supported_features = as.integer(n_target_supported_features), n_TARGET_PLUS_CONTEXT_features = as.integer(n_TARGET_PLUS_CONTEXT_features), n_matched_background_hypothesis_features = as.integer(n_matched_background_hypothesis_features), n_default_domain_exploratory_only_features = as.integer(n_default_domain_exploratory_only_features)) %>% filter(display_in_figure)
contrasts <- data.frame(contrast_label = c("H3 vs H2", "H4 vs H2", "H5 vs H2", "H6 vs H2", "H6 vs H5", "H7 vs H2"), stringsAsFactors = FALSE); onts <- c("BP", "MF", "CC")
family_order <- list(BP = c("Oxidative stress and detoxification", "DNA maintenance and genotoxic stress", "Proteostasis, translation, and RNA processing", "Energy and primary metabolism", "Lipid and membrane remodelling", "Transport and intracellular trafficking", "Cell signalling and regulation", "Ion transport and homeostasis", "Immune, inflammatory, and hemostatic responses", "Development, adhesion, and cytoskeletal remodelling", "Neurophysiology and synaptic function", "Reproduction, mating, and fertilization", "Cell stress, turnover, and catabolism"), MF = c("Translation and ribosome-associated activity", "Nucleic-acid binding and processing", "Oxidoreductase and redox activity", "Carbohydrate, lipid, and small-molecule metabolic activity", "Small-molecule and cofactor binding", "Protein modification, folding, and proteolysis", "Transferase and kinase activity", "Transporter and channel activity", "Receptor, ligand, and signalling activity", "Cytoskeletal, motor, and structural activity", "Hydrolase and catabolic activity"), CC = c("Ribosome and translation complexes", "Nuclear and chromatin compartments", "Nuclear transport and pore complexes", "Mitochondrial and energy-associated compartments", "Endomembrane and organelle-lumen compartments", "Plasma membrane and cell-surface structures", "Cytoskeleton, cortex, and cell projections", "Cell junctions and adhesion structures", "Extracellular compartments", "Cytosol and cytoplasmic bodies"))
panel_colours <- list(BP = c(exploratory = "#FCE9E7", matched = "#D95F59", target = "#8B1E1E"), MF = c(exploratory = "#E9F4EC", matched = "#4AA36A", target = "#165C38"), CC = c(exploratory = "#E9F2F8", matched = "#4D91C1", target = "#0D4F73")); panel_titles <- c(BP = "A. Biological Process response families", MF = "B. Molecular Function activity families", CC = "C. Cellular Component families"); title_colours <- c(BP = "#8B1E1E", MF = "#165C38", CC = "#0D4F73")
build_publication_panel_tbl <- function(family_cells, ontology_i, family_order_i, contrast_levels) { present <- unique(family_cells$functional_family[family_cells$ontology == ontology_i]); present <- present[!is.na(present) & nzchar(present) & present != "Other/unclassified"]; displayed <- c(family_order_i[family_order_i %in% present], setdiff(present, family_order_i)); tidyr::expand_grid(contrast_label = contrast_levels, functional_family = displayed) %>% dplyr::left_join(family_cells %>% dplyr::filter(ontology == ontology_i), by = c("contrast_label", "functional_family")) %>% dplyr::mutate(ontology = ontology_i, n_semantic_features_total = dplyr::coalesce(n_semantic_features_total, 0L), n_target_supported_features = dplyr::coalesce(n_target_supported_features, 0L), n_matched_background_hypothesis_features = dplyr::coalesce(n_matched_background_hypothesis_features, 0L), n_default_domain_exploratory_only_features = dplyr::coalesce(n_default_domain_exploratory_only_features, 0L), n_target_plus_matched = n_target_supported_features + n_matched_background_hypothesis_features, present = n_semantic_features_total > 0L, contrast_label = factor(contrast_label, levels = contrast_levels), display_row = factor(functional_family, levels = rev(displayed))) }
publication_landscape_theme_large <- function(title_colour) { ggplot2::theme_minimal(base_size = 14) + ggplot2::theme(panel.background = ggplot2::element_rect(fill = "#FCFCFB", colour = NA), panel.border = ggplot2::element_rect(colour = "#C7CFD1", fill = NA, linewidth = 0.45), panel.grid.minor = ggplot2::element_blank(), panel.grid.major = ggplot2::element_line(colour = "#E2E6E7", linewidth = 0.35), axis.text.x = ggplot2::element_text(angle = 18, hjust = 1, vjust = 1, face = "bold", size = 13, colour = "#263238"), axis.text.y = ggplot2::element_text(face = "plain", size = 13.5, colour = "#263238"), axis.title = ggplot2::element_blank(), plot.title = ggplot2::element_text(face = "bold", size = 17, colour = title_colour, margin = ggplot2::margin(b = 4)), plot.margin = ggplot2::margin(t = 5, r = 10, b = 5, l = 14), legend.position = "none") }
plot_nested_publication_panel <- function(panel_tbl, panel_title, colours, title_colour, show_counts, size_limits, size_breaks) { p <- ggplot2::ggplot(panel_tbl, ggplot2::aes(x = contrast_label, y = display_row)) + ggplot2::geom_point(shape = 21, size = 1.8, stroke = 0.20, colour = "grey88", fill = "white") + ggplot2::geom_point(data = panel_tbl %>% dplyr::filter(n_semantic_features_total > 0L), ggplot2::aes(size = n_semantic_features_total), shape = 21, fill = colours[["exploratory"]], colour = "grey55", stroke = 0.35) + ggplot2::geom_point(data = panel_tbl %>% dplyr::filter(n_target_plus_matched > 0L), ggplot2::aes(size = n_target_plus_matched), shape = 21, fill = colours[["matched"]], colour = "grey30", stroke = 0.45) + ggplot2::geom_point(data = panel_tbl %>% dplyr::filter(n_target_supported_features > 0L), ggplot2::aes(size = n_target_supported_features), shape = 21, fill = colours[["target"]], colour = "black", stroke = 0.60) + ggplot2::scale_size_area(limits = size_limits, breaks = size_breaks, max_size = 14, guide = "none") + ggplot2::labs(title = panel_title, x = NULL, y = NULL) + publication_landscape_theme_large(title_colour); if (isTRUE(show_counts)) p <- p + ggplot2::geom_text(data = panel_tbl %>% dplyr::filter(n_semantic_features_total >= 2L), ggplot2::aes(label = n_semantic_features_total), position = ggplot2::position_nudge(x = 0.08, y = 0.16), size = 3.05, fontface = "plain", colour = "#263238", inherit.aes = TRUE); p }
make_publication_legend_strip_large <- function(size_limits, size_breaks) {
  # Use the full strip, including space beneath the family labels, so the key
  # stays readable at journal width without changing the scientific panels.
  size_df <- data.frame(
    x = seq(0.6, 3.6, length.out = length(size_breaks)),
    y = 0.50, n = size_breaks
  )
  state_df <- data.frame(
    x = c(5.1, 7.0, 8.9, 10.8, 12.7), y = 0.50,
    label = c("Target-supported\nonly", "Matched-background\nonly",
              "Exploratory\nonly", "Target-supported\n+ exploratory",
              "Matched-background\n+ exploratory"),
    fill = c("#42484D", "#AEB7BC", "#E6EBED", "#E6EBED", "#E6EBED"),
    outline = c("#1F2326", "#657075", "#899398", "#899398", "#899398"),
    diameter = rep(10, 5)
  )
  mixed_df <- data.frame(
    x = c(10.8, 12.7), y = 0.50,
    fill = c("#42484D", "#AEB7BC"),
    outline = c("#1F2326", "#657075")
  )
  legend <- ggplot2::ggplot() +
    ggplot2::geom_point(
      data = size_df, ggplot2::aes(x = x, y = y, size = n),
      shape = 21, fill = "#FCFCFB", colour = "#263238", stroke = 0.55
    ) +
    ggplot2::scale_size_area(limits = size_limits, max_size = 14, guide = "none") +
    ggplot2::geom_text(
      data = size_df, ggplot2::aes(x = x, label = n),
      y = -0.90, size = 4.2, colour = "#263238"
    ) +
    ggplot2::geom_point(
      data = state_df, ggplot2::aes(x = x, y = y, fill = fill, colour = outline),
      size = state_df$diameter, shape = 21, stroke = 0.60
    ) +
    ggplot2::geom_point(
      data = mixed_df, ggplot2::aes(x = x, y = y, fill = fill, colour = outline),
      size = 6, shape = 21, stroke = 0.60
    ) +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_colour_identity() +
    ggplot2::geom_text(
      data = state_df, ggplot2::aes(x = x, label = label),
      y = -0.90, size = 4.2, lineheight = 0.95, colour = "#263238"
    ) +
    ggplot2::annotate("text", x = 0.12, y = 1.60,
                      label = "Semantic features", hjust = 0, fontface = "bold",
                      size = 4.9, colour = "#263238") +
    ggplot2::annotate("text", x = 4.35, y = 1.60,
                      label = "Observed evidence states", hjust = 0, fontface = "bold",
                      size = 4.9, colour = "#263238") +
    ggplot2::annotate("text", x = 8.25, y = 1.60,
                      label = "Mixed evidence is nested; panel shades follow ontology colours",
                      hjust = 0, size = 3.6, colour = "#263238") +
    ggplot2::coord_cartesian(xlim = c(0, 13.8), ylim = c(-1.25, 1.15),
                             expand = FALSE, clip = "off") +
    ggplot2::labs(title = " ") +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 14, margin = ggplot2::margin(b = 7)),
      plot.margin = ggplot2::margin(4, 12, 6, 12)
    )
  # Isolate legend alignment from the long y-axis labels of the main panels.
  patchwork::free(legend, type = "panel", side = "l")
}
publication_panels <- lapply(onts, function(o) build_publication_panel_tbl(family_cells, o, family_order[[o]], contrasts$contrast_label)); names(publication_panels) <- onts; panel_row_counts <- vapply(publication_panels, function(x) length(unique(x$functional_family)), integer(1)); max_semantic_features <- max(vapply(publication_panels, function(x) max(x$n_semantic_features_total, 0L), numeric(1))); size_limits <- c(0, max_semantic_features); size_breaks <- sort(unique(c(1L, if (max_semantic_features >= 3L) 3L, if (max_semantic_features >= 5L) 5L, max_semantic_features))); size_breaks <- size_breaks[size_breaks <= max_semantic_features]

evidence_state_audit <- dplyr::bind_rows(
  publication_panels,
  .id = "panel"
) %>%
  dplyr::filter(.data$n_semantic_features_total > 0L) %>%
  dplyr::mutate(
    has_target = .data$n_target_supported_features > 0L,
    has_matched = .data$n_matched_background_hypothesis_features > 0L,
    has_exploratory = .data$n_default_domain_exploratory_only_features > 0L,

    evidence_state = dplyr::case_when(
      has_target & has_matched & has_exploratory ~
        "target + matched + exploratory",

      has_target & has_matched ~
        "target + matched",

      has_target & has_exploratory ~
        "target + exploratory",

      has_matched & has_exploratory ~
        "matched + exploratory",

      has_target ~
        "target only",

      has_matched ~
        "matched only",

      has_exploratory ~
        "exploratory only",

      TRUE ~
        "none"
    )
  ) %>%
  dplyr::count(.data$evidence_state, name = "n_family_cells") %>%
  dplyr::arrange(dplyr::desc(.data$n_family_cells))

write.table(
  evidence_state_audit,
  file.path(out_dir, "figure4_evidence_state_audit.tsv"),
  sep = "\t",
  row.names = FALSE,
  quote = FALSE
)

print(evidence_state_audit)
bp_large <- plot_nested_publication_panel(publication_panels$BP, panel_titles[["BP"]], panel_colours$BP, title_colours[["BP"]], FALSE, size_limits, size_breaks); mf_large <- plot_nested_publication_panel(publication_panels$MF, panel_titles[["MF"]], panel_colours$MF, title_colours[["MF"]], FALSE, size_limits, size_breaks); cc_large <- plot_nested_publication_panel(publication_panels$CC, panel_titles[["CC"]], panel_colours$CC, title_colours[["CC"]], FALSE, size_limits, size_breaks); large_main <- patchwork::wrap_plots(bp_large, mf_large, cc_large, ncol = 1, heights = pmax(panel_row_counts, 4)); large_legend <- make_publication_legend_strip_large(size_limits, size_breaks); large_clean <- patchwork::wrap_plots(large_main, large_legend, ncol = 1, heights = c(sum(pmax(panel_row_counts, 4)), 1.90))
large_width <- 13.5; large_height <- 15.2; large_preview_width <- 7.48; large_stem <- file.path(out_dir, "figure4_functional_response_landscape"); ggplot2::ggsave(paste0(large_stem, ".pdf"), large_clean, width = large_width, height = large_height, units = "in", limitsize = FALSE); ggplot2::ggsave(paste0(large_stem, ".png"), large_clean, width = large_width, height = large_height, units = "in", dpi = 300, limitsize = FALSE); ggplot2::ggsave(paste0(large_stem, ".svg"), large_clean, width = large_width, height = large_height, units = "in", limitsize = FALSE)
preview_path <- file.path(out_dir, "figure4_functional_response_landscape_journalwidth_preview.png"); pdftoppm <- Sys.which("pdftoppm"); if (!nzchar(pdftoppm)) stop("pdftoppm is required"); prefix <- tempfile("figure4_preview_"); status <- system2(pdftoppm, args = c("-png", "-singlefile", "-r", "300", "-scale-to-x", as.integer(round(large_preview_width * 300)), "-scale-to-y", "-1", paste0(large_stem, ".pdf"), prefix)); if (!identical(status, 0L)) stop("pdftoppm failed"); file.copy(paste0(prefix, ".png"), preview_path, overwrite = TRUE); unlink(paste0(prefix, ".png")); write.table(data.frame(source_path = source_path, width_in = large_width, height_in = large_height, preview_width_in = large_preview_width, panel_rows_BP = panel_row_counts[["BP"]], panel_rows_MF = panel_row_counts[["MF"]], panel_rows_CC = panel_row_counts[["CC"]], max_semantic_features = max_semantic_features, size_legend_breaks = paste(size_breaks, collapse = ";")), file.path(out_dir, "figure4_functional_response_landscape_render_audit.tsv"), sep = "\t", row.names = FALSE, quote = FALSE); cat("Wrote Figure 4 bundle from frozen family-cell provenance to", out_dir, "\n")
