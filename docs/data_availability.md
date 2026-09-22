# Data availability

The GitHub repository contains the executable workflow and concise metadata. The Zenodo concept DOI for all versions is [10.5281/zenodo.22896086](https://doi.org/10.5281/zenodo.22896086), and the version-specific v1.0.0 DOI is [10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087). The v1.0.0 research compendium is published on Zenodo and contains DP01-DP07, processed inputs, complete machine-readable outputs, publication-artifact sources, provenance, reports, Supplementary Information, and checksums: [10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087).

| Resource | Authority | Public treatment |
|---|---|---|
| Research compendium v1.0.0 | Zenodo | Published release: [10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087). |
| Holtemme LC-HRMS chemistry | Weichert et al. 2026 | Primary archive: [10.5281/zenodo.22143080](https://doi.org/10.5281/zenodo.22143080). |
| Raw RNA-seq reads | SRA | Accession `SRP571512`; raw reads are referenced, not copied. |
| *Gammarus pulex* transcriptome and annotation | Escobar-Sierra et al. 2025 | [10.1038/s41597-025-05872-2](https://doi.org/10.1038/s41597-025-05872-2). |
| EchoGO | v0.1.4, commit `dcf41371b20cccb2914852dc2c0436ecba62c559` | Pinned in `renv.lock`; no installed R library is committed. |

DP01 contains derived chemistry descriptors and analysis-ready chemistry results used by this study. Primary LC-HRMS concentrations, upstream chemistry methodology, and authoritative chemical-use classification remain in the cited external chemistry resources. `config/external_resources.tsv` is the machine-readable resource register, and `config/data_manifest.tsv` records the released package boundary.