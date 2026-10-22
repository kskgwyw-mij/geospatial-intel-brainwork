---
title: Exposé-Überarbeitung — Entscheidungen, Inhalte und Belege je Mangel
type: analysis
tags: [thesis, expose, review, evaluation-design]
sources: [localization-levers-test, real-e2e-test, osm-real-test, settlement-test, settlement-overpass-labels, aerial-cv-benchmarks, costea-2016-aerial-geolocalization, author-literature-list, author-decision-generalisation-axes, author-decision-title, bayern-dop-regions-search, wa-course-expose, hok-aspo-2026, author-decision-framework-scope]
updated: 2026-10-23
---
Umsetzungsplan zu [[expose-review]]: sieben Entscheidungen mit Empfehlung, dann für jeden Mangel die Stelle im Exposé, was dort stehen muss, die fertigen Zahlen und die geprüften Belege; Bibliografie und redaktionelle Punkte sind im Entwurf auf `main` bereits korrigiert.

Die inhaltlichen Sätze formuliert der Autor selbst; hier steht, was sie enthalten müssen. Quelltext: `expose/expose-ki-entwurf.typ`; Seitenangaben beziehen sich auf das PDF vom 22.10.2026. Erledigtes wird in der Status-Spalte von [[expose-review]] abgehakt. Bewusste Entscheidungen des Autors (Schwelle und Regionen offen, keine Kalibrierungsquelle, kein Hinweis auf Bodenauflösungen) sind in [[expose-review]] aufgeführt; die Empfehlungen unten respektieren sie, wo das geht.

## Bereits erledigt
**Bibliografie (#15):**
- `expose/literatur.bib`: Costea & Leordeanu 2016 → BMVC 2016, S. 118.1–118.12, DOI 10.5244/C.30.118. OrienterNet → CVPR 2023, S. 21632–21642, DOI 10.1109/CVPR52729.2023.02072. DOI statt URL bei SeqLoc (10.48550/arXiv.2608.07835) und Hu et al. 2024 (10.48550/arXiv.2409.09525). Hevner et al. 2004 mit DOI 10.2307/25148625. Geprüft über Crossref und DataCite.
- `expose/kandidaten.bib`: YOLO11 mit Autoren Jocher & Qiu laut CITATION.cff und Versionsnummer; an die verwendete Version anpassen.
- `expose/ergaenzungen.bib` (neu): die Literatur zu #6, #7 und #9 (Mahler 2003; Mullane et al. 2011; Guo et al. 2017; Geifman & El-Yaniv 2017; Roberts et al. 2017; Ploton et al. 2020; Hecht et al. 2013). Metadaten geprüft, Inhalte nicht gelesen: vor dem Zitieren lesen. Erst einbinden, wenn eine davon im Text zitiert wird: `#bibliography(("literatur.bib", "kandidaten.bib", "ergaenzungen.bib"), …)`.

**Redaktionell im Entwurf (`expose/expose-ki-entwurf.typ`, PDF neu gebaut):**
- #14: Doppelte Zitate behoben, Name im Text plus Jahr in Klammern über `#cite(<key>, form: "year")`: „Costea und Leordeanu (2016)“, „Castleberry und Martin (2021)“, „Peffers et al. (2007)“. Die Form „prose“ würde im Text „&“ setzen.
- #17: „den schwierigsten Fall“ → „einen besonders schwierigen Fall“.
- PDF mit Typst 0.15.0 neu gebaut: weiter 4 Seiten, Literatur allein auf Seite 4, kein Autor in den Metadaten.

## Entscheidungen (Empfehlung)
| # | Entscheidung | Empfehlung | Begründung |
|---|---|---|---|
| E1 | Erfolgsradius | **< 10 m** als Hauptschwelle (so schon früher empfohlen, [[log]]), **< 50 m** ergänzend | Bewusst offen gelassen; streng bewertet muss er ins Exposé. Die Fehler sind zweigipflig: korrekte Verortungen 0,9–5,2 m, die falsche 63,5 km ([[real-e2e-test]]). Jede Schwelle zwischen etwa 10 m und einigen Kilometern trennt gleich, die Wahl ist also unkritisch; 50 m bleibt vergleichbar mit der Vorprüfung. Fehlerverteilung zusätzlich berichten. |
| E2 | Maßstab der Testbilder | **zufällig 0,20–0,35 m**, nur durch Herunterrechnen aus DOP20, log-gleichverteilt | Kein Vergleich von Bodenauflösungen (der Hinweis darauf wurde bewusst gestrichen), sondern eine Zufallsgröße wie Lage und Drehung, damit die Maßstabsschätzung überhaupt geprüft wird. Hochrechnen auf feinere Auflösung erfindet keine Details (unsourced). Ein 6-m-Becken hat bei 0,35 m noch etwa 17 px, über der Faustregel von 10–20 px ([[cv-detectability]]). GSD bleibt keine Studienachse ([[author-decision-generalisation-axes]]). |
| E3 | Regionen | Im Exposé **Auswahlkriterien statt Namen**: räumlich getrennt, deutlich andere Objektdichte, gleicher Befliegungsjahrgang. Arbeitskandidaten: Miesbach (Entwicklung) → Garmisch-Partenkirchen (Test) | Die Namen bleiben bewusst offen ([[log]]). Kriterien machen das Design trotzdem prüfbar. Die Kandidaten sind die der Vorprüfungen ([[settlement-test]]); Gegenrichtung nur, wenn Zeit bleibt. |
| E4 | Kernklassen | **Schwimmbecken, Tennis-, Fußballplätze, Laufbahnen, Lagertanks + Gebäude**; Kreuzungen und Strommasten bleiben Erweiterung | Die fünf Punktklassen sind DOTA-Klassen ([[aerial-cv-benchmarks]]); Gebäude tragen die Abdeckung. Kreuzungen in den Kern zu nehmen hebt die Abdeckung auf 34 %, kostet aber eine Straßenextraktion als dritten Modellteil ([[localization-levers-test]]). |
| E5 | Testsatz (Testregion) | Geschichtet nach kartierten Kernklassen-Objekten im Ausschnitt: **1–3 / 4–7 / ≥ 8 je 70 Bilder**, dazu **100 gleichverteilte** und **60 Negativbilder** (wahre Lage außerhalb des Suchgebiets, z. B. aus Bad Tölz-Wolfratshausen); zusammen etwa 370 | Zahlen unter #4. Die Erzeugung ist billig: etwa 8 s pro Bild inklusive WMS-Abruf ([[real-e2e-test]]). Gleiches Schema, kleiner, in der Entwicklungsregion für die Schwellenwahl. |
| E6 | Vergleichsmethoden | (a) Zählen übereinstimmender Objekte, (b) dasselbe mit Klassen-Diversitätsregel, (c) volle Likelihood, (d) Likelihood ohne Term für übersehene Objekte | Alle auf denselben Erkennungen, also gepaart. (b) ist die stärkere Heuristik aus [[localization-levers-test]]; (d) prüft die Hypothese aus [[thesis-contribution]]. |
| E7 | Suchraum | Die Testregion als bekanntes Suchgebiet (Arbeitskandidat Garmisch-Partenkirchen, etwa 1.000 km², unsourced); Pose = Position, Drehung 0–360°, Maßstab im Band E2; **Kandidatenerzeugung statt Vollraster** | Ein Vollraster hat etwa 10¹¹ Hypothesen (Rechnung unter #6). Kandidaten: Paare von Erkennungen gleicher Klasse ↔ Paare von OSM-Objekten mit passendem Abstand im Maßstabsband ergeben je eine Ähnlichkeitstransformation; die Likelihood bewertet nur diese Kandidaten und verfeinert lokal. So arbeitet schon der Prototyp ([[geo-match-prototype]], [[ransac]]). |

## Je Mangel: Stelle, Inhalt, Belege
### #1 Erfolgskriterium
- **Stelle:** Abschnitt 3 (Forschungsfrage, FF2) und Abschnitt 4 „Kalibrierung und Evaluation“; „noch festzulegenden Schwelle“ streichen.
- **Inhalt:**
  - Korrekt verortet heißt Positionsfehler < 10 m, ergänzend < 50 m (E1), mit der Begründung der zweigipfligen Fehler.
  - „Zuverlässig“ heißt: Verortungsquote unter den beantworteten Bildern und Anteil falscher sicherer Antworten bei der gewählten Enthaltungsschwelle.
  - „Kalibriert“ heißt: vorhergesagte Wahrscheinlichkeit im 50-m-Radius gegen beobachtete Trefferquote, gemessen als ECE mit 5 Klassen und Brier-Score, gezeigt im Zuverlässigkeitsdiagramm (Guo et al. 2017).
  - Primäre Zielgröße: Risiko-Abdeckungs-Kurve und die Fläche darunter (AURC) (Geifman & El-Yaniv 2017).
  - Vergleich in FF2: gepaart; McNemar-Test auf die Verortungsquote bei gleicher Abdeckung, Bootstrap-Konfidenzintervall für die AURC-Differenz.

### #2 Maßstab und #2b Orthofotos
- **Stelle:** Abschnitt 4 „Daten“, FF1 in Abschnitt 3, Abschnitt 1 (Fallbeschreibung), Abgrenzung.
- **Inhalt Maßstab:**
  - Testbilder mit zufälliger Lage, Drehung **und Bodenauflösung** im Band 0,20–0,35 m (E2).
  - FF1 nennt 0,2 m als Trainingsauflösung und das Band als Testbedingung.
  - Der Maßstabsfehler wird relativ zum wahren Maßstab gemessen.
- **Inhalt Orthofotos:**
  - Die Testbilder sind Ausschnitte amtlicher Orthofotos und dienen als Stellvertreter für senkrechte Drohnenbilder.
  - Nicht abgebildet sind Zentralperspektive, andere Sensoren und andere Aufnahmezeitpunkte. Die DOP sind auf das Geländemodell entzerrt; Gebäude kippen weiterhin, weil es keine True-Orthofotos sind (unsourced).
  - Die Übertragung auf echte Drohnenbilder bleibt offen (Abgrenzung).
  - In der Relevanz die nachträgliche Verortung von Luftbildern zuerst nennen, weil das Design sie direkt prüft.

### #3 Kernklassen und Abdeckung
- **Stelle:** Abschnitt 1, letzter Absatz (Vorprüfung); Abschnitt 4 „Erkennung (FF1)“.
- **Zahlen** (2.000 zufällige Ausschnitte 500 × 375 m, Landkreis Garmisch-Partenkirchen, [[localization-levers-test]]):
  - Punktobjekte der DOTA-Klassen (≥ 4 im Ausschnitt): 0,1 %; alle Punktobjekte inklusive Masten und Türme: 1,6 %.
  - Gebäude (≥ 8): 16,2 %. **Kernklassen zusammen (Punktobjekte ≥ 4 oder Gebäude ≥ 8): 16,2–16,3 %** (die Vereinigung liegt zwischen dem größeren Einzelwert und der Summe).
  - Mit Kreuzungen (≥ 3): 34,0 %. Kein kartiertes Merkmal: 22,2 %.
  - Die Schwellen gelten je Merkmalsart; gemischte Konstellationen (z. B. zwei Becken und fünf Gebäude) sind nicht gezählt, die Werte sind also Untergrenzen (unsourced).
- **Inhalt FF1, zwei Bausteine:**
  - Ein Detektor mit gedrehten Rahmen (YOLO11-OBB, Jocher & Qiu 2024), vortrainiert auf DOTA (Xia et al. 2018), für die fünf Punktklassen.
  - Eine Gebäudesegmentierung mit OSM-Umrissen als Labels (Modellwahl in [[methods-10-25cm]]). Merkmale je Gebäude: Fläche und Ausrichtung der Hauptachse, optional Wohn- oder Nebengebäude ([[settlement-overpass-labels]]).
  - Begründung: DOTA hat keine Gebäudeklasse ([[aerial-cv-benchmarks]]), und rund 75 % der OSM-Gebäude sind nur `building=yes` ([[settlement-overpass-labels]]); die Klasse allein unterscheidet also nichts.

### #4 Testdesign
- **Stelle:** Abschnitt 4 „Kalibrierung und Evaluation“; „rund 100 Testbilder je Bedingung … ± 10 Prozentpunkten“ ersetzen.
- **Inhalt:** Zusammensetzung nach E5, bezogen auf die Testregion. Die Negativbilder prüfen die Enthaltung; die gleichverteilte Stichprobe liefert die ehrliche Gesamtquote.
- **Zahlen** (eigene Rechnung):
  - ±10 Prozentpunkte gelten nur bei p = 0,5 und n = 100 (Wilson 40,4–59,6 %). Bei p = 0,15 und n = 100: 9,3–23,3 %.
  - Gepaarter Vergleich (McNemar, α = 0,05, simuliert): Ist die neue Methode bei 10 % der Bilder richtig und die alte falsch, umgekehrt bei 2 %, beträgt die Teststärke 0,56 bei n = 100, 0,79 bei n = 150 und 0,90 bei n = 200. Daher etwa 200 Bilder mit Objekten (3 × 70).
  - Negativbilder: Gibt es keine falsche sichere Antwort, liegt die einseitige 95-%-Obergrenze bei 4,9 % für n = 60 und bei 3,0 % für n = 100.
  - Zuverlässigkeitsdiagramm mit 5 statt 10 Klassen, sonst sind die Klassen zu dünn besetzt.

### #5 Übertragbarkeit
- **Stelle:** Abschnitt 3, letzter Absatz; Untertitel.
- **Inhalt:**
  - Statt nur „beispielsweise Alpenvorland und Hochgebirge“ die Auswahlkriterien nach E3 nennen; die Namen dürfen offen bleiben.
  - Auswertung in beiden Regionen nach denselben Dichteschichten (E5). Der Übertragungseffekt ist dann der Unterschied innerhalb derselben Schicht und nicht mit der Objektdichte vermischt.
  - Räumliche Trennung begründen mit Roberts et al. 2017 und Ploton et al. 2020.
  - Der Untertitel sollte zu einem einzigen Regionenpaar passen; die Formulierung entscheidet der Autor ([[author-decision-title]]).

### #6 Nullhypothese und Suchraum
- **Stelle:** Abschnitt 4 „Verortung (FF2)“; Abschnitt 1 („ohne Metadaten“).
- **Inhalt:**
  - Ohne Metadaten zum Bild, aber mit bekanntem Suchgebiet (die Testregion, z. B. ein Landkreis von etwa 1.000 km²); das in Abschnitt 1 so sagen.
  - Kandidatenerzeugung und lokale Verfeinerung nach E7.
  - Entscheidung gegen die Nullhypothese: Die Teststatistik ist der größte Log-Likelihood-Quotient über alle Kandidaten. Die Schwelle kommt aus der Verteilung dieser Statistik auf Negativbildern der Entwicklungsregion und wird so gewählt, dass höchstens z. B. 5 % falsche sichere Antworten entstehen. Das ist zugleich die Enthaltungsschwelle aus #1.
- **Zahlen** (eigene Rechnung): Raster 10 m über 1.000 km² → 10⁷ Positionen × 360 Drehungen × 29 Maßstabsstufen (2 % Schritt im Band E2) ≈ 10¹¹ Hypothesen; bei 1 µs je Hypothese etwa 29 h pro Bild. Der Prototyp braucht mit Kandidatenerzeugung etwa 8 s pro Bild ([[real-e2e-test]]).

### #7 Fehlermodell
- **Stelle:** Abschnitt 4 „Erkennung (FF1)“ und „Verortung (FF2)“.
- **Inhalt:**
  - FF1 zusätzlich auf einer manuell geprüften Teilmenge auswerten, z. B. 50 Ausschnitte der Testregion. Jede Erkennung wird als real-kartiert, real-unkartiert oder Fehlalarm markiert; so trennen sich Detektorfehler und OSM-Lücken ([[real-e2e-test]], [[osm-weak-labels]]).
  - In der Likelihood ausdrücklich sagen: Die Fehlalarmrate enthält unkartierte reale Objekte, der Term für übersehene Objekte enthält veraltete OSM-Objekte.
  - Die OSM-Vollständigkeit schwankt räumlich (Hecht et al. 2013) und ist damit ein Validitätsrisiko für die Übertragung.
  - Gehäufte Fehlalarme (Tanklager, [[real-e2e-test]]) als Grenze der Poisson-Annahme nennen.
- **Geprüft:** Die landesweiten DOP20 stehen nicht im OSM Editor Layer Index; dort sind für Bayern nur die Münchner Stadtluftbilder gelistet (Abruf 22.10.2026, nicht als Quelle abgelegt; unsourced). Dass OSM in den Testregionen aus genau diesen Bildern abgezeichnet wurde, ist daher unwahrscheinlich; der Satz im Exposé ist optional.

### #8 Vergleichsmethode
- **Stelle:** Abschnitt 4 „Verortung (FF2)“, letzter Satz; Abschnitt 3.
- **Inhalt:**
  - Die vier Varianten nach E6.
  - Hypothese H1 in Abschnitt 3: Der Term für übersehene Objekte senkt die falschen sicheren Antworten bei regelmäßigen Anordnungen ([[thesis-contribution]]).
  - Ein Satz, warum es keinen Bildabgleich gegen DOP gibt: Anfrage und Referenz stammen aus derselben Quelle, der Abgleich wäre trivial (unsourced).

### #9 Forschungslücke und Literatur
- **Stelle:** Abschnitt 2 „Theoretisch“, Abschnitt 1 (Costea).
- **Inhalt:**
  - Ein Messmodell mit Erkennungswahrscheinlichkeit und Poisson-Fehlalarmen ist in der Mehrzielverfolgung und im RFS-SLAM Standard (Mahler 2003; Mullane et al. 2011). Neu sind die globale Einzelbildsuche über einer Karte mit Enthaltung, je Klasse gemessene Detektorfehler und reale Daten.
  - Abgrenzung zu Ouyang et al. 2024 und Yuan et al. 2025: Partikelfilter brauchen eine Bildfolge und eine Anfangspose, diese Arbeit ein Einzelbild ohne Anfangspose. Vor dem Schreiben in den Volltexten prüfen ([[author-literature-list]]).
  - Costea & Leordeanu setzen eine bekannte Ausrichtung (Kompass) und 1 m/px voraus und testen in zwei Städten ([[costea-2016-aerial-geolocalization]]).
  - H1 aus #8 in Abschnitt 3 stellen.
  - Kalibrierung: Die Quelle wurde bewusst weggelassen. Eine Begutachtung wird aber fragen, woher Zuverlässigkeitsdiagramm und ECE kommen; ein Halbsatz mit Guo et al. 2017 genügt.

### #10 Vorprüfung mit Stichprobenangaben
- **Stelle:** Abschnitt 1, letzter Absatz.
- **Inhalt:**
  - Abdeckung: 2.000 zufällige Ausschnitte im Landkreis Garmisch-Partenkirchen ([[localization-levers-test]]), statt „am bayerischen Alpenrand“.
  - Detektor: 40 Ausschnitte neben kartierten Objekten, also optimistisch ausgewählt; 313 Erkennungen gegen 239 OSM-Objekte; Precision 0,49, Recall 0,62. Die Precision ist eine Untergrenze, weil ein Teil der Fehlalarme reale, nicht kartierte Objekte sind ([[real-e2e-test]]).
  - Falsche sichere Position: **in einem von vier** sicheren Ergebnissen; ein Tanklager mit 44 kartierten Tanks wurde 63,5 km entfernt verortet ([[real-e2e-test]]). „In einem Fall“ statt der Verallgemeinerung „bei regelmäßigen Objektanordnungen“.

### #11 Empfehlungen zu Kartenmerkmalen
- **Stelle:** Abschnitt 4 (neuer Satz) oder Abschnitt 3 (streichen).
- **Inhalt:** Ablation mit je einer weggelassenen Klasse auf dem Testsatz. Billig, weil nur die Bewertung neu läuft, nicht die Erkennung.

### #12 Begriffe
| Begriff | Bedeutung | Ersetzt |
|---|---|---|
| Verortung | Bestimmen von Position, Drehung und Maßstab eines Bildes | „Lokalisierung“, „Geolokalisierung“ im Fließtext (der Titel kann „Geolokalisierung“ behalten) |
| Precision / Recall | Güte des Detektors je Klasse | „Trefferrate“ |
| Lageabweichung | Versatz einer Erkennung gegenüber dem OSM-Objekt (Fehlermodell) | „Lagefehler“ |
| Positionsfehler | Abstand der verorteten zur wahren Bildmitte | — |
| Verortungsquote | Anteil der Bilder mit Positionsfehler unter der Schwelle aus E1 | „Erfolgsquote“, „Trefferquote“ |
| Enthaltungsrate | Anteil der Bilder ohne Antwort | — |

### #13 Design Science Research
- **Stelle:** Abschnitt 4, erster Absatz.
- **Inhalt:** Rahmen laut [[author-decision-framework-scope]]. Die Zieldefinition nennt Anforderungen an das Artefakt (Verortungsquote, Kalibrierung, Enthaltung, Laufzeit pro Bild), nicht FF1 und FF2. Den Prototyp in einem Satz halten.

### #14 Doppelte Zitate (redaktionell)
Erledigt, siehe oben.

### #16–#19 Titel, Wortwahl, Dual Use, Streichliste
- **Titel (#16):** Kriterien des Kurses: für Laien verständlich, möglichst einzeilig, etwa 8–12 Wörter ([[wa-course-expose]]). Fachbegriffe (Nadir, kalibriert, probabilistisch) in den Untertitel. Die Formulierung entscheidet der Autor ([[author-decision-title]]).
- **Wortwahl (#17, redaktionell):** erledigt, siehe oben.
- **Dual Use (#18), Inhalt für die Abgrenzung:**
  - GNSS-unabhängige Navigation ist Dual Use; ein Teil der Literatur stammt aus militärischem Umfeld (Ouyang et al. 2024 in *Defence Technology*).
  - Die Arbeit nutzt nur offene Daten (ODbL, CC BY 4.0), keine Echtzeit-Navigation, und bezieht die Ergebnisse auf zivile Szenarien ([[gnss-denied-use-cases]]).
- **Streichliste (#19):** Bei Zeitmangel in dieser Reihenfolge streichen: Strommasten, Kreuzungen, Gegenrichtung des Regionentests, Oberfläche des Prototyps. Bearbeitungszeit ≥ 6 Monate ([[hok-aspo-2026]]).

## Reihenfolge
- **Bis 23.10.2026:** E1 und E2 festlegen, Kriterien aus E3 nennen; #1, #2 und #10 einarbeiten. #14, #15 und #17 sind erledigt.
- **Bis 31.10.2026:** E4–E7; #3, #4, #6, #7, #8, #9; danach #11–#13, #16, #18.

## Related
- [[expose-review]]
- [[expose-guide]]
- [[expose-material]]
- [[thesis-contribution]]
- [[localization-levers-test]]
- [[real-e2e-test]]
- [[feasibility]]
- [[geo-match-prototype]]
