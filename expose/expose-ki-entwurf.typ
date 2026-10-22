// KI-ENTWURF des Exposés (ausformuliert, auf Wunsch der Autorin/des Autors als Draft erstellt).
// Grundlage: eigene Literaturliste (literatur.bib), Wiki-Material, eigene Entscheidungen (Titel, Regionen, Nadir, ohne Metadaten).
// Zitate aus kandidaten.bib sind ungeprüft (im PDF mit † markiert) — vor Verwendung lesen und nach literatur.bib verschieben.
// Rote Platzhalter [Quelle fehlt] / [festlegen] vor einer Abgabe auflösen. KI-Einsatz in ki-dokumentation.typ angeben.
// Kompilieren:  typst compile expose/expose-ki-entwurf.typ

#let ki-kennzeichnung = true   // Kopfzeile "KI-Entwurf" ein/aus
#let zitierstil = "apa"

#set document(title: "Exposé zur Masterarbeit (KI-Entwurf)", author: ())
#set page(
  paper: "a4", margin: (x: 2.5cm, y: 2.5cm), numbering: "1", number-align: center,
  header: if ki-kennzeichnung { align(right, text(size: 8pt, fill: rgb("#b00020"))[KI-Entwurf · vor Verwendung überarbeiten]) },
)
#set text(lang: "de", region: "AT", size: 11pt)
#set par(justify: true, leading: 0.7em, spacing: 1.1em)
#set heading(numbering: "1.")
#show heading.where(level: 1): set block(above: 1.5em, below: 0.8em)

#let fehlt(body) = text(fill: rgb("#b00020"))[[#body]]
#let ungeprueft = super[†]

#align(center)[
  #set par(justify: false)
  #text(size: 10pt, upper[Exposé zur Masterarbeit]) \
  #v(0.3em)
  #text(size: 16pt, weight: "bold", hyphenate: false)[Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen] \
  #text(size: 12pt)[Eine Generalisierungsstudie über Regionen] \
  #v(0.2em)
  #text(size: 10pt, style: "italic")[Calibrated Probabilistic Geolocalization of Nadir Imagery with OpenStreetMap Features: A Cross-Region Generalization Study]
  #v(0.5em)
  #text(size: 10pt)[Masterstudiengang Data Science & Intelligent Analytics (berufsbegleitend) · Hochschule Kufstein Tirol]
]
#v(0.8em)

= Ausgangssituation und Problemstellung

Unbemannte Luftfahrzeuge bestimmen ihre Position in der Regel über globale Satellitennavigationssysteme (GNSS). Fällt das Signal aus, wird es gestört oder im Gebirge abgeschattet, fehlt diese Grundlage. Als Alternative hat sich die visuelle Lokalisierung gegen georeferenzierte Referenzdaten etabliert, in der Literatur als _Visual Terrain-Relative Navigation_ oder _Absolute Visual Localization_ bezeichnet @couturier2021review @jarraya2025gnss. Bereits frühe Arbeiten zeigen, dass ein Abgleich von Kamerabildern mit georeferenzierten Luftbildern lange GNSS-Ausfälle überbrücken kann, die erreichbare Genauigkeit aber von der Struktur des überflogenen Geländes abhängt @conte2009vision.

Ein verbreiteter Ansatz vergleicht die Aufnahme direkt mit Orthofotos oder Satellitenbildern. Damit werden mittlere Fehler von unter 8 m in 200 m Flughöhe @goforth2019gps bzw. unter 50 m nach rund 2 km Flugstrecke in einem Partikelfilter @kinnari2021orthophotos erreicht. Solche Bild-zu-Bild-Verfahren sind jedoch empfindlich gegenüber Jahreszeit, Vegetation und Beleuchtung, weshalb gezielt saisoninvariante Verfahren entwickelt wurden @kinnari2022season @kinnari2023lsvl.

Eine Alternative sind Kartendaten als Referenz. OpenStreetMap (OSM) ist frei verfügbar, weltweit vorhanden und beschreibt Objekte statt Erscheinungsbilder. Costea und Leordeanu verorten Luftbilder über Straßenkreuzungen, deren Nachbarschaft sie als Fingerabdruck mit OSM abgleichen, und lokalisieren so rund 90 % der Kreuzungen auf 2,5 m genau @costea2016. Weitere Arbeiten gleichen bodennahe Kamerabilder mit Sub-Meter-Genauigkeit gegen OSM ab @sarlin2023orienternet, vergleichen erkannte Objekte über einen Szenengraphen mit OSM-Landmarken für Bodenroboter @kunz2021osm oder nutzen Gebäudeumrisse aus Vektorkarten in einem Partikelfilter @ouyang2024vectormap. Daneben werden Luftbilder in kartenähnliche Darstellungen übersetzt @schleiss2019translating, GIS-Daten zur Geolokalisierung eingesetzt @wei2022gis und semantisch gewichtete Partikelfilter vorgeschlagen @yuan2025swapf.

Diese Arbeit betrachtet den schwierigsten Fall: Gegeben ist ausschließlich ein senkrecht aufgenommenes Luftbild (Nadir-Aufnahme) _ohne Metadaten_, also ohne Position, Flughöhe, Blickrichtung oder Kameradaten. Position, Maßstab und Ausrichtung müssen allein aus dem Bildinhalt bestimmt werden. Dazu müssen zunächst Objekte erkannt und klassifiziert werden, die auch in OSM verzeichnet sind, etwa Schwimmbecken, Sportplätze, Tanks, Masten und Gebäude #fehlt[Objektklassen endgültig festlegen]. Anschließend ist zu entscheiden, an welcher Stelle der Karte die erkannte Anordnung am wahrscheinlichsten liegt und ob eine Verortung überhaupt verlässlich möglich ist.

Gerade in ländlichen und alpinen Regionen ist das schwierig. Übersichtsarbeiten nennen Gebiete ohne klare semantische Merkmale, insbesondere bei geringer Flughöhe, als offenes Problem @jarraya2025gnss, und neuere Arbeiten widmen sich gezielt merkmalsarmen Szenen @zheng2026seqloc. Eine explorative Vorprüfung im Untersuchungsraum am bayerischen Alpenrand bestätigt das#footnote[KI-gestützte Machbarkeitsprüfung mit offenen Daten (DOP20, OSM); in der Masterarbeit eigenständig zu wiederholen.]: Nur 0,1–1,6 % zufällig gewählter Bildausschnitte von 500 × 375 m enthalten genügend punktförmige OSM-Objekte, mit Gebäuden und Straßenkreuzungen steigt der Anteil auf 34 %, und 22 % enthalten gar kein kartiertes Merkmal. Ein ohne Anpassung eingesetzter, vortrainierter Detektor erreichte dort eine Precision von 0,49 bei einem Recall von 0,62. Zudem zeigte sich, dass ein einfacher Abgleich über die Anzahl passender Objekte bei regelmäßig angeordneten Objekten (z. B. einem Tanklager) eine falsche Position mit hoher Sicherheit ausgeben kann. Es fehlt somit ein Verfahren, das Erkennungsfehler explizit berücksichtigt, seine Unsicherheit verlässlich angibt und sich enthält, wenn ein Bild nicht verortbar ist.

= Relevanz

*Praktische Relevanz.* GNSS-unabhängige Lokalisierung ist für Drohnen und Luftbildauswertung bedeutsam: bei Signalausfall oder -störung, bei Abschattung im Gebirge, für Such- und Rettungseinsätze, für die nachträgliche Verortung von Luftbildern und für die Pflege offener Kartendaten @couturier2021review @jarraya2025gnss @hehelskyi2025methods. Eine Kartenreferenz wie OSM ist frei verfügbar und weniger von Jahreszeit und Beleuchtung abhängig als bildbasierte Referenzen @kinnari2022season. Für einen Einsatz entscheidend ist dabei nicht nur _wo_ ein Bild liegt, sondern _wie sicher_ diese Aussage ist: Eine falsche, aber als sicher ausgegebene Position ist in der Navigation gefährlicher als eine begründete Enthaltung.

*Theoretische Relevanz.* Die Bausteine einer objektbasierten, kartengestützten Verortung existieren einzeln: der Abgleich erkannter Objekte mit OSM-Landmarken @kunz2021osm, Vektorkarten mit Partikelfiltern @ouyang2024vectormap, die Analyse, wann ununterscheidbare Landmarken eine Verortung erlauben @hu2024localizability#ungeprueft, sowie die Ablehnung mehrdeutiger Lösungen auf semantischen Karten, die bislang allerdings nur synthetisch erprobt und ausdrücklich nicht mit realen Flügen validiert ist @sasgeo2026. Kartenbasierte Verfahren wurden zudem überwiegend bodennah und in Städten untersucht @sarlin2023orienternet @terlizzi2026geometric. Nicht gefunden wurde die Kombination, die diese Arbeit untersucht: in Nadir-Luftbildern erkannte Objektklassen, ein explizites Fehlermodell des Detektors innerhalb einer Wahrscheinlichkeitsfunktion, eine kalibrierte Positionsverteilung mit Nullhypothese und eine räumlich getrennte Prüfung der Übertragbarkeit zwischen Regionen auf realen Daten.

= Zielsetzung und Ergebnisse

*Wissenschaftliche Ziele.* Erstens soll die Erkennungs- und Klassifikationsgüte ausgewählter OSM-Objektklassen in Nadir-Luftbildern gemessen und als Fehlermodell beschrieben werden, bestehend aus Trefferrate je Klasse, Fehlalarmrate, Verwechslungen zwischen Klassen und Lageungenauigkeit. Zweitens soll ein probabilistisches Verortungsverfahren entwickelt werden, das dieses Fehlermodell nutzt, eine kalibrierte Positionsverteilung liefert und gegen die Nullhypothese „nicht verortbar“ prüft. Drittens soll untersucht werden, wie gut Erkennung, Verortung und Kalibrierung von einer Region auf eine andere übertragbar sind.

*Praktisches Ziel.* Als Prototyp entsteht eine Anwendung, in die ein Luftbild hochgeladen wird und die erkannte Objekte, eine Positionsverteilung samt Unsicherheit oder eine begründete Enthaltung ausgibt.

*Erwartete Ergebnisse.* Erwartet werden Kennzahlen der Erkennung je Objektklasse, Erfolgsquoten und Positionsfehler je Region, Aussagen zur Kalibrierung der ausgegebenen Sicherheit, die Enthaltungsrate als Maß für die Grenzen der Methode sowie Empfehlungen, welche Kartenmerkmale für eine verlässliche Verortung in ländlichen und alpinen Räumen nötig sind.

*Forschungsfragen* #fehlt[Entwurf — mit der Betreuung fixieren]:

#block(inset: (left: 1em), stroke: (left: 2pt + gray))[
  *Hauptfrage:* Wie zuverlässig und wie gut kalibriert lassen sich Nadir-Luftbilder ohne Metadaten allein anhand erkannter OpenStreetMap-Objekte verorten, und wie gut lässt sich das Verfahren auf eine andere Region übertragen?

  *FF1:* Mit welcher Güte lassen sich ausgewählte OSM-Objektklassen in Nadir-Luftbildern mit 0,2 m Bodenauflösung erkennen und klassifizieren, und wie lassen sich die Fehler des Detektors als Fehlermodell beschreiben?

  *FF2:* Verbessert eine Wahrscheinlichkeitsfunktion mit explizitem Fehlermodell und Nullhypothese die Trefferquote und die Kalibrierung gegenüber einem Abgleich, der nur die Anzahl übereinstimmender Objekte zählt?

  *FF3:* Wie verändern sich Erkennungsgüte, Verortungserfolg, Kalibrierung und Enthaltungsrate beim Übertrag vom Alpenvorland (Landkreis Miesbach) ins Hochgebirge (Landkreis Garmisch-Partenkirchen)?
]

= Vorgehensweise und Methoden

*Rahmen.* Die Arbeit verortet sich in der Terrain-Relative Navigation @couturier2021review @castleberry2021vtrn und folgt einem gestaltungsorientierten Vorgehen: Ein Verfahren wird als Artefakt entwickelt und quantitativ evaluiert #fehlt[methodisches Rahmenwerk mit Quelle belegen].

*Daten.* Als Referenzkarte dienen OSM-Objekte, die über die Overpass-API abgefragt und mit Abrufdatum gesichert werden @osm2026#ungeprueft. Als Bilddaten dienen die amtlichen digitalen Orthophotos DOP20 der Bayerischen Vermessungsverwaltung mit 0,2 m Bodenauflösung (Lizenz CC BY 4.0) @ldbv2026dop20#ungeprueft. Aus ihnen werden metadatenfreie Testbilder erzeugt: Ausschnitte an zufälliger Position mit zufälliger Drehung, deren wahre Lage nur der Auswertung bekannt ist. Die Bodenauflösung wird nicht als Studienachse variiert; dem Verfahren ist der Maßstab dennoch unbekannt, es durchsucht einen Bereich von 0,1–0,3 m pro Pixel. Untersuchungsräume sind der Landkreis Miesbach (Alpenvorland) und der Landkreis Garmisch-Partenkirchen (Hochgebirge).

*Schritt 1: Erkennung (FF1).* Ausgangspunkt ist ein auf dem Luftbild-Datensatz DOTA @xia2018dota#ungeprueft vortrainierter Detektor mit gedrehten Begrenzungsrahmen @ultralytics2024yolo11#ungeprueft. Er wird mit aus OSM abgeleiteten Labels feinabgestimmt; ungenaue Kartenlabels werden dabei bewusst als verrauschte Trainingsdaten behandelt @maggiori2017osm#ungeprueft. Die Evaluation je Klasse liefert das Fehlermodell: Trefferrate, Fehlalarmrate, Verwechslungsmatrix und Lagefehler.

*Schritt 2: Verortung (FF2).* Für eine Positionshypothese aus Ort, Drehung und Maßstab werden die OSM-Objekte des betreffenden Kartenausschnitts in das Bild projiziert. Die Wahrscheinlichkeit der Hypothese setzt sich aus drei Teilen zusammen: übereinstimmenden Erkennungen (bewertet mit Trefferrate, Verwechslungswahrscheinlichkeit und Lagefehler), Kartenobjekten ohne Erkennung (bewertet mit der Wahrscheinlichkeit, übersehen zu werden) und Erkennungen ohne Kartenobjekt (modelliert als Fehlalarme eines Poisson-Punktprozesses). Über ein Raster von Hypothesen entsteht eine Positionsverteilung, die gegen die Nullhypothese „alle Erkennungen sind Fehlalarme“ geprüft wird. Gerade der Term für übersehene Kartenobjekte soll Fehlzuordnungen bei regelmäßigen Objektanordnungen verhindern. Als Vergleich dient ein robuster Abgleich, der nur übereinstimmende Objekte zählt @fischler1981ransac#ungeprueft.

*Schritt 3: Kalibrierung.* Die ausgegebene Sicherheit wird mit der beobachteten Trefferquote verglichen, etwa über Zuverlässigkeitsdiagramme #fehlt[Quelle zur Kalibrierung ergänzen]. Daraus wird eine Schwelle abgeleitet, unterhalb derer sich das Verfahren enthält.

*Schritt 4: Evaluation und Generalisierung (FF3).* Trainings-, Abstimmungs- und Testgebiete werden räumlich getrennt (z. B. in Blöcken von 2 km), um Überschätzung durch räumliche Nähe zu vermeiden. Abgestimmt wird in Miesbach, getestet in Garmisch-Partenkirchen. Gemessen werden die Erfolgsquote (Positionsfehler unter #fehlt[X] m), Positions-, Maßstabs- und Richtungsfehler, Kalibrierungsfehler und Enthaltungsrate. Etwa 100 Testbilder je Bedingung ergeben Konfidenzintervalle von rund ± 10 Prozentpunkten.

*Schritt 5: Prototyp.* Das Verfahren wird in eine Upload-Anwendung integriert, die Erkennungen, Positionsverteilung und Enthaltungen darstellt.

*Abgrenzung.* Nicht Gegenstand der Arbeit sind Schrägaufnahmen, Echtzeit-Navigation, ein Wechsel des Bildanbieters und die Bodenauflösung als Studienachse. Die Arbeit ist auf zivile Anwendungen ausgerichtet.

// Literatur: eigene Liste + (†) ungeprüfte Kandidaten; nur zitierte Quellen erscheinen.
#bibliography(("literatur.bib", "kandidaten.bib"), title: "Literatur", style: zitierstil)

#v(0.5em)
#text(size: 8.5pt)[† Quelle aus `kandidaten.bib`: noch nicht selbst geprüft.]
