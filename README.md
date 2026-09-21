# Holtemme Gammarus Ecotoxicogenomics

Reproducible workflow for field ecotoxicogenomics of wild *Gammarus pulex* across the wastewater-impacted Holtemme River, Germany. The workflow integrates micropollutant mixture characterisation, transcriptome structure, differential expression, annotation-context evidence, functional synthesis, and WGCNA module interpretation.

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

The eight authoritative R Markdown sources are at the repository root. Rendered reports are in `reports/`.

## Reproduce

The validated environment uses R 4.4.3, Bioconductor 3.20, and EchoGO 0.1.4. Install the locked environment with:

```powershell
Rscript scripts/bootstrap.R
```

Run structural and reproducibility checks with:

```powershell
Rscript scripts/preflight.R
Rscript scripts/dependency_audit.R
Rscript scripts/validate_project.R
Rscript scripts/validate_publication_artifacts.R
```

A complete Step 01–08 render requires the frozen processed inputs and prior-step outputs supplied in the associated Zenodo research compendium. The workflow uses documented relative paths and does not duplicate external authoritative records.

## Data availability

- Primary Holtemme LC-HRMS chemistry: Weichert et al. 2026, [DOI 10.5281/zenodo.22143080](https://doi.org/10.5281/zenodo.22143080).
- Raw RNA-seq reads: SRA `SRP571512`.
- Published *Gammarus pulex* transcriptome and annotation resources: Escobar-Sierra et al. 2025, as documented in the workflow metadata.

The frozen v1.0.0 research compendium is prepared for Zenodo deposit; its DOI will be added after deposit. See [data availability](docs/data_availability.md) and the [reproducibility boundary](docs/reproducibility_boundary.md).

## Publication architecture

DP01 contains derived chemistry descriptors and analysis-ready chemistry results used by this study; primary LC-HRMS concentrations, upstream chemistry methodology, and authoritative chemical-use classification remain in the cited external chemistry resources.

The publication-facing evidence hierarchy is manuscript → Supplementary Information → Zenodo data packages DP01–DP07 → executable GitHub workflow. The Supplementary Information contains Figures S1–S5 and Tables S1–S7.

See [publication architecture](docs/publication_architecture.md) and [site identifiers](docs/site_identifiers.md).

## Citation

If you use this workflow or research compendium, please cite the associated article. The preferred article title is:

*Field ecotoxicogenomics reveals transition-specific molecular responses in a freshwater sentinel across a wastewater-impacted river*

Repository citation metadata are provided in `CITATION.cff`.

## License

Source code in this repository is licensed under the [MIT License](LICENSE).

Original research-compendium data, figures, tables and documentation are licensed under [CC BY 4.0](LICENSE-CONTENT.md) unless otherwise indicated. Third-party and externally archived resources retain their original licences.
