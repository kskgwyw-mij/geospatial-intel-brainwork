// KI-ENTWURF des Exposés (ausformuliert, auf Wunsch als Draft erstellt; gekürzt auf 4 Seiten).
// Grundlage: eigene Literaturliste (literatur.bib), Wiki-Material, eigene Entscheidungen (Titel, Regionen, Nadir, ohne Metadaten).
// Zitate aus kandidaten.bib sind ungeprüft (†) — vor Verwendung lesen und nach literatur.bib verschieben.
// Rote Platzhalter vor einer Abgabe auflösen. Der KI-Einsatz ist in ki-dokumentation.typ offengelegt.
// Kompilieren:  typst compile expose/expose-ki-entwurf.typ

#let ki-kennzeichnung = false  // Kopfzeile "KI-Entwurf" (Arbeitsmarkierung) ein/aus
#let zitierstil = "apa"

#set document(title: "Exposé zur Masterarbeit", author: ())
#set page(
  paper: "a4", margin: (x: 2.5cm, y: 2.5cm), numbering: "1", number-align: center,
  header: if ki-kennzeichnung { align(right, text(size: 8pt, fill: rgb("#b00020"))[KI-Entwurf · vor Verwendung überarbeiten]) },
)
#set text(lang: "de", region: "AT", size: 11pt)
#set par(justify: true, leading: 0.7em, spacing: 1.1em)
#set heading(numbering: "1.")
#show heading.where(level: 1): set block(above: 1.5em, below: 0.8em)
#show heading.where(level: 1): set text(size: 13pt)

#let fehlt(body) = text(fill: rgb("#b00020"))[[#body]]
#let ungeprueft = super[†]

#align(center)[
  #set par(justify: false)
  #text(size: 9.5pt, upper[Exposé zur Masterarbeit]) \
  #v(0.2em)
  #text(size: 15pt, weight: "bold", hyphenate: false)[Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen] \
  #text(size: 11.5pt)[Eine Generalisierungsstudie über Regionen] \
  #v(0.2em)
  #text(size: 9.5pt, style: "italic")[Calibrated Probabilistic Geolocalization of Nadir Imagery with OpenStreetMap Features: A Cross-Region Generalization Study] \
  #v(0.3em)
  #text(size: 9.5pt)[Masterstudiengang Data Science & Intelligent Analytics (berufsbegleitend) · Hochschule Kufstein Tirol]
]
#v(0.4em)

= Ausgangssituation und Problemstellung

Drohnen bestimmen ihre Position in der Regel über globale Satellitennavigationssysteme (GNSS). Fällt das Signal aus, wird es gestört oder im Gebirge abgeschattet, bietet die visuelle Lokalisierung gegen georeferenzierte Referenzdaten eine Alternative, bezeichnet als _Visual Terrain-Relative Navigation_ oder _Absolute Visual Localization_ @couturier2021review @jarraya2025gnss. Verbreitet ist der Abgleich der Aufnahme mit Orthofotos oder Satellitenbildern; erreicht werden mittlere Fehler unter 8 m in 200 m Flughöhe @goforth2019gps bzw. unter 50 m nach rund 2 km Flugstrecke @kinnari2021orthophotos. Solche Verfahren sind jedoch empfindlich gegenüber Jahreszeit und Beleuchtung, weshalb gezielt saisoninvariante Verfahren entwickelt wurden @kinnari2022season @kinnari2023lsvl, und ihre Genauigkeit hängt von der Struktur des Geländes ab @conte2009vision.

Kartendaten wie OpenStreetMap (OSM) sind eine frei verfügbare, weniger erscheinungsabhängige Referenz. Costea und Leordeanu verorten Luftbilder über Straßenkreuzungen, deren Nachbarschaft sie mit OSM abgleichen, und lokalisieren rund 90 % der Kreuzungen auf 2,5 m genau @costea2016. Andere Arbeiten gleichen bodennahe Kamerabilder mit OSM ab @sarlin2023orienternet, vergleichen erkannte Objekte über einen Szenengraphen mit OSM-Landmarken @kunz2021osm oder nutzen Gebäudeumrisse aus Vektorkarten in einem Partikelfilter @ouyang2024vectormap. Weitere Ansätze übersetzen Luftbilder in kartenähnliche Darstellungen @schleiss2019translating, setzen GIS-Daten zur Geolokalisierung ein @wei2022gis oder schlagen semantisch gewichtete Partikelfilter vor @yuan2025swapf; die Abhängigkeit der visuellen Navigation von der Flughöhe untersuchen Castleberry und Martin @castleberry2021vtrn.

Diese Arbeit betrachtet den schwierigsten Fall: ein senkrecht aufgenommenes Luftbild (Nadir-Aufnahme) _ohne Metadaten_, also ohne Position, Flughöhe, Blickrichtung oder Kameradaten. Position, Maßstab und Ausrichtung müssen allein aus dem Bildinhalt bestimmt werden. Dazu werden zunächst Objekte erkannt, die auch in OSM verzeichnet sind: Schwimmbecken, Tennis- und Fußballplätze, Laufbahnen, Lagertanks sowie Gebäude, beschrieben durch Grundfläche und Ausrichtung; Strommasten und Straßenkreuzungen sind als Erweiterung vorgesehen. Anschließend wird bestimmt, wo die erkannte Anordnung auf der Karte am wahrscheinlichsten liegt.

Wie gut das gelingt, hängt von Dichte und Art der kartierten Objekte ab, die zwischen Regionen stark variieren – von Ortschaften mit vielen Gebäuden bis zu Gebirgslagen mit kaum Objekten. Gebiete ohne klare semantische Merkmale gelten dabei als besonders schwierig @jarraya2025gnss @zheng2026seqloc. Eine explorative Vorprüfung am bayerischen Alpenrand#footnote[KI-gestützte Machbarkeitsprüfung mit offenen Daten (DOP20, OSM); in der Masterarbeit eigenständig zu wiederholen.] zeigt, dass nur 0,1–1,6 % zufälliger Bildausschnitte von 500 × 375 m genügend punktförmige OSM-Objekte enthalten, mit Gebäuden und Kreuzungen 34 %, während 22 % kein kartiertes Merkmal aufweisen. Ein unangepasster, vortrainierter Detektor erreichte Precision 0,49 und Recall 0,62, und ein Abgleich, der nur passende Objekte zählt, lieferte bei regelmäßigen Objektanordnungen eine falsche Position mit hoher Sicherheit. Es fehlt ein Verfahren, das Erkennungsfehler explizit berücksichtigt, seine Unsicherheit verlässlich angibt und sich enthält, wenn ein Bild nicht verortbar ist.

= Relevanz

*Praktisch* ist GNSS-unabhängige Lokalisierung bei Signalausfall oder -störung, bei Abschattung im Gebirge, für Rettungseinsätze, die nachträgliche Verortung von Luftbildern und die Pflege offener Kartendaten bedeutsam @couturier2021review @jarraya2025gnss. Entscheidend ist nicht nur, _wo_ ein Bild liegt, sondern _wie sicher_ diese Aussage ist: Eine falsche, aber als sicher ausgegebene Position ist gefährlicher als eine begründete Enthaltung.

*Theoretisch* existieren die Bausteine einzeln: der Abgleich erkannter Objekte mit OSM-Landmarken @kunz2021osm, Vektorkarten mit Partikelfiltern @ouyang2024vectormap, die Analyse, wann ununterscheidbare Landmarken eine Verortung erlauben @hu2024localizability#ungeprueft, und die Ablehnung mehrdeutiger Lösungen auf semantischen Karten, die bislang nur synthetisch und ausdrücklich nicht mit realen Flügen geprüft wurde @sasgeo2026. Nicht gefunden wurde ihre Kombination: in Nadir-Luftbildern erkannte Objektklassen, ein explizites Fehlermodell des Detektors in einer Wahrscheinlichkeitsfunktion, eine kalibrierte Positionsverteilung mit Nullhypothese und eine räumlich getrennte Prüfung der Übertragbarkeit zwischen Regionen auf realen Daten.

= Zielsetzung und Ergebnisse

Wissenschaftlich soll (1) die Erkennungsgüte der genannten OSM-Objektklassen in Nadir-Luftbildern gemessen und als Fehlermodell beschrieben werden (Trefferrate, Fehlalarme, Verwechslungen, Lagefehler), (2) ein probabilistisches Verortungsverfahren mit diesem Fehlermodell, kalibrierter Positionsverteilung und Nullhypothese „nicht verortbar“ entwickelt werden; beides wird in einer Region geprüft, die nicht zur Entwicklung genutzt wurde. Praktisch entsteht ein Prototyp, in den ein Luftbild hochgeladen wird und der Positionsverteilung, Unsicherheit oder Enthaltung ausgibt. Erwartete Ergebnisse sind Kennzahlen je Objektklasse, Erfolgsquoten und Fehler in der Testregion, eine Bewertung der Kalibrierung, die Enthaltungsrate als Maß für die Grenzen der Methode sowie Empfehlungen zu nötigen Kartenmerkmalen.

#block(inset: (left: 0.9em), stroke: (left: 2pt + gray))[
  *Forschungsfrage:* Wie zuverlässig und wie gut kalibriert lassen sich Nadir-Luftbilder ohne Metadaten allein anhand erkannter OpenStreetMap-Objekte in einer nicht zur Entwicklung genutzten Region verorten?
  - *FF1:* Mit welcher Güte lassen sich ausgewählte OSM-Objektklassen in Luftbildern mit 0,2 m Bodenauflösung erkennen, und wie lassen sich die Detektorfehler als Fehlermodell beschreiben?
  - *FF2:* Verbessert eine Wahrscheinlichkeitsfunktion mit Fehlermodell und Nullhypothese Trefferquote und Kalibrierung gegenüber einem Abgleich, der nur übereinstimmende Objekte zählt?
  Die Übertragbarkeit ist keine eigene Teilfrage, sondern im Evaluationsdesign verankert: entwickelt und abgestimmt wird im Landkreis Miesbach (Alpenvorland), getestet ausschließlich im Landkreis Garmisch-Partenkirchen (Hochgebirge).
]

= Vorgehensweise und Methoden

Methodischer Rahmen ist Design Science Research: Ein Verfahren wird als Artefakt entwickelt und quantitativ evaluiert @hevner2004design#ungeprueft. Der Ablauf folgt dem Prozessmodell von Peffers et al. @peffers2007dsrm#ungeprueft mit den Schritten Problemidentifikation, Zieldefinition (FF1, FF2), Entwurf und Entwicklung (Fehlermodell, Wahrscheinlichkeitsfunktion), Demonstration im Prototyp und Evaluation über Regionen.

*Daten.* Referenz sind OSM-Objekte (Lizenz ODbL) @osm2026, abgefragt über die Overpass API @olbricht_overpass mit festem Abrufdatum; Bilddaten sind die amtlichen Orthophotos DOP20 (0,2 m, CC BY 4.0) @ldbv2026dop20. Daraus entstehen metadatenfreie Testbilder mit zufälliger Lage und Drehung, deren wahre Position nur der Auswertung bekannt ist. Die Bodenauflösung ist keine Studienachse; das Verfahren kennt den Maßstab aber nicht und durchsucht 0,1–0,3 m pro Pixel.

*Erkennung (FF1).* Ein auf dem Luftbild-Datensatz DOTA @xia2018dota#ungeprueft vortrainierter Detektor mit gedrehten Rahmen wird mit aus OSM abgeleiteten Labels feinabgestimmt. Die Evaluation je Klasse liefert das Fehlermodell.

*Verortung (FF2).* Für Hypothesen aus Ort, Drehung und Maßstab werden die OSM-Objekte ins Bild projiziert. Die Wahrscheinlichkeit berücksichtigt übereinstimmende Erkennungen (Trefferrate, Verwechslung, Lagefehler), übersehene Kartenobjekte und Fehlalarme als Poisson-Punktprozess. Über ein Hypothesenraster entsteht eine Positionsverteilung, die gegen die Nullhypothese „alle Erkennungen sind Fehlalarme“ geprüft wird; der Term für übersehene Objekte soll Fehlzuordnungen bei regelmäßigen Anordnungen verhindern. Vergleichsverfahren ist ein robuster Abgleich über die Zahl übereinstimmender Objekte @fischler1981ransac#ungeprueft.

*Kalibrierung und Evaluation (FF2).* Die ausgegebene Sicherheit wird mit der beobachteten Trefferquote verglichen, etwa über Zuverlässigkeitsdiagramme, und daraus eine Enthaltungsschwelle abgeleitet. Trainings-, Abstimmungs- und Testgebiete werden räumlich getrennt; abgestimmt wird in Miesbach, getestet in Garmisch-Partenkirchen. Gemessen werden Erfolgsquote (Positionsfehler unterhalb einer noch festzulegenden Schwelle), Positions-, Maßstabs- und Richtungsfehler, Kalibrierungsfehler und Enthaltungsrate; rund 100 Testbilder je Bedingung ergeben Konfidenzintervalle von etwa ± 10 Prozentpunkten. Abschließend wird das Verfahren in den Upload-Prototyp integriert.

*Abgrenzung.* Ausgeschlossen sind Schrägaufnahmen, Echtzeit-Navigation, ein Wechsel des Bildanbieters und die Bodenauflösung als Studienachse; die Arbeit ist auf zivile Anwendungen ausgerichtet.

#set text(size: 10pt)
#set par(spacing: 0.65em)
#bibliography(("literatur.bib", "kandidaten.bib"), title: [Literatur], style: zitierstil)
#text(size: 8pt)[† noch nicht selbst geprüfte Quelle.]
