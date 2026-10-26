---
title: Exposé-Entwurf — strenge Bewertung (22.10.2026)
type: analysis
tags: [thesis, expose, review, evaluation-design]
sources: [localization-levers-test, real-e2e-test, osm-real-test, settlement-overpass-labels, aerial-cv-benchmarks, costea-2016-aerial-geolocalization, author-literature-list, author-note-novelty, vtrn-literature-search, wa-course-expose, hok-aspo-2026, author-decision-generalisation-axes, author-decision-framework-scope, settlement-test, bayern-dop20rgb-detail, maggiori-osm-imperfect-labels, peer-review-expose]
updated: 2026-10-26
---
Strenge Bewertung des Exposé-Entwurfs vom 22.10.2026: Urteil Gut bis Befriedigend (2–3), acht schwere Mängel (vor allem fehlendes Erfolgskriterium, nie variierter Maßstab, Kernklassen ohne Abdeckung, Testdesign ohne Negativbilder), mit Prioritäten für Abgabe (23.10.) und Anmeldung (31.10.).

Bewertet wurde das PDF, das der Autor am 22.10.2026 hochgeladen hat. Es ist bytegleich mit `expose/expose-ki-entwurf.pdf` auf `main` (Commit 411def2, Typst 0.15, 4 Seiten); der Quelltext ist `expose/expose-ki-entwurf.typ`. Seitenangaben beziehen sich auf dieses PDF.

## Gesamturteil
Für ein Exposé klar überdurchschnittlich: Pflichtgliederung eingehalten ([[wa-course-expose]]), eigene Vordaten, ein konkretes Verfahren und eine ehrlich formulierte Lücke. Streng bewertet in dieser Fassung **Gut bis Befriedigend (2–3)**. Drei Gründe:
1. Das zentrale Erfolgskriterium fehlt.
2. Das Testdesign prüft zwei Versprechen des Titels nicht: den unbekannten Maßstab und die Übertragbarkeit.
3. Die eigene Vorprüfung zeigt für die Kernklassen eine sehr geringe Abdeckung, und das Design reagiert nicht darauf.

Alles ist behebbar.

| Kriterium | Urteil |
|---|---|
| Gliederung, Pflichtteile, Anonymität | Erfüllt; auch die PDF-Metadaten enthalten keinen Autornamen ([[wa-course-expose]]) |
| Problemstellung | Stark, weil eigene Daten; Angaben zu Stichprobe und Auswahl fehlen |
| Relevanz | Praktisch überdehnt (Drohnen, getestet wird auf Orthofotos); theoretisch nur eine Kombinationslücke |
| Ziele und Forschungsfrage | Nicht messbar, weil die Erfolgsschwelle offen ist |
| Methode | Anspruchsvoll; Suchraum, Nullhypothesentest, Maßstab und Fehlermodell ungeklärt |
| Literatur | Solide Basis ([[author-literature-list]]); Messmodelle, Kalibrierung und räumliche Kreuzvalidierung fehlen |
| Form und Sprache | Sauber; doppelte Zitate, wechselnde Begriffe |

## Bewusste Entscheidungen des Autors
Einige Mängel gehen auf Entscheidungen zurück, die im [[log]] vom 22.10.2026 festgehalten sind. Eine strenge Begutachtung zählt sie trotzdem; die Behebung unten respektiert sie, wo das geht.
- **Erfolgsschwelle offen gelassen** (Empfehlung damals: 10 m als Hauptschwelle, 5/25/50 m ergänzend) → #1.
- **Regionen nicht festgelegt**, nur „beispielsweise Alpenvorland und Hochgebirge“ → #5.
- **Keine Quelle zur Kalibrierung** im Exposé; Guo et al. 2017 blieb ein Vorschlag → #9.
- **Hinweis auf Bodenauflösungen gestrichen**, weil er verwirrend war; Maßstab ist nur implizit Teil der Pose ([[author-decision-generalisation-axes]]) → #2.
- **Design Science Research** als Rahmen ([[author-decision-framework-scope]]) → #13.

## Schwere Mängel
| # | Mangel | Warum | Behebung | Status |
|---|---|---|---|---|
| 1 | **Kein Erfolgskriterium** | S. 3: „Positionsfehler unterhalb einer noch festzulegenden Schwelle“. Ohne Schwelle lassen sich weder die Forschungsfrage („wie zuverlässig“) noch FF2 („verbessert“) entscheiden. | Radius festlegen; die Fehler sind zweigipflig (korrekt 0,9–5,2 m, falsch 63,5 km, [[real-e2e-test]]), daher ist die genaue Wahl unkritisch. Primäre Zielgröße festlegen, z. B. eine Risiko-Abdeckungs-Kurve (Trefferquote unter beantworteten Bildern gegen Anteil beantworteter Bilder), dazu ECE oder Brier-Score. Gepaarter Test für den Vergleich (McNemar oder Bootstrap). | Plan: [[expose-revision]] |
| 2 | **Maßstab „unbekannt“, aber nie variiert** | Alle Testbilder sind DOP20 mit 0,2 m; zufällig sind nur Lage und Drehung (S. 3), und FF1 legt 0,2 m sogar fest. Ein Verfahren, das immer 0,2 m ausgibt, hätte einen perfekten Maßstabsfehler. Das ist kein Vergleich von Bodenauflösungen, sondern die Prüfung der Maßstabsschätzung, die die Problemstellung verspricht. | Testbilder zufällig in einem Band skalieren (z. B. 0,20–0,35 m) oder den Maßstab aus der Problemstellung streichen. | Plan: [[expose-revision]] |
| 2b | **„Nadir-Luftbilder“, getestet auf Orthofotos** | Orthofotos sind auf das Gelände entzerrt und stammen vom selben Sensor wie die Trainingsdaten; Drohnenbilder sind zentralperspektivisch. Gebäude kippen in den DOP weiterhin, es sind keine True-Orthofotos (unsourced). Titel und Relevanz (GNSS-Ausfall, Rettung) versprechen mehr als das Design prüft. | Orthofotos ausdrücklich als Stellvertreter und Einschränkung benennen, oder die Relevanz stärker auf die nachträgliche Verortung von Luftbildern stellen. | Plan: [[expose-revision]] |
| 3 | **Klassenauswahl passt nicht zur eigenen Abdeckung** | S. 1 nennt 34 % „mit Gebäuden und Kreuzungen“. Kreuzungen sind nur Erweiterung, tragen aber die Zahl: Kreuzungen ≥ 3 erreichen 31,6 %, Gebäude ≥ 8 nur 16,2 % ([[localization-levers-test]]). DOTA hat keine Gebäudeklasse und keine Kreuzungen ([[aerial-cv-benchmarks]]). Rund 75 % der OSM-Gebäude sind nur `building=yes` ([[settlement-overpass-labels]]). | Gebäude als eigenen Methodenschritt (Segmentierung plus Grundfläche und Ausrichtung). Abdeckung für genau die geplanten Klassen angeben. | Plan: [[expose-revision]] |
| 4 | **Testdesign reicht für FF2 nicht** | Gleichverteilte Testbilder im Hochgebirge: von etwa 100 Bildern haben vielleicht 10–20 genug Objekte (eigene Schätzung aus [[localization-levers-test]]). ±10 Prozentpunkte gelten für einen einzelnen Anteil bei p = 0,5 ([[feasibility]]), nicht für einen gepaarten Vergleich oder ein Diagramm mit zehn Klassen. „je Bedingung“ ist nicht definiert. | Geschichtete Stichprobe nach kartierten Objekten im Ausschnitt (0 / 1–3 / 4–7 / ≥ 8) plus gleichverteilte Stichprobe. **Negativbilder** mit wahrer Lage außerhalb des Suchgebiets: nur sie prüfen die Enthaltung ehrlich. | Plan: [[expose-revision]] |
| 5 | **Übertragbarkeit aus einem Regionenpaar** | Untertitel „Generalisierungsstudie über Regionen“, geplant sind ein Paar und eine Richtung; die Regionen bleiben bewusst offen (S. 2). Dichtes Alpenvorland → dünnes Hochgebirge vermischt schlechte Generalisierung mit weniger Objekten. | Mindestens die Auswahlkriterien nennen (räumlich getrennt, deutlich andere Objektdichte, gleiche Befliegung). Ergebnisse nach Objektdichte schichten, möglichst beide Richtungen testen. Untertitel zurückhaltender formulieren. Arbeitskandidaten im Wiki: Miesbach → Garmisch-Partenkirchen ([[settlement-test]]). | Plan: [[expose-revision]] |
| 6 | **Nullhypothese und Suchraum unsauber** | Das Maximum eines Likelihood-Quotienten über Millionen Hypothesen ist auch unter H0 groß (Mehrfachtest); ohne kalibrierte Nullverteilung ist es nur ein Schwellwert (unsourced). Der Suchraum fehlt: grob 1.000 km² × 10 m × 360 Drehschritte × 10 Maßstäbe ≈ 3,6·10¹⁰ Hypothesen (eigene Rechnung). Ein bekanntes Suchgebiet ist Vorwissen. | Nullverteilung über Negativbilder oder permutierte Erkennungen kalibrieren. Kandidatenerzeugung (RANSAC-Hypothesen, dann Likelihood, [[ransac]]) oder Grob-zu-fein-Suche ([[coarse-to-fine-localization]]) in die Methode. Größe des Suchgebiets nennen. | Plan: [[expose-revision]] |
| 7 | **Fehlermodell vermischt Detektor- und Kartenfehler** | FF1 wird gegen OSM-Labels gemessen: nicht kartierte reale Objekte zählen als Fehlalarm, veraltete OSM-Objekte als übersehen ([[real-e2e-test]], [[osm-weak-labels]]). Die OSM-Vollständigkeit schwankt zwischen Regionen. Poisson-Fehlalarme sind unabhängig; die Vorprüfung zeigte gehäufte (Tanklager, [[real-e2e-test]]). | Manuell geprüfte Testteilmenge für FF1; Kartenfehler zumindest als Validitätsrisiko benennen. Geprüft am 22.10.2026: Die landesweiten DOP20 stehen nicht im OSM Editor Layer Index (nur Münchner Stadtluftbilder), ein gemeinsamer Bildursprung von OSM und Testbildern ist daher unwahrscheinlich (unsourced). | Plan: [[expose-revision]] |
| 8 | **Schwache Vergleichsmethode** | Verglichen wird nur mit dem Zählen übereinstimmender Objekte, dessen Scheitern Abschnitt 1 schon zeigt. | Klassen-Diversitätsregel aus [[localization-levers-test]] als stärkere Heuristik; Ablation ohne Term für übersehene Objekte (testet die Hypothese aus [[thesis-contribution]] direkt). Begründen, warum Bildabgleich gegen DOP keine sinnvolle Vergleichsmethode ist (Anfrage und Referenz aus derselben Quelle). | Plan: [[expose-revision]] |

## Mittlere Mängel
- **Lücke nur als Kombination (#9).** „Nicht gefunden wurde ihre Kombination“ ist die schwächste Form einer Lücke ([[author-note-novelty]]).
  - Sagen, was man aus der Kombination lernt; die Hypothese zum Term für übersehene Objekte schon in Abschnitt 3 aufstellen ([[thesis-contribution]]).
  - Schärfer abgrenzen von Ouyang 2024 und Yuan 2025 (SWA-PF): Einzelbild, keine Anfangspose, globale Suche, Fehlermodell, Enthaltung. Deren Volltexte sind im Wiki noch nicht gelesen ([[author-literature-list]]).
  - Costea & Leordeanu setzen eine bekannte Ausrichtung (Kompass) und 1 m/px voraus ([[costea-2016-aerial-geolocalization]]); genau das unterscheidet sie von „ohne Blickrichtung“, steht aber nicht im Text.
  - **Fehlende Literatur:** Random-Finite-Set-Tracking und RFS-SLAM als Standard-Messmodell mit Erkennungswahrscheinlichkeit und Poisson-Fehlalarmen (Mahler 2003; Mullane et al. 2011); Kalibrierung und selektive Vorhersage (Guo et al. 2017; Geifman & El-Yaniv 2017; im Exposé bewusst weggelassen, s. o.); räumliche Kreuzvalidierung (Roberts et al. 2017; Ploton et al. 2020); OSM-Vollständigkeit (Hecht et al. 2013) und Training mit ungenauen OSM-Labels ([[maggiori-osm-imperfect-labels]]). Bibliografisch geprüft in `expose/ergaenzungen.bib`; Inhalte vor dem Zitieren lesen.
- **Vorprüfung ohne Stichprobengrößen (#10).** Je ein Halbsatz mit n und Auswahl:
  - Abdeckungszahlen aus 2.000 Zufallsausschnitten in Garmisch-Partenkirchen, nicht vom „Alpenrand“ allgemein ([[localization-levers-test]]).
  - Precision 0,49 / Recall 0,62 von 40 Standorten *neben* OSM-Objekten, also optimistisch ausgewählt ([[real-e2e-test]]).
  - Die falsche Position mit hoher Sicherheit war ein Fall unter vier sicheren Ergebnissen; „bei regelmäßigen Objektanordnungen“ verallgemeinert aus n = 1 ([[real-e2e-test]]).
- **Erwartetes Ergebnis ohne Methode (#11).** Für „Empfehlungen zu nötigen Kartenmerkmalen“ (S. 2) gibt es keinen Schritt in Abschnitt 4. Ablation mit je einer weggelassenen Klasse planen oder streichen.
- **Wechselnde Begriffe (#12).** Geolokalisierung / Verortung / Lokalisierung; Trefferrate (Detektor) / Trefferquote / Erfolgsquote (Verortung); Lagefehler / Positionsfehler. „Trefferquote“ in FF2 ist mehrdeutig. Jeden Begriff einmal definieren.
- **Design Science Research dekorativ (#13).** „Zieldefinition (FF1, FF2)“ vermischt Forschungsfragen mit Lösungszielen ([[author-decision-framework-scope]]). Der Upload-Prototyp trägt nichts zur Forschungsfrage bei; als praktisches Ergebnis in Ordnung, aber minimal halten.

## Form und Sprache
- **Doppelte Zitate (#14, erledigt im Entwurf; siehe [[expose-revision]]):** „Costea und Leordeanu verorten … (Costea & Leordeanu, 2016)“, ebenso Castleberry/Martin und „Peffers et al. (Peffers et al., 2007)“.
- **Preprints statt Verlagsfassungen (#15, erledigt in `expose/literatur.bib`, `expose/kandidaten.bib`, `expose/ergaenzungen.bib`):** Costea 2016 ist auf der BMVC 2016 erschienen ([[costea-2016-aerial-geolocalization]]), OrienterNet auf der CVPR 2023 ([[author-note-novelty]]); die Tagungsbände zitieren. Bei Hevner 2004 fehlt als einzigem Werk die DOI. arXiv-Links uneinheitlich (arxiv.org/abs bei Hu 2024 und Zheng 2026, sonst doi.org). Die Lücke stützt sich auf fünf Preprints (Wei 2022, Hu 2024, Yuan 2025, Trukhina 2026, Zheng 2026; [[author-literature-list]]).
- **Titel (#16):** Der Kurs verlangt einen für Laien verständlichen Titel, möglichst einzeilig ([[wa-course-expose]]). „Kalibrierte probabilistische … Nadir-…“ ist beides nicht; Fachbegriffe aus dem Haupttitel nehmen. „Generalisierungsstudie über Regionen“ ist holpriges Deutsch.
- **„den schwierigsten Fall“ (#17, S. 1)** ist überzogen, denn Schrägaufnahmen sind ausgeschlossen (erledigt im Entwurf).
- **Dual Use (#18):** Ein Halbsatz („zivile Anwendungen“) ist zu wenig; zwei bis drei Sätze ([[gnss-denied-use-cases]]). Lizenzen (ODbL, CC BY 4.0) korrekt genannt ([[bayern-dop20rgb-detail]]).
- **Kein Zeit- und Risikoplan (#19):** Vom Kurs nicht verlangt ([[wa-course-expose]]). Für ≥ 6 Monate berufsbegleitend ([[hok-aspo-2026]]) ist der Umfang knapp: Feintuning für fünf und mehr Klassen, Gebäudesegmentierung, Likelihood, Kalibrierung, zwei Regionen, Prototyp. Nennen, was bei Zeitmangel wegfällt (Strommasten, Kreuzungen, Prototyp).

## Abgleich mit dem Peer Review
Ein Mitstudierender hat denselben Entwurf begutachtet ([[peer-review-expose]]). Er hält Vorgehen und Forschungsfragen für schlüssig, deckt sich aber in drei Punkten mit dieser Bewertung:
- A2 (warum nur OSM, keine Orthofotos) ↔ #8.
- A4/A5 (Hauptziel Drohnen? warum Nadir?) ↔ #2b.
- A6 (Objekte in Siedlungen, Region am Alpenrand) ↔ #3 und #10.

Neu sind Lesbarkeit (A1), Zitatdichte (A3), die fehlende Begründung für Nadir und „ohne Metadaten“ (A5) und der Stileindruck (A7). Umsetzung in [[expose-revision]].

## Reihenfolge
- **Bis zur Abgabe (23.10.2026):** #1, #2, #10, #14, #15 und die Auswahlkriterien der Regionen aus #5. Meist ein bis zwei Sätze pro Punkt.
- **Bis zur Anmeldung (31.10.2026):** #3, #4, #6, #7 und die RFS-Literatur aus #9. Sie verändern das Methodenkapitel.

Die Spalte *Status* aktualisieren, wenn eine überarbeitete Fassung vorliegt. Entscheidungen, Zahlen und Belege je Mangel stehen in [[expose-revision]].

## Related
- [[expose-revision]]
- [[peer-review-expose]]
- [[expose-guide]]
- [[expose-material]]
- [[thesis-contribution]]
- [[localization-levers-test]]
- [[real-e2e-test]]
- [[feasibility]]
- [[author-decision-title]]
- [[author-literature-list]]
