# Publication architecture

The public evidence hierarchy is:

```text
Manuscript
  -> Supplementary Information PDF: Figures S1-S5 and Tables S1-S7
  -> Zenodo v1.0.1 research compendium: DP01-DP07 and release evidence
  -> GitHub: executable workflow and concise reproducibility metadata
```

GitHub is deliberately lean: it contains the executable workflow, documentation, configuration, tests, compact metadata, and bounded HTML reports. It excludes `Results_*`, processed analytical inputs, reference-scale annotation files, local installed R libraries, and Zenodo payload archives.

The v1.0.1 compendium (reserved DOI [10.5281/zenodo.22915067](https://doi.org/10.5281/zenodo.22915067)) organizes evidence as DP01 chemistry, DP02 RNA-seq inputs/QC, DP03 global structure, DP04 differential expression, DP05 functional evidence, DP06 WGCNA network-selection evidence, and DP07 site-associated modules. The synchronized SI is authoritative for Figures S1-S5 and Tables S1-S7. Tag `v1.0.0` remains the previous immutable analytical snapshot; tag `v1.0.1` is the current publication-synchronization source state.
