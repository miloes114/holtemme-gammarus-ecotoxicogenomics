# Reproducibility boundary

This repository reproduces the ordered analytical workflow after the frozen processed inputs and reference resources have been materialized at their documented relative locations. A complete Step 01-08 reconstruction requires the frozen processed inputs and prior-step outputs supplied in the Zenodo v1.0.1 compendium ([10.5281/zenodo.22915067](https://doi.org/10.5281/zenodo.22915067)).

DP01 contains derived chemistry descriptors and analysis-ready chemistry results used by this study. Primary LC-HRMS concentrations, upstream chemistry methodology, and authoritative chemical-use classification remain in the cited external chemistry resources. Those primary chemistry objects are intentionally not stored in GitHub.

The repository supplies:

- eight authoritative R Markdown analysis sources;
- workflow, preflight, rendering, bootstrap, and validation scripts;
- compact site, contrast, sample, and derived chemistry metadata;
- package versions in `renv.lock`;
- pinned EchoGO 0.1.4 provenance;
- eight bounded rendered HTML reports.

The published Zenodo compendium supplies processed inputs, complete result tables, figure-source data, provenance records, checksums, and DP01-DP07. Raw RNA-seq remains external at SRA `SRP571512`.
