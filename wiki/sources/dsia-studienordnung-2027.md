---
title: Studienordnung MSc DSIA (from WS 2027/28)
type: source
tags: [thesis, program, curriculum]
sources: [dsia-studienordnung-2027]
raw: raw/2026-10-20-dsia-studienordnung-ws2027.pdf
updated: 2026-10-20
---
The official 83-page study regulation of the HOK MSc Data Science & Intelligent Analytics (full-time and part-time), version 1, approved 24.06.2026, for cohorts starting in WS 2027/28.

## Summary

Official curriculum for both organisational forms (vz = full-time, bb = part-time): job
profiles, competency matrix, semester-by-semester course matrix, module descriptions and
admission rules. Supplied by the author as an extra source for the study programme. It
supersedes the third-party facts in [[hok-dsia-program-listings]] wherever they overlap.

## Key claims

**Programme data (§2.1)**
- MSc (Master of Science in Engineering), 4 semesters, 120 ECTS, full-time and part-time.
- Entry places per year: 33 full-time, 25 part-time (title page).
- Part-time teaching language is German, with 35.35 % of SWS in English courses; full-time is English only (B2 required).
- Winter semester runs KW 40 – KW 5, summer semester KW 11 – KW 28, 15 weeks each. No compulsory semester abroad, no internship.

**Part-time curriculum (§2.2.2)**

| Sem | Courses (ECTS) |
|---|---|
| 1 | Leadership & PM (2), Systemic Innovation (2), Statistical Learning 1 + Lab (6+2.5), Data Engineering + Lab (4+5), Software Development 1 + Lab (6+2.5) |
| 2 | Study Trip (3), **Machine Learning & Deep Learning (10)**, Statistical Learning 2 + Lab (6+2.5), Software Development 2 + Lab (6+2.5) |
| 3 | Big Data Processing (4), **Artificial Intelligence (4)**, **Praxisprojekt (4)**, DS for Business & Commerce (4), **DS for Engineering & Natural Sciences (4)**, **Scientific Writing (2)**, electives 2 of 8 (4 each) |
| 4 | Business Ethics, Compliance & Law (3), **Master's thesis (22)**, **Thesis colloquium (2)**, elective 1 of 4 (3) |

**Thesis rules (module MWA, 26 ECTS)**
- The 22 thesis ECTS are split into 20 ECTS for the thesis and 2 ECTS for the examination before a committee (kommissionelle Abschlussprüfung).
- Process: the student designs their own project idea, writes an **exposé**, and submits it to the **programme director (Studiengangsleitung) for approval**. They then work on the topic and hand in the thesis for assessment. Taught as "coaching".
- Semester 3, *Wissenschaftliches Arbeiten* (MWA.1): produces the first exposé draft, aligning problem, research question and method. Assessed by a report.
- Semester 4, *Kolloquium* (MWA.2): the research question or hypothesis, the outline and the method are presented and challenged. Assessed by a presentation.
- Supervision is budgeted at 0.6 SWS per thesis.

**Courses directly relevant to the thesis topic**
- MLAL.3 *Machine Learning & Deep Learning* (Sem 2, 10 ECTS, English): classical NNs vs. random forests and SVMs, **CNNs**, RNN/LSTM, GAN/BERT/CGAN, plus current network types. Aim: "design and independently carry out end-to-end ML projects". Assessed by portfolio.
- MLAL.1/.5 *Statistical Learning 1/2*: trees, random forests, PCA, ensembles, model optimisation. These supply the classical-ML baselines.
- MDS.6 *DS for Engineering & Natural Sciences* (Sem 3, English): includes "**object recognition through image data processing**" and sensor-data obstacle detection. Assessed by a seminar paper.
- DPR.9 *Artificial Intelligence* (Sem 3, English): includes "**visual object recognition**" under constraint approaches, plus SVMs, boosting and neural nets.
- MDS.4 *Praxisprojekt* (Sem 3, 4 ECTS): a real, data-centred project across the whole data value chain, from collection and storage to analysis and use. Assessed by project documentation.
- WPF.1 *Application-oriented analytics platforms* (elective): KNIME, RapidMiner, Grafana, plus cloud (Google Cloud, AWS, Azure). The reading list includes Amazon SageMaker/Rekognition.
- WPF.8 *Human AI Interaction* (elective): UX for AI, XAI, human-in-the-loop, usability testing. Relevant to the PoC platform UI.
- ETHR.1 *Business Ethics, Compliance & Law* (Sem 4): GDPR, e-Privacy, AI Act (reading list).
- DPR.1 *Big Data Processing*: Spark, Flink, Kafka, with access to central "Data Labs".

**Admission (§3)**: a relevant bachelor's degree of at least 180 ECTS, with at least 6 ECTS of IT
(computer use, databases, software development) and at least 8 ECTS of maths and statistics. For
the part-time form, professional experience or certificates can make up missing prerequisites.

## Internal inconsistencies spotted
- Total SWS: §2.1 gives 48.5 for both forms, but the part-time summary table gives 49.5.
- Full-time places: the title page says 33, the §2.2 supervision calculation uses 25.
- Neither matters for the thesis.

## Relevance to this wiki

- The curriculum has **no geospatial, GIS or remote-sensing content**. OSM, Overpass,
  coordinate systems and orthoimagery handling must be learned and justified within the
  thesis itself. Image-based object recognition, however, is explicitly in scope (MDS.6, DPR.9, MLAL.3 CNNs).
- The thesis should be framed as an **end-to-end ML project** (MLAL.3's stated goal) with a
  clear research question and method, because that is what the exposé and colloquium assess.
- The **Praxisprojekt** (Sem 3) is a natural pilot for the Overpass → label → model pipeline before the thesis semester.
- This regulation applies to cohorts **starting WS 2027/28**. Whether it applies to the author depends on their start year.

## Pages touched
[[hok-dsia-master]], [[thesis-timeline]], [[overview]], [[thesis-poc-pipeline]], [[poc-platform]]

## Related
- [[hok-dsia-master]]
- [[thesis-timeline]]
- [[hok-dsia-program-listings]]
