// KI-ROHFASSUNG zum Exposé — Absatzplan mit Belegen. NICHT ABGABEFÄHIG.
// Zweck laut Kurs "Wissenschaftliches Arbeiten": Ausgangspunkte für den eigenen Text, keine fertigen Texte.
// Arbeitsweise: pro Abschnitt die Absätze in eigenen Worten in expose/expose.typ schreiben; Belege übernehmen,
// Quellen mit Status ◐ vorher selbst lesen. Diese Datei in der KI-Dokumentation angeben.
// Kompilieren:  typst compile expose/expose-rohfassung.typ

#set document(title: "KI-Rohfassung: Absatzplan zum Exposé", author: ())
#set page(paper: "a4", margin: 2.2cm, numbering: "1",
  header: align(right, text(size: 8pt, fill: rgb("#b00020"))[KI-Rohfassung · Absatzplan · nicht abgabefähig]))
#set text(lang: "de", region: "AT", size: 10pt)
#set par(justify: false, leading: 0.6em)
#set heading(numbering: "1.")

// Status der Belege
#let belegt = text(fill: rgb("#1b7f3b"))[✔ belegt]        // Aussage aus Volltext oder geprüftem Abstract
#let titel = text(fill: rgb("#a66300"))[◐ nur Titel]      // Inhalt nur aus dem Titel erschlossen → selbst lesen
#let vorpruef = text(fill: rgb("#1f5fa8"))[◆ eigene Vorprüfung (KI-gestützt)] // im Exposé als solche kennzeichnen
#let offen = text(fill: rgb("#b00020"))[✎ deine Entscheidung]

#let absatz(nr, aussage, belege, status) = block(
  width: 100%, inset: (left: 8pt, y: 5pt), stroke: (left: 2pt + rgb("#c8c8c8")), below: 0.7em,
)[
  *Absatz #nr:* #aussage
  \ #text(size: 9pt)[Belege: #belege #h(0.6em) #status]
]

#let ziel(body) = block(fill: rgb("#f2f2f2"), inset: 7pt, radius: 3pt, width: 100%, text(size: 9.5pt)[*Funktion des Abschnitts:* #body])

#align(center)[
  #text(size: 9pt, upper[KI-Rohfassung zum Exposé]) \
  #text(size: 14pt, weight: "bold")[Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen] \
  #text(size: 11pt)[Eine Generalisierungsstudie über Regionen]
]
#block(fill: rgb("#fde8ea"), inset: 8pt, radius: 3pt, width: 100%, text(size: 9pt)[
  *Wie diese Datei zu verwenden ist.* Jeder Block ist ein geplanter Absatz: Kernaussage + Belege + Status.
  Die Formulierung im Exposé ist deine Eigenleistung (Kursvorgabe: KI-Anteil ≤ 50 %, HOK-Leitlinie: keine vollständig
  KI-erstellten Texte). Status-Legende: #belegt · #titel · #vorpruef · #offen.
  Zielumfang des Exposés: ca. 3–5 Seiten; Gewichtung grob 20 % Problem, 15 % Relevanz, 25 % Ziele, 30 % Methoden, Rest Literatur.
])

= Ausgangssituation und Problemstellung

#ziel[Vom allgemeinen Kontext (GNSS-Abhängigkeit) zum konkreten Problem (Foto ohne Metadaten) und zum Problembereich (merkmalsarme alpine Regionen) führen. Am Ende muss klar sein, *was genau* fehlt.]

#absatz(1)[Ausgangslage: Luftfahrzeuge und Drohnen verorten sich standardmäßig über GNSS; fällt das Signal aus oder wird gestört, wird visuelle Lokalisierung gegen georeferenzierte Karten- oder Bilddaten zur Alternative (Begriffe: *Visual Terrain-Relative Navigation*, *Absolute Visual Localization*).][@couturier2021review; @jarraya2025gnss; @conte2009vision][#belegt]

#absatz(2)[Etablierter Ansatz: Bild-zu-Bild-Abgleich der Aufnahme mit Orthofotos/Satellitenbildern; funktioniert mit Fehlern im Meter- bis Zehnmeterbereich (z. B. < 8 m bei 200 m Flughöhe; < 50 m nach ca. 2 km Flug im Partikelfilter), ist aber von Erscheinungsbild und Jahreszeit abhängig.][@goforth2019gps; @kinnari2021orthophotos; @kinnari2022season; @kinnari2023lsvl][#belegt (Zahlen aus Abstracts)]

#absatz(3)[Alternative Referenz: offene Kartendaten (OpenStreetMap) statt Bilder — robust gegenüber Saison, global verfügbar. Bisherige Arbeiten: Kreuzungs-Fingerabdrücke gegen OSM aus Luftbildern (ca. 90 % der Kreuzungen auf 2,5 m bei 1 m/px), OSM-Abgleich bodennaher Kamerabilder mit Sub-Meter-Genauigkeit, OSM-Landmarken für Bodenroboter über Szenengraphen, Gebäudeumrisse aus Vektorkarten mit Partikelfilter.][@costea2016; @sarlin2023orienternet; @kunz2021osm; @ouyang2024vectormap; ergänzend @schleiss2019translating; @wei2022gis][#belegt (Costea Volltext; übrige Abstract) · Schleiss/Wei #titel]

#absatz(4)[Problem: Gegeben ist nur ein senkrecht aufgenommenes Luftbild *ohne Metadaten* (keine Position, Höhe, Blickrichtung, Kameradaten). Position, Maßstab und Ausrichtung müssen allein aus dem Bildinhalt bestimmt werden; dazu müssen zuerst Objekte erkannt und klassifiziert werden, die auch in OSM verzeichnet sind (z. B. Schwimmbecken, Sportplätze, Tanks, Masten, Gebäude).][—][#offen: Objektklassen festlegen]

#absatz(5)[Problembereich: In ländlichen und alpinen Gebieten sind solche Objekte selten. Die Literatur nennt Gebiete ohne klare semantische Merkmale, besonders in geringer Flughöhe, als offenes Problem; Genauigkeit hängt von der Struktur des Geländes ab.][@jarraya2025gnss; @conte2009vision; ergänzend @zheng2026seqloc][#belegt · SeqLoc #titel]

#absatz(6)[Eigene Vorprüfung als Beleg der Problemschärfe (kennzeichnen!): Im Alpenrand-Untersuchungsraum enthalten nur 0,1–1,6 % zufälliger Bildausschnitte (500 × 375 m) genügend punktförmige OSM-Objekte; mit Gebäuden und Kreuzungen 34 %, mit Linienmerkmalen 78 %; 22 % enthalten gar kein kartiertes Merkmal. Ein vortrainierter Detektor erreicht ohne Anpassung Precision 0,49 / Recall 0,62.][Wiki: localization-levers-test, real-e2e-test][#vorpruef]

= Relevanz

#ziel[Zwei getrennte Begründungen: theoretisch (Wissenslücke) und praktisch (Problem in der Anwendung). Der Leser soll den Mehrwert verstehen.]

#absatz(1)[Praktische Relevanz: GNSS-unabhängige Lokalisierung ist ein aktives Forschungsfeld mit Übersichtsarbeiten und Anwendungen (Signalausfall/-störung, Abschattung im Gebirge, Rettungseinsätze, nachträgliche Verortung von Luftbildern, Pflege offener Kartendaten).][@couturier2021review; @jarraya2025gnss; @hehelskyi2025methods][#belegt · Hehelskyi #titel]

#absatz(2)[Praktischer Vorteil der Kartenreferenz: OSM ist frei, global und saisonunabhängig; bildbasierte Verfahren gelten als anfällig für Jahreszeiten und Beleuchtung.][@kinnari2022season; @kinnari2023lsvl][#belegt]

#absatz(3)[Theoretische Lücke, Teil 1: Kartenbasierte Verfahren sind überwiegend bodennah und urban erprobt oder nur synthetisch evaluiert; ein semantischer Kartenansatz für Drohnen weist ausdrücklich darauf hin, dass die Validierung mit realen Flügen fehlt.][@sarlin2023orienternet; @kunz2021osm; @sasgeo2026; @terlizzi2026geometric][#belegt (SASGeo-Aussage geprüft) · Terlizzi #titel]

#absatz(4)[Theoretische Lücke, Teil 2: Die einzelnen Bausteine existieren — Objekt-zu-OSM-Abgleich, Graphabgleich, Partikelfilter auf Vektorkarten, Ablehnung mehrdeutiger Lösungen —, aber nicht ihre Kombination: in Nadir-Bildern erkannte Objektklassen, ein explizites Fehlermodell des Detektors in einer Wahrscheinlichkeitsfunktion, eine kalibrierte Positionsverteilung mit Nullhypothese und eine räumlich getrennte Prüfung über Regionen auf echten Daten.][@kunz2021osm; @ouyang2024vectormap; @yuan2025swapf; @sasgeo2026][#belegt (Kunz, Ouyang, SASGeo) · SWA-PF #titel → *Abgrenzung im Volltext prüfen*]

#absatz(5)[Mehrwert in einem Satz: eine Aussage nicht nur *wo* das Bild liegt, sondern *wie sicher* — und eine begründete Enthaltung, wenn das Bild nicht verortbar ist.][—][#offen: deine Formulierung]

= Zielsetzung und Ergebnisse

#ziel[Wissenschaftliche Ziele, praktische Ziele, erwartete Ergebnisse, abgeleitete Forschungsfrage(n). Genauere Ziele vereinfachen die Durchführung.]

#absatz(1)[Wissenschaftliches Ziel 1 (Erkennung): Erkennungs- und Klassifikationsgüte ausgewählter OSM-Objektklassen in Nadir-Luftbildern messen und als Fehlermodell (Trefferrate je Klasse, Fehlalarmrate, Verwechslungen, Lageungenauigkeit) beschreiben.][—][#offen: Klassen, Labelquelle (OSM / amtlich)]

#absatz(2)[Wissenschaftliches Ziel 2 (Verortung): ein probabilistisches Verortungsverfahren entwickeln, das erkannte Objekte mit OSM abgleicht und eine kalibrierte Positionsverteilung samt Nullhypothese („nicht verortbar“) liefert.][Wiki: thesis-contribution][#offen: Methode als Ziel formulieren]

#absatz(3)[Wissenschaftliches Ziel 3 (Generalisierung): prüfen, wie gut Erkennung, Verortung und Kalibrierung auf eine andere Region übertragbar sind (z. B. Alpenvorland → Hochgebirge), räumlich getrennt.][—][#offen: Regionen benennen]

#absatz(4)[Praktisches Ziel: Prototyp, in den ein Luftbild hochgeladen wird; Ausgabe: erkannte Objekte, Positionsverteilung, Konfidenz bzw. Enthaltung.][—][#offen]

#absatz(5)[Erwartete Ergebnisse: Kennzahlen je Objektklasse; Erfolgsquote und Positionsfehler je Region; Kalibrierungsgüte (Zuverlässigkeitsdiagramm); Enthaltungsrate als Maß für die Grenzen der Methode; Empfehlungen, welche Kartenmerkmale nötig sind.][—][#offen]

#absatz(6)[Forschungsfrage(n) — Struktur, Formulierung durch dich: *Hauptfrage* (wie zuverlässig und wie gut kalibriert lässt sich … verorten?) · *FF1 Erkennung* · *FF2 Verortung/Kalibrierung* · *FF3 Generalisierung über Regionen*. Mit der Betreuung fixieren.][Wiki: thesis-timeline, expose-material][#offen]

= Vorgehensweise und Methoden

#ziel[Theoretisches Rahmenwerk → Ablauf (Schritte) → Methode je Schritt. Jeder Schritt dient einer Forschungsfrage.]

#absatz(1)[Rahmen: Terrain-Relative Navigation als Problemrahmen; methodisch ein gestaltungsorientiertes Vorgehen (Artefakt bauen, quantitativ evaluieren).][@couturier2021review; @castleberry2021vtrn; @michaelson2024trn][#belegt (Review) · Castleberry/Michaelson #titel · Rahmenwerk #offen]

#absatz(2)[Daten: Objekte aus OpenStreetMap über die Overpass-API (Abrufdatum fixieren); amtliche Orthofotos DOP20 (0,2 m) des Untersuchungsraums; daraus metadatenfreie Testausschnitte mit zufälliger Lage und Drehung; realistischer Bodenauflösungsbereich angeben (z. B. 0,1–0,3 m).][Daten-/Lizenzangaben in kandidaten.bib (DOP20, OSM)][#offen: Datensätze nach literatur.bib übernehmen]

#absatz(3)[Schritt Erkennung (FF1): vortrainierter Detektor mit gedrehten Rahmen als Ausgangsbasis, Feinabstimmung mit OSM-abgeleiteten Labels; Evaluation je Klasse; daraus Fehlermodell.][Detektor/DOTA in kandidaten.bib][#offen]

#absatz(4)[Schritt Verortung (FF2): Positionshypothesen (Ort, Drehung, Maßstab) bewerten mit einer Wahrscheinlichkeitsfunktion, die erkannte, nicht erkannte und nicht erklärbare Objekte über das Fehlermodell berücksichtigt; Vergleich gegen Nullhypothese; Ergebnis als Positionsverteilung. Verwandte Verfahren: Partikelfilter auf semantischen bzw. Vektorkarten.][@ouyang2024vectormap; @yuan2025swapf; @jurevicius2019pf][#belegt (Ouyang) · SWA-PF/Jurevičius #titel]

#absatz(5)[Schritt Kalibrierung: Abgleich vorhergesagter Sicherheit mit beobachteter Trefferquote (z. B. Zuverlässigkeitsdiagramm); Schwelle für Enthaltung festlegen.][—][#offen: Kalibrierungsmaß wählen; Literatur dazu fehlt noch]

#absatz(6)[Schritt Evaluation (FF3): räumlich getrennte Trainings-/Testgebiete, Übertragung auf eine zweite Region; Metriken: Erfolgsquote (Fehler < X m), Positions-, Maßstabs-, Richtungsfehler, Kalibrierungsfehler, Enthaltungsrate; Vergleich mit einfacher Basislinie; ca. 100 Testbilder je Bedingung für ± 10 Prozentpunkte.][Wiki: feasibility; Datensatz-Kontext @xu2024uavvisloc][#offen: X m, Basislinie]

#absatz(7)[Abgrenzung: keine Schrägaufnahmen, keine Echtzeit-Navigation, kein Anbieterwechsel; Bodenauflösung keine Studienachse; zivile Nutzung; Lizenzen (DOP CC BY 4.0, OSM ODbL).][Wiki: author-decision-generalisation-axes][#belegt (eigene Entscheidungen)]

= Literatur

#ziel[Vorarbeiten zur Problemstellung, Literatur zur Relevanz, existierende Ergebnisse, Referenzen zu Methoden. Im Exposé nur Quellen, die im Text zitiert werden (`literatur-vollstaendig = false`).]

#absatz(1)[Zuordnung deiner Liste: *Übersichten* @couturier2021review @jarraya2025gnss @hehelskyi2025methods · *Bild-zu-Bild* @conte2009vision @goforth2019gps @kinnari2021orthophotos @kinnari2022season @kinnari2023lsvl @yao2024terrain @wang2026uav @ye2026dsmfree @rulko2025trn · *Karten/semantisch* @costea2016 @kunz2021osm @sarlin2023orienternet @ouyang2024vectormap @schleiss2019translating @wei2022gis @yuan2025swapf @sasgeo2026 @terlizzi2026geometric @deng2026aeromap3d @dhaouadi2025ortholoc · *TRN allgemein* @castleberry2021vtrn @michaelson2024trn @silvestrini2022iekf @lee2026landmark · *Partikelfilter* @jurevicius2019pf · *Sequenzen/merkmalsarm* @zheng2026seqloc · *Datensätze* @xu2024uavvisloc.][—][Lücken: Kalibrierung, Punktprozess-Modelle, Daten-/Software-Zitate]

#bibliography("literatur.bib", title: "Verwendete Schlüssel (aus literatur.bib)", style: "apa")
