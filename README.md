# Holtemme Gammarus Ecotoxicogenomics

[![Zenodo DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22896087.svg)](https://doi.org/10.5281/zenodo.22896087)

Reproducible workflow for field ecotoxicogenomics of wild *Gammarus pulex* across the wastewater-impacted Holtemme River, Germany. The study integrates micropollutant mixture characterisation, transcriptome-wide structure, differential expression, EchoGO v0.1.4 annotation-context evidence, functional-response synthesis, and WGCNA module analysis.

## Release

The current frozen analytical release is **v1.0.0**. The Zenodo concept DOI for all versions is [10.5281/zenodo.22896086](https://doi.org/10.5281/zenodo.22896086).

**Research compendium:** Escobar-Sierra C, Weichert FG, Krauss M, Hollert H, Inostroza PA. *Holtemme Gammarus ecotoxicogenomics research compendium.* Zenodo, v1.0.0. [https://doi.org/10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087)

GitHub contains the executable workflow, compact metadata, documentation, configuration, tests, and bounded HTML reports. Zenodo contains the frozen DP01-DP07 research compendium, processed inputs, complete machine-readable outputs, publication-artifact sources, provenance, Supplementary Information, reports, and checksums. Tag `v1.0.0` is the exact analytical source snapshot associated with the Zenodo release; `main` may contain later documentation-only corrections.

## Workflow

| Step | Analysis |
|---:|---|
| 01 | Global transcriptome structure |
| 02 | Chemistry-transcriptome integration |
| 03 | Differential expression |
| 04 | GOseq target-enrichment preparation |
| 05 | EchoGO annotation-context evidence |
| 06 | Functional synthesis |
| 07 | WGCNA network-selection sensitivity |
| 08 | Site-associated module inference and functional interpretation |

The transcriptomic dataset comprises 30 individual *Gammarus pulex* libraries from six transcriptomic sites, H2-H7, spanning two WWTP transitions. The eight authoritative R Markdown sources are at the repository root, and rendered reports are in `reports/`.

## Reproduce

The validated environment uses R 4.4.3, Bioconductor 3.20, and EchoGO 0.1.4 at commit `dcf41371b20cccb2914852dc2c0436ecba62c559`.

```powershell
Rscript scripts/bootstrap.R
Rscript scripts/preflight.R
Rscript scripts/dependency_audit.R
Rscript scripts/validate_project.R
Rscript scripts/validate_publication_artifacts.R
```

A complete Step 01-08 reconstruction requires the frozen processed inputs and prior-step outputs supplied in the [Zenodo v1.0.0 compendium](https://doi.org/10.5281/zenodo.22896087). The workflow uses documented relative paths and does not duplicate external authoritative records.

## Data availability

- Research compendium v1.0.0: [DOI 10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087).
- Primary Holtemme LC-HRMS chemistry: [DOI 10.5281/zenodo.22143080](https://doi.org/10.5281/zenodo.22143080).
- Raw RNA-seq reads: SRA `SRP571512`.
- Published *Gammarus pulex* transcriptome and annotation: Escobar-Sierra et al. 2025, [DOI 10.1038/s41597-025-05872-2](https://doi.org/10.1038/s41597-025-05872-2).

DP01 contains derived chemistry descriptors and analysis-ready chemistry results used by this study. Primary LC-HRMS concentrations, upstream chemistry methodology, and authoritative chemical-use classification remain in the cited external chemistry resources. See [data availability](docs/data_availability.md) and the [reproducibility boundary](docs/reproducibility_boundary.md).

## Publication artifacts

The release maps Main Figures 1-5, Supplementary Figures S1-S5, and Supplementary Tables S1-S7 to their source data and provenance through `config/publication_artifact_registry.tsv`, `config/plot_registry.tsv`, and `config/zenodo_deposit_manifest.tsv`. Figure 4 uses the final EchoGO v0.1.4 evidence hierarchy. Supplementary Figure S5 uses the final 16-gene target-supported candidate panel. Figure 5 is the final site-associated WGCNA module figure.

See [publication architecture](docs/publication_architecture.md), [artifact reconciliation](docs/publication_artifact_reconciliation.md), and [site identifiers](docs/site_identifiers.md).

## Citation

**Dataset citation**

Escobar-Sierra, C., Weichert, F. G., Krauss, M., Hollert, H., & Inostroza, P. A. (2026). *Holtemme Gammarus ecotoxicogenomics research compendium* (Version v1.0.0) [Dataset]. Zenodo. [https://doi.org/10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087)

**Associated manuscript**

Escobar-Sierra, C., Brack, W., Hollert, H., Krauss, M., Weichert, F. G., & Inostroza, P. A. *Field ecotoxicogenomics reveals transition-specific molecular responses in a freshwater sentinel across a wastewater-impacted river.*

Camilo Escobar-Sierra is first author and Pedro A. Inostroza is senior/last author; the middle authors are ordered alphabetically by family name.

Use the article citation once the manuscript is published. No article DOI is assigned here.

## License

- Source code: [MIT License](LICENSE).
- Original non-code research content: [CC BY 4.0](LICENSE-CONTENT.md).
- Third-party and external resources retain their original licences.