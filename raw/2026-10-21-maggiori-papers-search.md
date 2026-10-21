# Maggiori et al. papers: web search notes

Captured 2026-10-21 from web search results; arxiv.org and the PDF hosts were blocked, so the full
texts were not read. Check the PDFs before citing.

## A. High-Resolution Semantic Labeling with Convolutional Neural Networks
- Authors: Emmanuel Maggiori, Yuliya Tarabalka, Guillaume Charpiat, Pierre Alliez.
- arXiv:1611.01962; IEEE Transactions on Geoscience and Remote Sensing, vol. 55, no. 12, pp. 7092-7103, Dec 2017.
- Links: https://arxiv.org/abs/1611.01962 , https://arxiv.org/html/1611.01962 , https://paperswithcode.com/paper/high-resolution-semantic-labeling-with
- Task: dense semantic labeling (one label per pixel). Standard image-classification CNNs are built to
  tolerate local deformations, while pixel labeling needs precise spatial accuracy. Many labeling
  CNNs are adapted categorization networks.
- Aim: integrate local and global information efficiently and flexibly; learn features at several
  resolutions and learn how to combine them.
- Architecture variants compared: base FCN, unpooling, skip, and the proposed MLP network (an MLP
  combines the multi-resolution features). "The MLP network exhibits the best performance in almost every case"
  on the Vaihingen and Potsdam validation sets; it is "simpler and smaller" than many other recent techniques.
- Training: the unpooling, skip and MLP nets are initialised from a pretrained base FCN and jointly retrained, with
  learning rate 0.01, stopping after 30,000 (Vaihingen) and 65,000 (Potsdam) iterations.
- Metrics: overall accuracy (percentage of correctly classified pixels) and mean F1 (because OA is insensitive to minority classes).
- Exact OA/F1 numbers were not retrieved.

## B. Convolutional Neural Networks for Large-Scale Remote-Sensing Image Classification
- Same group (Maggiori, Tarabalka, Charpiat, Alliez), IEEE TGRS 2016/2017; PDF: https://www.lri.fr/~gcharpia/TGRS_2016.pdf ; HAL hal-01369906.
- End-to-end fully convolutional framework for pixelwise satellite image classification.
- Handles imperfect labels with a two-step scheme: pretrain on a large, possibly inaccurate reference set
  (OpenStreetMap), then refine on a small accurately labelled set.
- Related statement from the group's 2017 work: OSM gives free global maps, but misregistrations and omissions are common,
  so CNNs trained on it learn only rough object locations.

## Related work mentioned in the results
- Kaiser et al.: compared manual ground truth with OSM-derived training data for building and road segmentation;
  noisy large-scale data can achieve satisfying performance.
- Comandur & Kak (2021): multiview CNN using noisy OSM labels for large-area building and road labelling.
