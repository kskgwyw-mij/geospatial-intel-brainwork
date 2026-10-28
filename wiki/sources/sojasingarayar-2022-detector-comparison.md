---
title: Faster R-CNN vs YOLO vs SSD (Sojasingarayar 2022, Medium blog)
type: source
tags: [object-detection, deep-learning, computer-vision, overview]
sources: [sojasingarayar-2022-detector-comparison]
raw: raw/2026-10-28-sojasingarayar-2022-faster-rcnn-yolo-ssd.pdf
updated: 2026-10-28
---
A short blog overview (Medium, IBM Data Science in Practice, 29 Aug 2022) of three classic deep-learning object detectors: the two-stage Faster R-CNN and the single-shot YOLO and SSD, with a speed/accuracy chart on Pascal VOC 2007 in which SSD300 reaches 74 % mAP at 46 fps.

## Summary
Abonia Sojasingarayar, "Faster R-CNN vs YOLO vs SSD — Object Detection Algorithms", 5-minute read, saved as a browser PDF on 28.10.2026 (16 pages; pages 1–8 are the article, the rest are comments and Medium recommendations). It explains object detection as localisation plus classification, then describes each detector in a few paragraphs and closes with a performance chart taken from the SSD authors' material. Its own references are three other blog/tutorial pages. Parts of the text read like automated paraphrase ("you merely Look Once", "a hundred and fifty-five FPS").

## Key claims
- **Detection = localisation + classification:** where objects are and which class each belongs to ([[sojasingarayar-2022-detector-comparison]]).
- **Faster R-CNN** (Microsoft researchers):
  - one unified, end-to-end network of two modules on a shared CNN feature map: a **Region Proposal Network (RPN)** that proposes regions, and a **Fast R-CNN head** that extracts features from the proposals and outputs boxes and class labels;
  - the RPN acts as an attention mechanism that tells the head where to look; it is why Faster R-CNN is faster than Fast R-CNN;
  - later models for semantic segmentation and 3D detection borrow its RPN or R-CNN head.
- **YOLO** (CVPR 2016):
  - looks at the image once: the image is split into a grid, and each cell predicts the boxes (x, y, width, height, confidence) whose centre falls in it, plus class probabilities;
  - 45 fps in the text; "Fast YOLO" 155 fps;
  - claimed strengths: real-time speed and few background errors; used for traffic signals, people, parking meters, animals.
- **SSD** (Single Shot MultiBox Detector):
  - no separate proposal network; boxes and classes come directly from feature maps in one pass;
  - small convolutional filters predict classes and offsets to **default boxes**; separate filters per aspect ratio; **multi-scale feature maps**;
  - trained end to end; by dropping the proposal stage and using lower-resolution input it runs in real time and still beats Faster R-CNN in accuracy.
- **Speed/accuracy chart** (Pascal VOC 2007 test, all with VGG16 pretrained on ImageNet, batch size 1, Titan X):

  | Detector | Type | mAP | fps |
  |---|---|---|---|
  | R-CNN (Girshick 2014) | two-stage | 66 % | 0.02 |
  | Fast R-CNN (Girshick 2015) | two-stage | 70 % | 0.4 |
  | Faster R-CNN (Ren 2015) | two-stage | 73 % | 7 |
  | YOLO (Redmon 2016) | single-shot | 66 % | 21 |
  | SSD300 | single-shot | 74 % | 46 |

  SSD300 is 6.6× faster than Faster R-CNN and "the only object detector capable of achieving mAP above 70 % while being a 46 fps real-time model".
- **Not covered:** Fast R-CNN in depth, HOG, R-CNN, R-FCN, SPP-net.

> [!warning] Contradiction (within the source)
> The text gives YOLO **45 fps**; the chart gives YOLO **21 fps** at 66 % mAP. The chart's caption says every model uses a VGG16 backbone, which is not YOLO's own network, so the two numbers probably describe different YOLO variants (unsourced). The source does not explain it. Use the original papers for any number that matters.

## Relevance to this wiki
- It supplies sourced background for the detector families named in [[object-detection]] and [[methods-10-25cm]]: two-stage ([[faster-r-cnn]]) versus single-shot ([[yolo]], [[ssd-detector]]), and the speed/accuracy trade-off between them.
- It does **not** cover what matters most for this thesis: oriented boxes, small objects in aerial imagery, DOTA, or models after 2016. The thesis detector, YOLO11-OBB on DOTA, comes from [[pretrained-models-search]] and was tested in [[real-e2e-test]].
- **Reliability:** a non-peer-reviewed blog with informal and partly garbled text. Good for orientation, not for citation. For the exposé, cite the original papers instead (Ren et al. 2017; Redmon et al. 2016; Liu et al. 2016), whose metadata are verified in `expose/ergaenzungen.bib`.

## Pages touched
[[object-detection]], [[faster-r-cnn]], [[yolo]], [[ssd-detector]], [[pretrained-models]], [[methods-10-25cm]], [[overview]]

## Related
- [[object-detection]]
- [[faster-r-cnn]]
- [[yolo]]
- [[ssd-detector]]
- [[pretrained-models]]
- [[aerial-cv-benchmarks]]
