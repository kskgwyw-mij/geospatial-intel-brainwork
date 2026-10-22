# Search notes: Visual Terrain-Relative Navigation (VTRN) and visual position localisation (2026-10-22)

Web-search results (search snippets, press releases, repository abstracts; no full texts read), collected by the assistant
on the author's question "Welche Forschungsarbeiten gibt es zu 'Visual Terrain-Relative Navigation' mit Bezug zur
Positionslokalisierung". Bibliographic details as returned by the searches; verify against the originals.

## Origins: planetary landing and guided missiles
- NASA/JPL: Terrain-Relative Navigation (TRN) estimates a spacecraft's position against a surface map onboard; combined
  with a divert manoeuvre it allows landing at harder sites. https://ntrs.nasa.gov/citations/20160009627
- Mars 2020 Lander Vision System (LVS): matches descent-camera images to a landing-site map and fuses them with IMU data
  into map-relative position, velocity and attitude (NTRS 20160009627). Requirement: land within 60 m of the target
  (NTRS 20230007014). Cheng, Ansar & Johnson (2021), Earth and Space Science, doi 10.1029/2020EA001560: the onboard map was built
  from MRO/CTX imagery; the inertial solution alone could be off by up to 3.2 km, and LVS reduced this to < 40 m.
  https://robotics.jpl.nasa.gov/what-we-do/flight-projects/mars-2020-rover/terrain-relative-navigation
- Mourikis, Trawny, Roumeliotis, Johnson, Ansar, Matthies (2009): Vision-Aided Inertial Navigation for Spacecraft Entry,
  Descent, and Landing. IEEE Transactions on Robotics 25(2), 264–280. Mapped landmarks (2D–3D matches of descent
  images to a surface map) plus opportunistic feature tracks in an EKF with the IMU; sounding-rocket test: 6.4 m position
  and 0.16 m/s velocity error at touchdown. 2009 King-Sun Fu Best Transactions Paper Award.
  https://www-users.cse.umn.edu/~stergios/papers/TRO-2009-ST9.pdf
- TERCOM (terrain contour matching, radar altimeter vs. elevation map; proposed by Chance-Vought in the late 1950s per an
  SPIE abstract) and DSMAC (Digital Scene Matching Area Correlator: optical scene vs. reference image, terminal phase).
  Accuracy figures in the found sources are from a blog and an LLM-generated entry, so they are unverified.
  https://spiedigitallibrary.org/conference-proceedings-of-spie/0238

## Visual TRN for aircraft and UAVs (image-to-orthophoto / satellite)
- Conte & Doherty (2009): Vision-Based Unmanned Aerial Vehicle Navigation Using Geo-Referenced Information. EURASIP
  J. Advances in Signal Processing 2009:387308, doi 10.1155/2009/387308. INS + visual odometry + matching onboard video
  to a geo-referenced aerial image for long GPS outages; drift-free, but the accuracy depends on the terrain's structure.
  Flight-tested on a Yamaha RMAX helicopter.
- Goforth & Lucey (2019): GPS-Denied UAV Localization using Pre-existing Satellite Imagery. ICRA 2019, 2974–2980.
  Downward monocular RGB, CNN features trained on satellite data, joint optimisation over adjacent frames; < 8 m mean
  error at 0.2 km altitude over 0.85 km. Later criticised for needing pre-training on the task area.
- Patel, Barfoot & Schoellig (2020): Visual Localization with Google Earth Images for Robust Global Pose Estimation of
  UAVs. ICRA 2020. Mutual-information registration against rendered Google Earth views; < 1 m and 1° RMSE on a 303 m flight.
- Fragoso et al. (2021): A Seasonally Invariant Deep Transform for Visual Terrain-Relative Navigation. Science Robotics,
  23 June 2021 (Caltech/JPL, Soon-Jo Chung's group; funded by Boeing and NSF). VTRN is "extremely fragile" to seasonal
  effects (lighting, vegetation, snow); a deep image transform maps seasonal imagery into a stable domain usable by
  conventional registration. Full author list / article number not confirmed by the search.
  https://www.caltech.edu/about/news/new-algorithm-helps-autonomous-vehicles-find-themselves-summer-or-winter ;
  https://authors.library.caltech.edu/109566/
- Kinnari, Verdoja & Kyrki (2021): GNSS-denied geolocalization of UAVs by visual matching of onboard camera images with
  orthophotos (arXiv 2103.14381). Monte-Carlo localisation with IMU, a camera in any direction and an orthophoto map; mean
  error < 50 m RMS after convergence (about 2 km of travel) with the classical matcher.
- Kinnari, Verdoja & Kyrki (2022): Season-Invariant GNSS-Denied Visual Localization for UAVs. IEEE RA-L 7(4),
  10232–10239 (arXiv 2110.01967). CNN matching UAV images to orthophotos across winter/summer; large gains over 6 reference
  methods under strong seasonal change. Follow-up LSVL (Robotics and Autonomous Systems 2023, arXiv 2212.03581) for larger areas.

## Reviews and datasets
- Couturier & Akhloufi (2021): A review on absolute visual localization for UAV. Robotics and Autonomous Systems 135,
  103666, doi 10.1016/j.robot.2020.103666. Same group: "A Review on Deep Learning for UAV Absolute Visual Localization",
  Drones 2024.
- Zheng, Wei & Yang (2020): University-1652: A Multi-view Multi-source Benchmark for Drone-based Geo-localization. ACM
  Multimedia 2020, 1395–1403 (arXiv 2002.12186). Synthetic drone, satellite and ground images of 1,652 buildings; tasks:
  drone-view target localisation and drone navigation.
- Xu, Yao, Cao et al. (2024): UAV-VisLoc: A Large-scale Dataset for UAV Visual Localization (arXiv 2405.11936). 6,742
  drone images and 11 satellite maps at 11 locations in China, with coordinates, altitude and date; motivation: earlier
  datasets were small or urban only.
- A 2025 review (Satellite Navigation, doi 10.1186/s43020-025-00162-z) on GNSS-denied UAV navigation: challenges persist in
  regions lacking clear semantic features, particularly at low altitude.

## Semantic / vector-map localisation (closest to object-based OSM matching)
- Sarlin et al. (2023): OrienterNet: Visual Localization in 2D Public Maps with Neural Matching. CVPR 2023, 21632–21642
  (arXiv 2304.02009). Matches a neural bird's-eye view of a ground-level image against OpenStreetMap; sub-metre accuracy;
  crowd-sourced data from 12 cities; code public.
- "A semantic vector map-based approach for aircraft positioning in GNSS/GPS denied large-scale environment" (2023,
  ScienceDirect S2214914723001903): downward camera + altimeter + compass + open-source vector map (VMAP); building-contour
  vector matching + particle filter with a credibility indicator. It cites a building shape-matching method with 3.6 m error
  over a 2.2 km² reference map. Authors not captured by the search.
- SASGeo: Stability-Aware Semantic Map Localization for GNSS-Denied UAVs — A Framework and Synthetic Proof of Concept
  (arXiv 2607.07737, 2026). Roads, buildings, waterways and intersections as persistent map structure; semantic raster
  alignment + relational graph evidence; rejects ambiguous matches. Retrieval in 220 randomized trials: global semantic
  descriptor 58.6 % Recall@1, spatial semantic matching 94.5–95.5 %. Explicitly not validated on real flights.
- Large-Scale Geometric Map-Based Localization of UAVs in GNSS-Denied Urban Environments (arXiv 2609.28225, 2026) — urban only.
