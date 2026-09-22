# Publication architecture

The public evidence hierarchy is:

```text
Manuscript
  -> Supplementary Information PDF: Figures S1-S5 and Tables S1-S7
  -> Published Zenodo v1.0.0 research compendium: DP01-DP07 and release evidence
  -> GitHub: executable workflow and concise reproducibility metadata
```

GitHub is deliberately lean: it contains the executable workflow, documentation, configuration, tests, compact metadata, and bounded HTML reports. It excludes `Results_*`, processed analytical inputs, reference-scale annotation files, local installed R libraries, and Zenodo payload archives.

The published Zenodo v1.0.0 compendium ([10.5281/zenodo.22896087](https://doi.org/10.5281/zenodo.22896087)) organizes evidence as DP01 chemistry, DP02 RNA-seq inputs/QC, DP03 global structure, DP04 differential expression, DP05 functional evidence, DP06 WGCNA network-selection evidence, and DP07 site-associated modules. The synchronized SI is authoritative for Figures S1-S5 and Tables S1-S7. Tag `v1.0.0` is the exact analytical source snapshot deposited on Zenodo; later `main` commits may contain documentation-only corrections.