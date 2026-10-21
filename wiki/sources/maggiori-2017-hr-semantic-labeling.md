---
title: Maggiori et al. 2017 — High-Resolution Semantic Labeling with CNNs
type: source
tags: [semantic-segmentation, cnn, multi-scale, paper]
sources: [maggiori-2017-hr-semantic-labeling]
raw: raw/2026-10-21-maggiori-2016-arxiv-1611.01962v1.pdf
updated: 2026-10-21
---
A paper that analyses CNN architectures for per-pixel aerial labelling and proposes the "MLP" network: it learns features at several resolutions and learns how to combine them, and was 2nd of 29 on the ISPRS Vaihingen benchmark.

## Summary
Maggiori, Tarabalka, Charpiat & Alliez (Inria). arXiv:1611.01962v1 (7 Nov 2016), published in
IEEE TGRS 55(12):7092–7103, 2017. Full text read from the PDF.

Categorisation CNNs downsample (pool) to gain robustness, which costs the localisation
precision that dense labelling needs: the **recognition/localisation trade-off**. The paper
groups high-resolution labelling CNNs into **dilation**, **deconvolution (unpooling)** and
**skip** networks and assesses each. It then proposes the **MLP network**: take intermediate
features from several resolutions of one FCN, upsample them, concatenate them, and let a
per-pixel MLP (1×1 convolutions) learn how to combine them. The guiding principle (their
Fig. 2): you need large context, but **not at full resolution everywhere**. Detail matters
near the pixel being labelled; farther away, coarse information suffices.

## Key claims
- **Why context matters:** a grey pixel alone is easily confused with asphalt road. Only the surrounding patch reveals it is a grey rooftop. Spectrum (colour) alone is insufficient.
- **Dilation nets:** no theoretical gain over naive upsampling; very memory- and compute-hungry. Training them helps minority classes (cars).
- **Deconvolution/unpooling nets:** solve the trade-off only with max pooling; about twice the depth, harder to train; produce small artefacts and isolated pixels.
- **Skip nets (FCN-8s style):** combine per-resolution *class scores* linearly. The authors argue you should combine *features* (for example high-resolution edge detectors), not classifications.
- **MLP net:** example rule it can learn: "label a pixel as building if it is red and belongs to a larger red rectangular structure, surrounded by green vegetation and near a road". Hidden layer has 1024 neurons.
- **Data:**
  - ISPRS **Vaihingen**: 9 cm, 33 tiles (about 2494×2064 px), 16 labelled; 11 used for training and 5 for validation.
  - ISPRS **Potsdam**: 5 cm, 38 tiles of 6000×6000 px, 24 labelled; 17 for training and 7 for validation.
  - Inputs: **DSM + NIR + R + G**, with the DSM simply added as an extra band.
  - Classes: impervious surface, building, low vegetation, tree, car, clutter. Clutter is dropped on Vaihingen for lack of data.
  - Accuracy is measured on ground truth with eroded boundaries.
- **Base FCN:** 4 conv blocks (32–128 filters, first kernel 5×5, stride 2), batch normalisation + ReLU, total downsampling ×16. Potsdam is downsampled ×2 to cover the same metres per receptive field.
- **Training:**
  - SGD, momentum 0.9, L2 regularisation 0.0005.
  - Patches of 256² (Vaihingen) or 512² (Potsdam), 5 per mini-batch, 8× flip/transpose augmentation.
  - Learning rate 0.1 with exponential decay (÷10 every 10k / 20k iterations); 45k / 90k iterations.
  - Derived nets are initialised from the pretrained FCN and retrained at learning rate 0.01 for 30k / 65k iterations. Pretrained initialisation beats training from scratch.
- **Results, Vaihingen validation (F1 per class, mean F1, overall accuracy):**

  | | Imp. surf. | Building | Low veg. | Tree | Car | Mean F1 | OA |
  |---|---|---|---|---|---|---|---|
  | Base FCN | 91.46 | 94.88 | 79.19 | 87.89 | 72.25 | 85.14 | 88.61 |
  | Unpooling | 91.17 | 95.16 | 79.06 | 87.78 | 69.49 | 84.54 | 88.55 |
  | Skip | 91.66 | 95.02 | 79.13 | 88.11 | 77.96 | 86.38 | 88.80 |
  | **MLP** | **91.69** | **95.24** | **79.44** | **88.12** | **78.42** | **86.58** | **88.92** |

- **Results, Potsdam validation:**

  | | Imp. surf. | Building | Low veg. | Tree | Car | Clutter | Mean F1 | OA |
  |---|---|---|---|---|---|---|---|---|
  | Base FCN | 88.33 | 93.97 | 84.11 | 80.30 | 86.13 | 75.35 | 84.70 | 86.20 |
  | Unpooling | 87.00 | 92.86 | 82.93 | 78.04 | 84.85 | 72.47 | 83.03 | 84.67 |
  | Skip | 89.27 | 94.21 | 84.73 | 81.23 | 93.47 | 75.18 | 86.35 | 86.89 |
  | **MLP** | 89.31 | 94.37 | 84.83 | 81.10 | 93.56 | 76.54 | 86.62 | 87.02 |

- **Against the literature, Vaihingen** (mean F1 / overall accuracy):

  | Method | Mean F1 | OA |
  |---|---|---|
  | CNN+RF | 82.65 | 86.52 |
  | CNN+RF+CRF | 83.78 | 86.89 |
  | Deconvolution | 83.58 | 87.83 |
  | Dilation | 85.28 | 87.70 |
  | Dilation+CRF | 85.24 | 87.90 |
  | **MLP** | **86.58** | **88.92** |

  On Potsdam, a much larger VGG-pretrained dilation net is slightly better (87.06 / 87.69), but plain Dilation is lower (82.94 / 84.14).
- **ISPRS Vaihingen test leaderboard:** MLP placed **2nd of 29** with overall accuracy **89.5**, beating far bigger ensembles (more than 20 layers, pretrained).
- **Speed:** test time in s/ha (Vaihingen / Potsdam): FCN 0.81 / 1.44, Skip 0.81 / 1.48, Unpooling 1.38 / 1.84, MLP 1.70 / 2.0, Dilation 4.81 / 17.2.
  - Hardware: Caffe on a 4 GB Quadro K3100M laptop GPU.
  - MLP labels the whole Vaihingen validation set in about 30 s and Potsdam in about 2 min.
  - Large images are tiled with an overlap equal to the network padding.
- **Qualitative:** the base FCN gives "blobby" objects. Multi-resolution nets sharpen cars and thin roads and find small objects. The **ground truth itself is imprecise**; for example, a lightwell is labelled as building.
- **Future work stated:** a large-scale aerial dataset covering dissimilar areas. This became the Inria dataset ([[aerial-cv-benchmarks]]).

## Relevance to this wiki
- **It is a location-aware alternative to box detection, not image geolocalisation.** It labels every
  pixel of an already georeferenced [[orthoimagery]] tile. Each labelled pixel has coordinates,
  so outputs can be polygonised into GeoJSON for the [[poc-platform]] and compared with OSM.
- It shows **small, cheap networks are competitive**: a 4-block FCN plus MLP on a 4 GB GPU
  beats much larger models. That suits a part-time thesis with limited compute.
- **Adding a DSM/nDSM as an extra input band** is easy and standard, and it helps separate buildings from ground.
- **Report mean F1 next to overall accuracy:** cars, a minority class, swing 69–78 F1 while overall accuracy hardly moves.
- It sources the caveat in [[spectral-texture-features]] that colour alone is ambiguous (grey roof vs. asphalt) and context is needed.
- Its remark that even ISPRS ground truth is imprecise matters doubly for [[osm-weak-labels]].
- Today the same idea lives on in U-Net, FPN and DeepLabv3+ decoders, which also fuse multi-resolution features. (unsourced)
- Companion work by the same group on OSM labels: [[maggiori-osm-imperfect-labels]].

## Pages touched
[[semantic-segmentation]], [[spectral-texture-features]], [[aerial-cv-benchmarks]], [[cv-detectability]], [[orthoimagery]], [[thesis-poc-pipeline]], [[overview]]

## Related
- [[semantic-segmentation]]
- [[maggiori-osm-imperfect-labels]]
- [[aerial-cv-benchmarks]]
- [[spectral-texture-features]]
