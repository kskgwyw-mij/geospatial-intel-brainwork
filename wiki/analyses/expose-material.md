---
title: Exposé-Materialsammlung (Stichpunkte je Abschnitt)
type: analysis
tags: [thesis, expose, ai-use]
sources: [author-decision-title, author-literature-list, author-note-novelty, vtrn-literature-search, wa-course-expose, hok-ki-leitlinie, hok-aspo-2026, author-note-use-cases-gnss-denied, author-decision-no-metadata, author-decision-detection-in-scope, author-decision-search-region, osm-real-test, real-e2e-test, settlement-test, settlement-overpass-labels, localization-levers-test, costea-2016-aerial-geolocalization, maggiori-2017-hr-semantic-labeling, maggiori-osm-imperfect-labels, aerial-cv-benchmarks, pretrained-models-search, bayern-dop20rgb-detail, rural-geolocalization-search]
updated: 2026-10-22
---
Stichpunkte, Zahlen und Quellen für jeden Pflichtabschnitt des Exposés, als Ausgangspunkt für den eigenen Text; dazu eine Faktenliste für die KI-Dokumentation. Hier steht bewusst **kein Fließtext**: Das Exposé formuliert die Autorin oder der Autor selbst ([[wa-course-expose]], [[hok-ki-leitlinie]]).

## Formales (Abgabe 23.10.2026, Moodle)
- **Satz in Typst:** Vorlage `expose/expose.typ` (anonym, Pflichtgliederung, Hinweisboxen, die sich mit `zeige-hinweise = false` ausblenden), Literatur in `expose/literatur.bib`, zweites PDF `expose/ki-dokumentation.typ`. Kompilieren: `typst compile expose/expose.typ`.
- PDF 1: Exposé **ohne Namen**, auch nicht in den PDF-Eigenschaften (Autor-Feld) prüfen ([[wa-course-expose]]).
- PDF 2: verwendete Tools mit den jeweiligen Aufgaben, plus geschätzter KI-Anteil in %; **über 50 % ist nicht erlaubt** ([[wa-course-expose]]).
- Gliederung genau wie vorgegeben: Arbeitstitel · Ausgangssituation und Problemstellung · Relevanz · Zielsetzung und Ergebnisse · Vorgehensweise und Methoden · Literatur.
- Danach: Anmeldung der Masterarbeit (Formular + Exposé) bis 31.10.2026 ([[wa-course-expose]]).

## Arbeitstitel — gewählt
**„Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen: Eine Generalisierungsstudie über Regionen und Bodenauflösungen“**; englisch: „Calibrated Probabilistic Geolocalization of Nadir Imagery with OpenStreetMap Features: A Generalization Study across Regions and Ground Sampling Distances“ ([[author-decision-title]]). Steht in `expose/expose.typ`. Begriff: **Bodenauflösung / Ground Sampling Distance (GSD)** statt „Zoomstufe“; im Methodenteil einmal definieren (Bodenfläche pro Pixel, z. B. 0,2 m bei DOP20).
- Abgleich mit den Kursvorgaben ([[wa-course-expose]]):
  - Haupttitel 8 Wörter, mit Untertitel 14, also über der Faustregel 8–12.
  - Fachbegriffe wie „kalibriert“, „probabilistisch“, „Nadir“ sind für Fachfremde nicht selbsterklärend.
  - Präzise, ohne Abkürzungen, verrät keine Ergebnisse.
  - Bewusste Entscheidung der Autorin oder des Autors.

## Arbeitstitel — Bausteine (frühere Notizen)
- Kernidee in Alltagssprache: *Luftbild ohne Ortsangabe → Ort, Maßstab und Ausrichtung aus erkannten Kartenobjekten*.
- Vermeiden laut Vorgabe: Abkürzungen (OSM, GNSS, DOP, RANSAC), Fachjargon; ≤ 8–12 Wörter; keine Ergebnisse vorwegnehmen ([[wa-course-expose]]).
- Begriffe, die Fachfremde verstehen: „Drohnenbild“, „Luftbild“, „ohne GPS“, „offene Kartendaten“, „OpenStreetMap“ (Eigenname), „automatisch verorten“.
- Ideen zum Weiterentwickeln (Brainstorming, nicht fertig):
  - Frageform: „Wo wurde dieses Luftbild aufgenommen? …“
  - Spannung: Bild gegen Karte, Erkennen gegen Verorten.
  - Region als Untertitel: „… am Beispiel des bayerischen Alpenrands“.

## Ausgangssituation und Problemstellung — Material
- **Ausgangssituation:**
  - Drohnen und Luftbilder sind auf GNSS angewiesen; bei Ausfall, Störung oder Abschattung fehlt die Position (Use cases: [[author-note-use-cases-gnss-denied]]).
  - Offene Kartendaten (OpenStreetMap über die Overpass-API) und amtliche Orthofotos (DOP20, 20 cm, CC BY 4.0, [[bayern-dop20rgb-detail]]) sind frei verfügbar.
- **Problem:** Ein Foto **ohne Metadaten** soll allein aus dem Bildinhalt verortet, skaliert und ausgerichtet werden ([[author-decision-no-metadata]]). Dafür muss man
  - Objekte erkennen (Erkennung und Klassifikation sind Teil der Arbeit, [[author-decision-detection-in-scope]]) und
  - die erkannten Objekte mit der Karte abgleichen.
- **Vorarbeit der Literatur:**
  - Straßenkreuzungen als „Fingerabdruck“ gegen OSM: etwa 90 % der Kreuzungen auf 2,5 m genau, bei 1 m/px ([[costea-2016-aerial-geolocalization]]).
  - CNN-Segmentierung von Luftbildern: Gebäude-F1 etwa 95 bei 9 cm ([[maggiori-2017-hr-semantic-labeling]]).
  - Training mit ungenauen OSM-Labels plus kleinem korrigiertem Satz ([[maggiori-osm-imperfect-labels]]).
- **Problembereich, ländlich und alpin:**
  - Straßen allein tragen dort nicht ([[author-note-rural-roads]]).
  - In der eigenen Vorprüfung enthalten nur 0,1–1,6 % zufälliger Bildausschnitte genug punktförmige Objekte; 22 % enthalten gar kein kartiertes Merkmal ([[localization-levers-test]]).
- **Untersuchungsraum:** Alpenrand-Landkreise in Oberbayern Süd, ca. 7.800 km², als Parameter austauschbar ([[author-decision-search-region]]).

## Relevanz — Material
- **Praktisch:**
  - GNSS-unabhängige Navigation: Ausfall, Störung oder Täuschung des Signals, Abschattung im Gebirge, Bergrettung.
  - Nachträgliches Verorten alter Luftbilder.
  - Prüfen, ob die OSM-Daten vollständig sind ([[author-note-use-cases-gnss-denied]], [[gnss-denied-use-cases]]).
- **Theoretisch (Wissenslücke):**
  - Bekannte Ansätze nutzen dichte Merkmale wie Straßenkreuzungen in Städten ([[costea-2016-aerial-geolocalization]]).
  - Wie weit objektbasierte Verortung in **merkmalsarmen ländlichen und alpinen Gebieten** trägt und wie viele Objekte nötig sind, ist offen (Lücke im Wiki; mit Literatur belegen!).
  - **Neuheit liegt in der Kombination, nicht in den Bausteinen** ([[author-note-novelty]], [[thesis-contribution]]). Belegte Vorarbeiten:
    - Objekt-zu-OSM-Landmarken über einen Szenengraphen, für Bodenroboter (Kunz et al. 2021);
    - Subgraph-Matching auf Straßen- und Gebäudegraphen mit händisch erstelltem Abfragegraphen (Shankar et al. 2016);
    - Punktprozess-Modell ununterscheidbarer Landmarken, nur als Analyse (Hu, Dhillon & Buehrer 2024);
    - OSM-Lokalisierung bodennah (OrienterNet, MapLocNet, OSMLoc); SASGeo nur synthetisch.
  - Neu ist die Kombination:
    - POI-Klassen aus Senkrechtaufnahmen erkannt;
    - ein Detektor-Fehlermodell in einer Punktprozess-Likelihood;
    - eine kalibrierte Heatmap mit Nullhypothese;
    - ein räumlich geblockter Test über Regionen und Bildanbieter hinweg.
  - arXiv 2608.07835 = **SeqLoc** (Zheng et al. 2026), laut eigener Literaturliste ([[author-literature-list]]).
  - **Eigene Literaturliste (30 Werke)** ist jetzt `expose/literatur.bib` und erscheint im Exposé. Ungeprüfte KI-Vorschläge stehen getrennt in `expose/kandidaten.bib`. Nächste Nachbarn zur Abgrenzung (Volltexte lesen!): Schleiss 2019, Wei et al. 2022, Ouyang et al. 2024, SWA-PF 2025, SeqLoc 2026.
- **Mehrwert:** Kombination aus Erkennung (Forschungsfrage FF1) und Verortung (FF2), reproduzierbar mit offenen bayerischen Daten.
- **Literatur zur Relevanz (Kandidaten aus der Recherche, [[vtrn-literature-search]]):** Das Feld heißt *(Visual) Terrain-Relative Navigation* bzw. *Absolute Visual Localization* ([[terrain-relative-navigation]]).
  - Übersicht: Couturier & Akhloufi 2021.
  - Raumfahrt: Mars 2020 LVS; Mourikis et al. 2009.
  - UAV: Conte & Doherty 2009; Goforth & Lucey 2019; Kinnari et al. 2022; Fragoso et al. 2021 zur Saisonabhängigkeit.
  - Semantische Karten: OrienterNet 2023 (OSM, bodennah), SASGeo 2026 (nur synthetisch).
  - Ein Review von 2025 nennt Gebiete ohne klare semantische Merkmale als offenes Problem; **genau dort setzt die Lücke an**.
  - Alle Quellen bisher nur aus Suchtreffern: **selbst lesen und prüfen**.

## Zielsetzung und Ergebnisse — Material
- **Wissenschaftliche Ziele:**
  - Erkennungsgüte je Objektklasse messen (FF1).
  - Erfolgsquote und Genauigkeit der Verortung in Abhängigkeit von Anzahl und Art der erkannten Objekte messen (FF2).
- **Praktisches Ziel:** ein Prototyp: Foto hochladen → erkannte Objekte → Position, Maßstab und Ausrichtung mit Konfidenz ([[poc-platform]]).
- **Erwartete Ergebnisse:**
  - Kennzahlen je Klasse (Precision, Recall, F1, mAP).
  - Erfolgsquote nach Anzahl der Objekte.
  - Grenzen der Methode (Anteil nicht verortbarer Bilder).
  - Empfehlungen, welche Kartenmerkmale nötig sind.
- **Forschungsfrage, aktueller Kandidat** (Autornotiz, [[thesis-timeline]]): „Wie zuverlässig lässt sich eine Drohnenaufnahme ohne Metadaten allein anhand erkannter OSM-Objekte lokalisieren, skalieren und ausrichten, und wie viele Objekte sind dafür in alpinen und ländlichen Gebieten nötig?“
  - Unterfragen (Vorschlag aus dem Wiki): FF1 Erkennung, FF2 Verortung.
  - Mit der Betreuung fixieren ([[wa-course-expose]]).
- **Leiter aus dem Kurs:** Thema (Objekterkennung in Luftbildern mit OSM) → Problem (Verortung ohne Metadaten) → Problembereich (GNSS-lose Drohnen in merkmalsarmen Gebieten) → Forschungsfrage ([[expose-guide]]).

## Vorgehensweise und Methoden — Material
- **Rahmen:** Design-Science-ähnlich, also ein Artefakt (Prototyp) bauen und quantitativ evaluieren. Rahmen ist noch nicht belegt, selbst mit Literatur prüfen (unsourced).
- **Schritte:**
  1. **Daten:**
     - OSM-Objekte über die Overpass-API als Labels und Referenzkarte.
     - DOP20 als Bilddaten, mit historischen Befliegungen für Robustheitstests ([[bayern-dop20rgb-detail]]).
  2. **Erkennung (FF1):**
     - Vortrainierter Detektor mit gedrehten Boxen (YOLO11-OBB, auf DOTA trainiert) als Baseline.
     - Feinabstimmung mit OSM- und amtlichen Labels ([[pretrained-models-search]], [[maggiori-osm-imperfect-labels]]).
  3. **Verortung (FF2):** Abgleich erkannter Objekte mit der Karte über robuste Ähnlichkeitstransformation (RANSAC: Position, Maßstab, Drehung) und Konfidenzstufen ([[geo-match-prototype]]).
  4. **Evaluation:**
     - Räumliche Kreuzvalidierung.
     - Übertragung auf einen anderen Landkreis und eine ältere Befliegung.
     - Ca. 100 Testbilder je Bedingung für ±10 Prozentpunkte ([[feasibility]]).
  5. **Prototyp:** Upload-Plattform ([[poc-platform]]).
- **Vorprüfung, schon vorhanden** (ehrlich als KI-gestützte Machbarkeitsprüfung deklarieren, siehe unten):
  - Detektor ohne Feinabstimmung: Precision 0,49, Recall 0,62 ([[real-e2e-test]]).
  - Siedlungserkennung je Hektar: AUC 0,98–0,995, stabil über Landkreise und Befliegungsjahre ([[settlement-test]], [[settlement-overpass-labels]]).
  - Verortung: 6/40 Bilder nahe bekannter Objekte, 0/40 zufällige ([[real-e2e-test]]).
- **Abgrenzung:** keine Schrägaufnahmen, keine Echtzeit, Nadir-Fotos; zivile Nutzung; Lizenzen DOP CC BY 4.0, OSM ODbL ([[gnss-denied-use-cases]]).

## Literatur — Kandidaten (vor Verwendung selbst lesen und bibliografisch prüfen)
| Zweck | Quelle | Stand im Wiki |
|---|---|---|
| Vorarbeit Verortung | Costea, D. & Leordeanu, M. (2016): Aerial image geolocalization from recognition and matching of roads and intersections. BMVC 2016, arXiv:1605.08323 | Volltext gelesen ([[costea-2016-aerial-geolocalization]]) |
| Methode Segmentierung | Maggiori, E., Tarabalka, Y., Charpiat, G. & Alliez, P. (2017): High-resolution aerial image labeling with convolutional neural networks. IEEE TGRS 55(12), 7092–7103 | Volltext gelesen ([[maggiori-2017-hr-semantic-labeling]]) |
| Methode OSM-Labels | Maggiori et al. (2017): Convolutional neural networks for large-scale remote-sensing image classification. IEEE TGRS | nur Suchtreffer ([[maggiori-osm-imperfect-labels]]) |
| Datensatz Detektion | DOTA (Xia et al., CVPR 2018) | nur Suchtreffer ([[aerial-cv-benchmarks]]); Angaben prüfen |
| Detektor | Ultralytics YOLO11-OBB (Software) | nur Suchtreffer ([[pretrained-models-search]]) |
| Ländliche Verortung | Ansätze mit Geländemodell und Landbedeckungsgrenzen | nur Suchtreffer ([[rural-geolocalization-search]]) |
| Daten | Bayerische Vermessungsverwaltung: DOP20 (CC BY 4.0); OpenStreetMap-Mitwirkende (ODbL) | Produktseiten ([[bayern-dop20rgb-detail]]) |
| Relevanz / Forschungsstand | Couturier & Akhloufi 2021 (Review); Conte & Doherty 2009; Goforth & Lucey 2019; Kinnari et al. 2022; Fragoso et al. 2021; Mourikis et al. 2009; Sarlin et al. 2023 (OrienterNet); Zheng et al. 2020 und Xu et al. 2024 (Datensätze) | nur Suchtreffer ([[vtrn-literature-search]]); Einträge in `expose/literatur.bib` |
| **Fehlt noch** | Volltexte der obigen Quellen lesen; OSM-Datenqualität | selbst recherchieren |

Hinweise des Kurses: Recherchetools (Elicit, Consensus, ResearchRabbit …) liefern Kandidaten, aber ohne Qualitätsprüfung und mit „Vollständigkeitsillusion“. Geschützte PDFs nicht in KI-Lesetools hochladen; selbst lesen ([[wa-course-expose]]).

## KI-Dokumentation — Faktenliste (Grundlage für PDF 2)
Belegt durch [[log]] und die Git-Historie dieses Repositorys. Das verwendete Tool war **Claude Code (Anthropic)**, ein KI-Assistent. Es hat:

| Aufgabe | Was die KI gemacht hat | Was du selbst gemacht hast / machen musst |
|---|---|---|
| Wissensbasis | Wiki mit etwa 60 Seiten aufgebaut: Quellenzusammenfassungen, Querverweise, Entscheidungsseiten | Quellen ausgewählt, Fragen gestellt, Entscheidungen getroffen (Region, Nadir, ohne Metadaten, Erkennung im Umfang) |
| Literatur | Websuchen; zwei Paper-PDFs zusammengefasst (Costea, Maggiori) | Paper selbst lesen; Literatur für die Relevanz selbst suchen |
| Forschungsfrage | Unterteilung in FF1/FF2 und Kandidatenformulierungen vorgeschlagen | Ursprüngliche Frage und Use cases (Autornotiz); Fixierung mit der Betreuung |
| Code | Prototyp-Werkzeuge in `tools/` geschrieben (Matcher, Simulation, Realdaten-Tests, Overpass-Tools) | — |
| Daten und Auswertung | Machbarkeitstests mit echten Daten ausgeführt und ausgewertet | **Hinweis:** Der Dozent rät stark von KI für Datenarbeit ab. In der Arbeit selbst ausführen, prüfen und verstehen; im Exposé als KI-gestützte Vorprüfung kennzeichnen |
| Exposé-Text | nur Struktur, Checkliste und diese Stichpunkte; **kein Fließtext** | Text selbst schreiben |
| Kursunterlagen | Zusammenfassung der hochgeladenen Kursfolien und Leitlinien | Klären, ob das Hochladen erlaubt war ([[hok-ki-leitlinie]]) |

Prozentschätzung: Die Zahl legst du selbst fest; sie muss ≤ 50 % sein ([[wa-course-expose]]). Ein ehrlicher Weg: den Anteil pro Abschnitt schätzen, wobei Text, Ideen und Analysen unterschiedlich gewichtet werden, und dann mitteln.

## Related
- [[thesis-contribution]]
- [[expose-guide]]
- [[wa-course-expose]]
- [[hok-ki-leitlinie]]
- [[thesis-timeline]]
- [[localization-improvements]]
