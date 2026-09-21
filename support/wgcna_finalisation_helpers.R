# Helper functions shared by the final Holtemme WGCNA sensitivity and
# paper-facing module analyses. Statistical feature selection and module
# retention remain in the calling reports; these helpers only construct,
# validate, orient, and compare networks.

wgcna_correct_undersized_modules <- function(colors, minimum_module_size) {
  colors <- stats::setNames(as.character(colors), names(colors))
  raw_sizes <- table(colors)
  undersized <- names(raw_sizes)[
    names(raw_sizes) != "grey" & raw_sizes < minimum_module_size
  ]
  corrected <- colors
  if (length(undersized) > 0L) {
    corrected[corrected %in% undersized] <- "grey"
  }
  list(
    colors = corrected,
    raw_sizes = raw_sizes,
    undersized_modules = undersized
  )
}

wgcna_orient_eigengenes <- function(dat_expr, colors, max_p_outliers = 0.10) {
  dat_expr <- as.matrix(dat_expr)
  colors <- stats::setNames(as.character(colors), names(colors))
  if (!identical(colnames(dat_expr), names(colors))) {
    colors <- colors[colnames(dat_expr)]
  }
  if (any(is.na(colors))) {
    stop("Module colours could not be aligned to the expression columns.")
  }

  me <- WGCNA::moduleEigengenes(
    dat_expr,
    colors = colors,
    impute = TRUE,
    excludeGrey = FALSE,
    align = "along average"
  )$eigengenes
  me <- WGCNA::orderMEs(me)

  orientation <- purrr::map_dfr(sort(unique(colors)), function(current_module) {
    me_column <- paste0("ME", current_module)
    gene_columns <- which(colors == current_module)
    standardized <- scale(
      dat_expr[, gene_columns, drop = FALSE],
      center = TRUE,
      scale = TRUE
    )
    standardized[!is.finite(standardized)] <- 0
    average_standardized_expression <- rowMeans(standardized)
    orientation_correlation <- as.numeric(WGCNA::bicor(
      me[[me_column]],
      average_standardized_expression,
      use = "pairwise.complete.obs",
      maxPOutliers = max_p_outliers
    ))
    flipped <- is.finite(orientation_correlation) && orientation_correlation < 0
    tibble::tibble(
      module = current_module,
      module_label = me_column,
      module_size = length(gene_columns),
      preflip_correlation_with_average_standardized_expression =
        orientation_correlation,
      eigengene_flipped = flipped,
      orientation_rule =
        "positive correlation with average standardized member-gene expression"
    )
  })

  for (orientation_row in seq_len(nrow(orientation))) {
    if (isTRUE(orientation$eigengene_flipped[[orientation_row]])) {
      current_column <- orientation$module_label[[orientation_row]]
      me[[current_column]] <- -me[[current_column]]
    }
  }

  expected_labels <- paste0("ME", sort(unique(colors)))
  if (!setequal(expected_labels, names(me))) {
    stop(
      "Final module-colour labels do not match module-eigengene labels. Colours: ",
      paste(expected_labels, collapse = ", "),
      "; eigengenes: ", paste(names(me), collapse = ", ")
    )
  }

  list(eigengenes = me, orientation = orientation)
}

wgcna_run_validated_network <- function(
  dat_expr,
  power,
  network_type = "signed",
  correlation_type = "bicor",
  max_p_outliers = 0.10,
  minimum_module_size = 50L,
  merge_cut_height = 0.25,
  deep_split = 2,
  pam_respects_dendro = FALSE,
  max_block_size = 6000L,
  verbose = 0
) {
  dat_expr <- as.matrix(dat_expr)
  network <- WGCNA::blockwiseModules(
    dat_expr,
    power = power,
    networkType = network_type,
    TOMType = network_type,
    corType = correlation_type,
    maxPOutliers = max_p_outliers,
    minModuleSize = minimum_module_size,
    mergeCutHeight = merge_cut_height,
    deepSplit = deep_split,
    numericLabels = FALSE,
    pamRespectsDendro = pam_respects_dendro,
    maxBlockSize = min(max_block_size, ncol(dat_expr)),
    saveTOMs = FALSE,
    verbose = verbose
  )

  raw_colors <- stats::setNames(
    as.character(network$colors),
    colnames(dat_expr)
  )
  corrected <- wgcna_correct_undersized_modules(
    raw_colors,
    minimum_module_size
  )
  final_colors <- corrected$colors
  final_sizes <- table(final_colors)
  assigned_sizes <- final_sizes[names(final_sizes) != "grey"]
  if (length(assigned_sizes) > 0L &&
      any(assigned_sizes < minimum_module_size)) {
    stop("A final assigned module is smaller than minModuleSize.")
  }

  oriented <- wgcna_orient_eigengenes(
    dat_expr,
    final_colors,
    max_p_outliers = max_p_outliers
  )

  block_id <- rep(NA_integer_, ncol(dat_expr))
  if (length(network$blockGenes) > 0L) {
    for (current_block in seq_along(network$blockGenes)) {
      block_id[network$blockGenes[[current_block]]] <- current_block
    }
  }
  names(block_id) <- colnames(dat_expr)

  unmerged_colors <- if (!is.null(network$unmergedColors)) {
    stats::setNames(
      as.character(network$unmergedColors),
      colnames(dat_expr)
    )
  } else {
    stats::setNames(rep(NA_character_, ncol(dat_expr)), colnames(dat_expr))
  }

  raw_me_labels <- names(WGCNA::orderMEs(network$MEs))
  raw_module_audit <- tibble::tibble(
    raw_module = names(corrected$raw_sizes),
    raw_module_label = paste0("ME", names(corrected$raw_sizes)),
    raw_module_size = as.integer(corrected$raw_sizes)
  ) %>%
    dplyr::mutate(
      raw_me_present = .data$raw_module_label %in% raw_me_labels,
      exact_unassigned_grey = .data$raw_module == "grey",
      below_declared_minimum =
        .data$raw_module != "grey" &
        .data$raw_module_size < minimum_module_size,
      final_action = dplyr::if_else(
        .data$below_declared_minimum,
        "reclassified_to_exact_grey_before_testing",
        "retained"
      )
    )

  anomalous_gene_audit <- tibble::tibble(
    gene_id = names(raw_colors),
    raw_final_color = unname(raw_colors),
    corrected_final_color = unname(final_colors),
    unmerged_color = unname(unmerged_colors),
    block_id = unname(block_id)
  ) %>%
    dplyr::filter(.data$raw_final_color %in% corrected$undersized_modules)

  module_summary <- tibble::tibble(
    module = names(final_sizes),
    module_label = paste0("ME", names(final_sizes)),
    n_genes = as.integer(final_sizes)
  ) %>%
    dplyr::mutate(
      module_type = dplyr::if_else(
        .data$module == "grey", "unassigned", "assigned"
      )
    ) %>%
    dplyr::arrange(.data$module_type, dplyr::desc(.data$n_genes))

  assignment <- tibble::tibble(
    gene_id = names(final_colors),
    module = unname(final_colors),
    module_label = paste0("ME", unname(final_colors))
  )

  list(
    colors = final_colors,
    raw_colors = raw_colors,
    eigengenes = oriented$eigengenes,
    orientation = oriented$orientation,
    assignment = assignment,
    module_summary = module_summary,
    module_audit = raw_module_audit,
    anomalous_gene_audit = anomalous_gene_audit,
    raw_me_labels = raw_me_labels,
    n_blocks = length(network$blockGenes),
    block_id = block_id
  )
}

wgcna_match_modules <- function(
  reference_colors,
  alternative_colors,
  reference_eigengenes,
  projected_alternative_eigengenes,
  max_p_outliers = 0.10
) {
  reference_colors <- stats::setNames(
    as.character(reference_colors), names(reference_colors)
  )
  alternative_colors <- stats::setNames(
    as.character(alternative_colors), names(alternative_colors)
  )
  common_genes <- intersect(names(reference_colors), names(alternative_colors))
  reference_modules <- sort(setdiff(unique(reference_colors), "grey"))
  alternative_modules <- sort(setdiff(unique(alternative_colors), "grey"))

  overlap_grid <- tidyr::expand_grid(
    reference_module = reference_modules,
    alternative_module = alternative_modules
  ) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      reference_n = sum(reference_colors[common_genes] == .data$reference_module),
      alternative_n = sum(
        alternative_colors[common_genes] == .data$alternative_module
      ),
      intersection_n = sum(
        reference_colors[common_genes] == .data$reference_module &
          alternative_colors[common_genes] == .data$alternative_module
      ),
      union_n = .data$reference_n + .data$alternative_n - .data$intersection_n,
      jaccard = dplyr::if_else(
        .data$union_n > 0,
        .data$intersection_n / .data$union_n,
        NA_real_
      )
    ) %>%
    dplyr::ungroup()

  reference_best <- overlap_grid %>%
    dplyr::group_by(.data$reference_module) %>%
    dplyr::slice_max(.data$jaccard, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup()
  alternative_best <- overlap_grid %>%
    dplyr::group_by(.data$alternative_module) %>%
    dplyr::slice_max(.data$jaccard, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      .data$alternative_module,
      reciprocal_reference_module = .data$reference_module
    )

  many_to_one <- reference_best %>%
    dplyr::count(.data$alternative_module, name = "references_matching_alternative_n")

  reference_best %>%
    dplyr::left_join(alternative_best, by = "alternative_module") %>%
    dplyr::left_join(many_to_one, by = "alternative_module") %>%
    dplyr::mutate(
      reciprocal_match = .data$reference_module ==
        .data$reciprocal_reference_module,
      matching_status = dplyr::case_when(
        .data$reciprocal_match &
          .data$references_matching_alternative_n == 1L ~ "reciprocal_one_to_one",
        .data$references_matching_alternative_n > 1L ~ "one_to_many_or_merged",
        TRUE ~ "nonreciprocal_best_match"
      ),
      reference_module_label = paste0("ME", .data$reference_module),
      alternative_module_label = paste0("ME", .data$alternative_module),
      eigengene_abs_correlation = purrr::map2_dbl(
        .data$reference_module_label,
        .data$alternative_module_label,
        function(reference_label, alternative_label) {
          if (!reference_label %in% names(reference_eigengenes) ||
              !alternative_label %in% names(projected_alternative_eigengenes)) {
            return(NA_real_)
          }
          abs(as.numeric(WGCNA::bicor(
            reference_eigengenes[[reference_label]],
            projected_alternative_eigengenes[[alternative_label]],
            use = "pairwise.complete.obs",
            maxPOutliers = max_p_outliers
          )))
        }
      )
    )
}
