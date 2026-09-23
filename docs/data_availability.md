# Data availability

The GitHub repository contains the executable workflow and concise metadata. The Zenodo concept DOI for all versions is [10.5281/zenodo.22896086](https://doi.org/10.5281/zenodo.22896086), and the reserved version-specific v1.0.1 DOI is [10.5281/zenodo.22915067](https://doi.org/10.5281/zenodo.22915067). The v1.0.1 research compendium contains DP01-DP07, processed inputs, complete machine-readable outputs, publication-artifact sources, provenance, reports, Supplementary Information, and checksums.

| Resource | Authority | Public treatment |
|---|---|---|
| Research compendium v1.0.1 | Zenodo | Reserved release DOI: [10.5281/zenodo.22915067](https://doi.org/10.5281/zenodo.22915067). Previous immutable release: v1.0.0, [10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087). |
| Holtemme LC-HRMS chemistry | Weichert et al. 2026 | Primary archive: [10.5281/zenodo.22143080](https://doi.org/10.5281/zenodo.22143080). |
| Raw RNA-seq reads | SRA | Accession `SRP571512`; raw reads are referenced, not copied. |
| *Gammarus pulex* transcriptome and annotation | Escobar-Sierra et al. 2025 | [10.1038/s41597-025-05872-2](https://doi.org/10.1038/s41597-025-05872-2). |
| EchoGO | v0.1.4, commit `dcf41371b20cccb2914852dc2c0436ecba62c559` | Pinned in `renv.lock`; no installed R library is committed. |

DP01 contains derived chemistry descriptors and analysis-ready chemistry results used by this study. Primary LC-HRMS concentrations, upstream chemistry methodology, and authoritative chemical-use classification remain in the cited external chemistry resources. `config/external_resources.tsv` is the machine-readable resource register, and `config/data_manifest.tsv` records the released package boundary.
