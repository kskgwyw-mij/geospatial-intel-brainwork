# Methods for 10-25 cm orthophoto classes: web search notes

Captured 2026-10-21 from web search results (snippets, not full papers). Verify before citing.

## Solar PV
- Jiang et al. 2021, ESSD 13:5389, https://essd.copernicus.org/articles/13/5389/2021/ : multi-resolution PV segmentation
  dataset (0.8 m satellite, 0.3 m, 0.1 m aerial; the 0.1 m subset covers fine-grained rooftop PV); IoU > 85 % on average;
  direct cross-application between resolutions is not feasible, so fine-tuning is needed.
- SolarDK (Khomiakov et al. 2022), https://arxiv.org/pdf/2212.01260 : Danish benchmark for classifying and localising solar
  panel arrays; data at osf.io/aj539.
- U-Net on 10 cm aerial imagery reaches F1 up to 91.75 % for PV panels (Canadian Journal of Remote Sensing, Dec 2024,
  https://doaj.org/article/ddd36a6128d2413f8751f60ba5f4cc90).
- SAM / SAM2 / SAM2.1 vs CNN on solar panels (arXiv 2408.06970): box prompts are key at low resolution; YOLOv9 boxes are
  reliable SAM prompts at high resolution; a dedicated U-Net-style model is better for fully automatic high-res work.

## Trees
- DeepForest (Weinstein et al. 2020, Methods in Ecology and Evolution 11(12):1743-1751; https://pypi.org/project/deepforest):
  RetinaNet-based tree crown detection (bounding boxes) in high-res RGB airborne imagery; pretrained on more than 30 M
  algorithmically generated crowns from 22 forests and fine-tuned on 10,000 hand-labelled crowns from 6 forests.
  Related preprint on geographic generalisation: doi 10.1101/790071.
- SAM2 zero-shot tree segmentation in aerial forest imagery (arXiv 2506.03114): generalises well, works well when
  prompted with an existing tree detector's outputs.

## Buildings & roof types
- Roof types: ISPRS Archives XLIII-B3-2021-55, https://isprs-archives.copernicus.org/articles/XLIII-B3-2021/55/2021/ :
  10 cm orthophotos (Çeşme, Turkey), about 10,000 roof images, 6 classes (flat, hip, half-hip, gable, pyramid, complex),
  shallow CNN vs fine-tuned pretrained nets.
- Self-supervised roof-type classification, EfficientNet + CBAM, domain pretraining on AID (arXiv 2503.22251).
- Two-stage: a CNN segments buildings, a second CNN classifies flat / gable / hip (PFG, doi 10.1007/s41064-018-0060-5).
- Footprints: U-Net gives well-delineated boundaries; Mask R-CNN gives instance separation and often better recall but may
  omit large buildings; fusing both at segment level helps (arXiv 2404.12487). Mask R-CNN's 28x28 mask head is coarse
  for large buildings (preprint). Adding a DSM improved U-Net IoU by about 3.6 % on an aerial dataset (snippet).
  ETH 2022: U-Net / LinkNet on <0.1 m true orthophotos + nDSM (https://research-collection.ethz.ch/handle/20.500.11850/557142).
- Zero-shot buildings, WHU dataset: Grounded-SAM F1 0.83 / IoU 0.71 vs SAM+CLIP F1 0.65 / IoU 0.49
  (ISPRS Archives XLVIII-M-6-2025-23).
- Zero-shot pipeline: Grounding DINO on sliding windows → boxes → SAM masks (KeAi AI in Geosciences 2025).
