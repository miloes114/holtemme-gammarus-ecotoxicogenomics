# Data availability

GitHub contains workflow code and compact interpretive metadata. DP01 contains derived chemistry descriptors and analysis-ready chemistry results used by this study. Primary LC-HRMS concentrations, upstream chemistry methodology, and authoritative chemical-use classification remain in the cited external chemistry resources. It does not duplicate primary chemistry concentrations, raw RNA-seq reads, complete processed outputs, or frozen release-scale evidence tables.

| Resource | Authority | GitHub treatment |
|---|---|---|
| Holtemme LC-HRMS chemistry | Weichert et al. 2026, DOI 10.5281/zenodo.22143080 | Referenced; derived compact site descriptors only where redistribution is confirmed. |
| Raw RNA-seq reads | SRA SRP571512 | Referenced, not copied. |
| *Gammarus pulex* transcriptome and annotation | Escobar-Sierra et al. 2025 | Referenced; future frozen release records exact source metadata. |
| EchoGO | v0.1.4, immutable commit `dcf41371b20cccb2914852dc2c0436ecba62c559` | Installed through `renv.lock`; no installed R library is committed. |

`config/external_resources.tsv` is the machine-readable resource register. `config/data_manifest.tsv` distinguishes compact local metadata from external authoritative resources and future Zenodo content.

