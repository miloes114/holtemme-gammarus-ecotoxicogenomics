# Publication-artifact reconciliation

This release boundary contains exactly 17 journal-facing objects: Figures 1–5, Supplementary Figures S1–S5, and Supplementary Tables S1–S7. The authoritative manuscript/SI labels are explicit in `config/publication_artifact_registry.tsv`; historical output stems are retained only as source aliases.

## Reconciled source decisions

- Figure 3 is the current manuscript label for legacy `Figure4A_DEG_burden_gradient_plus_WWTP_publication.*` and `Figure4B_effect_size_gradient_plus_WWTP_publication.*`. `contrast_summary.csv` is authoritative; the reference/local contrast summaries and priority table are reconstruction/support inputs.
- Figure 4 traceback uses the three canonical provenance tables (figure4_family_cell_provenance.tsv, figure4_source_term_family_provenance.tsv, and figure4_gene_term_family_provenance.tsv) plus the ontology-specific family/semantic tables listed in the registry. figure4_gene_provenance_summary.tsv is a derived diagnostic QC summary generated from the gene-term provenance table and staged under DP05 provenance; it is not a primary Figure 4 reconstruction table.
- Figure 5 uses the four Step 08 panel tables. DP06 remains upstream WGCNA network-selection evidence and is intentionally not assigned a direct paper-facing object.
- S1 and S2 now have exact V9.1 SI publication rasters in the published v1.0.0 release. S1 is an upstream chemistry result with graphical-only legend repair; S2 is the exact three-panel SI composite backed by frozen DP01 source tables. No upstream chemistry mapping is reconstructed.
- S3 now has the exact V9.1 two-panel SI composite plus its canonical DP03 heatmap/dendrogram components. S4 and S5 retain canonical internal plot sources; S5 retains the historical `figure5_functional_family_linked_candidate_gene_heatmap` filename while mapping it to the current SI label.

## P0 manuscript/SI correction

The current SI caption contains obsolete text stating that the concentration matrix and analytical metadata are absent and constitute a blocking author-review item. That statement is no longer valid and must be corrected in the next SI DOCX/manuscript edit. This task intentionally does **not** modify the SI DOCX. The authoritative primary chemistry source is:

> Weichert FG, Escobar-Sierra C, Brack W, Krauss M, Hollert H, Inostroza PA. 2026. *Micropollutant concentrations in the Holtemme River (LC-HRMS direct injection, October 2021).* Zenodo. DOI: `10.5281/zenodo.22143080`.

DP01 should carry derived/analysis-ready chemistry objects and cite that primary archive; it should not claim authority over the original concentration archive.

## Packaging boundary

The six historical `Supplementary_Data_*.xlsx` workbooks are outside the target release and are not required by any registry. DP02 (RNA-seq inputs/QC) and DP06 (WGCNA selection/network evidence) remain valid upstream packages with zero direct publication artifacts.

## Frozen release package

- DP01: chemistry provenance, derived site descriptors, chemical/MoA long tables, and standalone S1/S2 exports with the Weichert DOI link.
- DP02: raw-read/QC provenance and sample-level metadata, without assigning a paper-facing artifact.
- DP03: global PCA, distance matrix/clustering, and RDA response/predictor tables for Figure 2, S3, S4, S3/S4 tables.
- DP04: contrast summary, reference/local summaries, and the exact Figure 3 source bundle.
- DP05: Figure 4 provenance, candidate-gene heatmap inputs, S5, and Table S6 with the pinned EchoGO commit.
- DP06: retain as upstream network-selection evidence only; no direct SI object.
- DP07: Step 08 paper-facing WGCNA panel tables, Figure 5, and Table S7.

The published Zenodo v1.0.0 compendium contains the broader DP01-DP07 payload, package checksums, and the 17 publication-artifact source entries recorded in `config/zenodo_deposit_manifest.tsv`: [10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087).

