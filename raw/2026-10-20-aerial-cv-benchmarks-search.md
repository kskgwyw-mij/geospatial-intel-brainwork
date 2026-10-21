# Aerial computer-vision benchmarks: web search notes

Captured 2026-10-20 from web search results (not full papers). Verify against the papers before citing in the thesis.

## DOTA (object detection in aerial images, oriented bounding boxes)
Sources: https://arxiv.org/pdf/1711.10398 , https://openaccess.thecvf.com/content_cvpr_2018/html/Xia_DOTA_A_Large-Scale_CVPR_2018_paper.html , https://arxiv.org/abs/2102.12219v2
- v1.0: 15 categories annotated by experts: plane, baseball diamond, bridge, ground track field,
  small vehicle, large vehicle, ship, tennis court, basketball court, storage tank,
  soccer-ball field, roundabout, harbor, swimming pool, helicopter.
- v1.5: adds container crane and more extremely small instances (<10 px); 402,089 instances.
- v2.0: 18 categories (adds airport, helipad), 11,268 images, 1,793,658 instances, oriented bounding boxes.

## ISPRS 2D semantic labeling: Vaihingen & Potsdam
Sources: https://www.isprs.org/education/benchmarks/UrbanSemLab/semantic-labeling.aspx , https://arxiv.org/pdf/1611.01962 , https://arxiv.org/pdf/1909.01671
- Vaihingen: 9 cm GSD, 33 IRRG tiles, 16 densely annotated.
- Potsdam: 5 cm GSD, 38 tiles of 6000x6000 px, 24 with dense labels (another source gives a different train/test split).
- Classes (both): impervious surfaces, building, low vegetation, tree, car, clutter/background (clutter usually excluded from evaluation).

## Inria Aerial Image Labeling
Source: https://www.lri.fr/~gcharpia/AerialImageLabelingDataset.pdf
- 30 cm/px RGB, 360 tiles of 5000x5000 px, 10 cities; task = building footprint masks; ground truth public only for training cities.
