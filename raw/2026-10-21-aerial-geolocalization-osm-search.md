# Aerial image geolocalisation against OSM: web search notes

Captured 2026-10-21 from web search results (snippets). Verify before citing.

## Costea & Leordeanu, "Aerial image geolocalization from recognition and matching of roads and intersections", BMVC 2016
Links: https://arxiv.org/pdf/1605.08323 , https://bmva-archive.org.uk/bmvc/2016/papers/paper118/index.html
- Learn to detect roads and intersections in aerial images.
- Identify specific intersections with a high-level descriptor that links them to intersections in OSM maps,
  which gives the enclosing region.
- Refine with geometric alignment of detected roads to OSM roads, which gives an accurate localisation.
- Tested on two European cities; accurate even when trained on one city and tested on the other, with relatively poor image quality.
- Motivation: drone localisation where GPS is unavailable.

## Lin et al. (SPIE), semantic-level descriptors for UAV-to-satellite matching
Link: https://ebooks.spiedigitallibrary.org/profile/Chi-Han.Lin-5129655
- An object recognition model extracts semantic-level descriptors from the UAV image and matches them to satellite imagery.
- Semantic descriptors are orders of magnitude fewer than pixel-level descriptors; semantic matching was 648x faster than feature matching.
