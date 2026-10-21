# Rural / road-sparse aerial geolocalisation: web search notes

Captured 2026-10-21 from web search results (snippets). Verify before citing.

- Season-invariant GNSS-denied visual localisation for UAVs, https://arxiv.org/pdf/2110.01967 : images are orthoprojected
  with a DEM; mean errors after 2 km of travel were 26.5 m, 29.1 m and 30.6 m on three flights. The DEM was used to exclude
  elevation-estimation errors (an idealised setup).
- MVA 2007, https://www.mva-org.jp/Proceedings/2007CD/papers/08-21.pdf : UAV navigation by tracking rivers, agricultural
  fields and roads. Natural land covers usually lack smooth boundaries; their edges are rarely continuous and are often
  partly hidden by trees and bushes.
- "A Template Matching Based Approach for Geolocating Cadastral Aerial Images" (2025),
  https://digitalcommons.isical.ac.in/journal-articles/5223 : segment aerial images into land-cover classes (roads,
  vegetation, trees, barren), convert them to simplified boundary maps, and template-match against larger maps; code public.
- AirZoo, https://arxiv.org/pdf/2604.26567 : the AirZoo-Real dataset includes a rural subset of 190 images, mostly
  agricultural landscapes, with Google Maps satellite references, which could serve as a rural evaluation set.
