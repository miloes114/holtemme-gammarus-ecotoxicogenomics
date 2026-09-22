# Publication architecture

The public evidence hierarchy is:

```text
Manuscript
  -> Supplementary Information PDF: Figures S1-S5 and Tables S1-S7
  -> Zenodo research compendium: DP01-DP07 and frozen release evidence
  -> GitHub: executable workflow and concise reproducibility metadata
```

GitHub is deliberately lean: it contains the executable workflow and concise reproducibility metadata. It excludes `Results_*`, processed analytical inputs, reference-scale annotation files, local installed R libraries, historical EchoGO backups, and Zenodo payload archives.

The frozen Zenodo release candidate awaiting deposition organizes evidence as DP01 chemistry, DP02 RNA-seq inputs/QC, DP03 global structure, DP04 differential expression, DP05 functional evidence, DP06 WGCNA, and DP07 site-associated modules. The synchronized SI is authoritative for Figures S1-S5 and Tables S1-S7; the GitHub registry records the executable workflow and concise metadata.

