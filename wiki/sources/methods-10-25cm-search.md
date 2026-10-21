---
title: Method evidence for 10–25 cm classes (search notes)
type: source
tags: [methods, solar, trees, roofs, buildings, foundation-models]
sources: [methods-10-25cm-search]
raw: raw/2026-10-21-methods-10-25cm-search.md
updated: 2026-10-21
---
Search-snippet evidence on how solar PV, trees, roof types and building footprints are detected or segmented in high-resolution aerial imagery, and how well zero-shot SAM pipelines do.

## Summary
A collection of results from several papers, not full texts. They cover rooftop PV segmentation (U-Net and
multi-resolution datasets), tree crowns (DeepForest), roof-type classification (two-stage
and patch CNNs), building footprints (U-Net vs. Mask R-CNN, DSM gain) and foundation
models (SAM/SAM2, Grounded-SAM).

## Key claims
- **PV:** U-Net on 10 cm aerial imagery reaches F1 up to 91.75 %. The Jiang et al. 2021 dataset at 0.1/0.3/0.8 m gives IoU > 85 %, but models do **not** transfer across resolutions without fine-tuning. SolarDK is a Danish benchmark.
- **Trees:** DeepForest is a RetinaNet crown detector pretrained on more than 30 M auto-generated crowns and fine-tuned on 10k hand labels; open-source Python package.
- **Roof type:** 6-class roof dataset from 10 cm orthophotos (about 10k roofs) classified with CNNs. The two-stage approach is to segment buildings, then classify each roof crop.
- **Footprints:** U-Net gives sharper boundaries; Mask R-CNN separates instances and has better recall but misses large buildings (coarse 28×28 mask). Adding a DSM improved U-Net IoU by about 3.6 %.
- **Zero-shot:** Grounded-SAM reaches F1 0.83 / IoU 0.71 on WHU buildings, against 0.65 / 0.49 for SAM+CLIP. SAM2 segments trees well when prompted by a detector. For PV, a detector's boxes are good SAM prompts, but a dedicated U-Net is better for fully automatic high-resolution work.

## Relevance to this wiki
Gives sourced anchors for the per-class method choices in [[methods-10-25cm]].

## Pages touched
[[methods-10-25cm]], [[semantic-segmentation]], [[object-detection]], [[osm-weak-labels]]

## Related
- [[methods-10-25cm]]
