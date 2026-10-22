# Author note: novelty assessment (2026-10-22)

Pasted by the author in the conversation (verbatim below), followed by the assistant's verification of the cited works.

---

Somewhat, yes. The combination looks new, but none of the ingredients are.
Already exists:

* Matching detected objects to landmarks from OSM with a scene graph. Kunz et al. (2021) compare detector output with OSM landmarks this way, though for ground robots. [sbc](https://sol.sbc.org.br/index.php/sbrlars/article/view/18344)
* Subgraph matching against road and building footprint graphs. One system did this for urban image localization and cut location uncertainty by up to 90% in many cases, with a user identifying the buildings by hand. [imaging](https://library.imaging.org/ei/articles/28/15/art00020)
* Point-process models of landmarks. Hu and Dhillon model indistinguishable landmarks as a Poisson point process, but to analyze when localization is possible, not as a working pipeline. [arxiv](https://www.arxiv.org/abs/2409.09525)
* OSM as a reference for localization generally, and probabilistic filters on it. OrienterNet, MapLocNet and OSMLoc are the ground-level examples. SASGeo adds rejection of ambiguous fixes, but only on synthetic data. [arxiv](https://arxiv.org/pdf/2608.07835)[arxiv](https://arxiv.org/pdf/2607.07737)

Not found in anything I read: all of these together. That means POI-level classes detected in nadir imagery, an explicit detector-error model (recall, false alarms, confusion, position noise) inside a point-process likelihood, a calibrated heatmap with a null hypothesis, and a spatially blocked cross-region and cross-provider test. SASGeo itself says that kind of real-data evaluation is still needed.

---

## Verification by web search (2026-10-22; snippets/abstracts only, direct page fetches failed with DNS errors)
- Kunz, Vierling, Wolf & Berns (2021): "Localization using OSM landmarks". 13th SBR/LARS (online), Anais pp. 228–233,
  SBC. Supplements GNSS; compares OSM-derived landmarks with detector output using several metrics; a scene graph stores
  expected vs. detected objects; urban ground robots. CONFIRMED (abstract).
- Shankar, Zhang, Chen et al. (UC Berkeley): "Approximate Subgraph Isomorphism for Image Localization". Electronic
  Imaging 28(15), 2016. Graph of buildings, intersections and roads from public road and footprint data; the user builds the
  query graph by hand; subgraph isomorphism plus shadow and geometry pruning; 2–47 km² regions in Amman and Berkeley;
  "reduces uncertainty … by as much as 90 percent" in many cases. CONFIRMED (abstract).
- Hu, Dhillon & Buehrer (2024): "Foundations of Vision-Based Localization: A New Approach to Localizability Analysis Using
  Stochastic Geometry". arXiv 2409.09525. Indistinguishable landmarks (trees, lampposts, bus stops) as a PPP; localizability
  = probability that measurements at the target differ enough from those at a reference location; tends to 1 as landmark
  intensity grows. Follow-up arXiv 2501.18758 (marked PPP; three noise-free ranges suffice in 2D). CONFIRMED.
- MapLocNet: Wu et al., arXiv 2407.08561 (2024), coarse-to-fine feature registration in navigation maps, autonomous driving.
  OSMLoc: Liao, Chen et al., arXiv 2411.08665 (2024; v3 2025), single-image localisation in OSM with geometric and semantic
  guidance. CONFIRMED.
- SASGeo, arXiv 2607.07737: "does not validate real-flight navigation" (from the earlier search). CONFIRMED.
- arXiv 2608.07835: NOT FOUND. No search result for that ID; content unknown.
- Found in passing: "Road Descriptors for Fast Global Localization on Rural Roads Using OpenStreetMap", Sensors 2023
  (PMC10537067), a rural OSM-based localisation for ground vehicles.
