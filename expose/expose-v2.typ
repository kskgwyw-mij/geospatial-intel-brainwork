// Exposé zur Masterarbeit — Version 2: Schreibgerüst nach Bewertung und Peer Review
// Kompilieren:  typst compile expose/expose-v2.typ
// Kein Fließtext: Pro Absatz steht eine Hinweisbox mit den Punkten, Belegen und Zahlen, die hinein müssen,
// und ein grauer Platzhalter #schreiben[…]. Den Platzhalter durch eigenen Text ersetzen.
// Grundlage: wiki/analyses/expose-review.md (#1–#19), wiki/sources/peer-review-expose.md (A1–A7),
// wiki/analyses/expose-revision.md (Entscheidungen E1–E7, Zahlen, Belege).
// Anonym: Name nirgends eintragen (auch nicht in `set document`), PDF-Eigenschaften nach dem Export prüfen.

// --- Schalter ---------------------------------------------------------------
#let zeige-hinweise = true   // false: Hinweisboxen und Platzhalter verschwinden
#let zitierstil = "apa"
#let literatur-vollstaendig = false  // false: nur im Text zitierte Quellen

// --- Metadaten (ohne Namen!) -------------------------------------------------
#let arbeitstitel = [Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhand von OpenStreetMap-Objektmerkmalen]
#let untertitel = [Eine Generalisierungsstudie über Regionen]
#let titel-en = [Calibrated Probabilistic Geolocalization of Nadir Imagery with OpenStreetMap Features: A Cross-Region Generalization Study]  // none = ausblenden
#let studiengang = [Masterstudiengang Data Science & Intelligent Analytics (berufsbegleitend)]
#let hochschule = [Hochschule Kufstein Tirol]

#set document(title: "Exposé zur Masterarbeit", author: ())
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  number-align: center,
)
#set text(lang: "de", region: "AT", size: 11pt)
#set par(justify: true, leading: 0.7em, spacing: 1.4em)
#set heading(numbering: "1.")
#show heading.where(level: 1): set block(above: 2.2em, below: 1.2em)
#show heading.where(level: 1): set text(size: 13pt)

// Hinweisbox: was in den Absatz gehört; verschwindet mit zeige-hinweise = false
#let hinweis(body) = if zeige-hinweise {
  block(
    width: 100%, inset: 8pt, radius: 3pt,
    fill: rgb("#fff4d6"), stroke: rgb("#e0b84a"),
    text(size: 9pt, fill: rgb("#5a4500"))[#body],
  )
}

// Platzhalter für den eigenen Text; durch den Absatz ersetzen
#let schreiben(was) = if zeige-hinweise {
  text(fill: rgb("#8a8a8a"), style: "italic")[[Eigener Text: #was]]
}

// --- Titelblock ---------------------------------------------------------------
#align(center)[
  #set par(justify: false)
  #text(size: 9.5pt, upper[Exposé zur Masterarbeit]) \
  #v(0.2em)
  #text(size: 15pt, weight: "bold", hyphenate: false, arbeitstitel)
  #if untertitel != none [ \ #text(size: 11.5pt, untertitel) ]
  #if titel-en != none [ \ #v(0.2em) #text(size: 9.5pt, style: "italic", titel-en) ]
  #v(0.3em)
  #text(size: 9.5pt)[#studiengang · #hochschule]
]
#v(0.4em)

#hinweis[
  *Titel (\#16):* für Fachfremde verständlich, möglichst einzeilig, etwa 8–12 Wörter. Fachbegriffe (Nadir,
  kalibriert, probabilistisch) eher in den Untertitel. Der Untertitel sollte zu einem einzigen Regionenpaar passen
  (\#5). Der Titel ist deine Entscheidung (wiki: author-decision-title).
]

#hinweis[
  *Schreibregeln aus dem Feedback (A1, A3, A7, \#12, \#14):*
  - Sätze kurz halten, Richtwert unter 25 Wörtern; im Entwurf vom 22.10. lag der Median bei 24,5, der längste Satz bei 59.
  - Keine Semikolons (Entwurf: 13 auf S. 1–3), keine Gedankenstriche als Satzverbinder.
  - Pro Aussage ein bis zwei Belege; verwandte Arbeiten bündeln; bei den nächsten Nachbarn sagen, worin sie sich unterscheiden.
  - Name im Text: `Costea und Leordeanu (#cite(<costea2016>, form: "year"))`, sonst `@schluessel` am Satzende.
  - Begriffe einheitlich: _Verortung_ (Position, Drehung, Maßstab bestimmen); _Precision/Recall_ (Detektor);
    _Lageabweichung_ (Erkennung gegenüber OSM-Objekt); _Positionsfehler_ (verortete gegenüber wahrer Bildmitte);
    _Verortungsquote_ (Anteil mit Positionsfehler unter der Schwelle); _Enthaltungsrate_.
  - „einen besonders schwierigen Fall“, nicht „den schwierigsten“ (\#17).
]

#hinweis[
  *Vorher festlegen* (Empfehlungen in expose-revision.md):
  E1 Erfolgsschwelle (Empfehlung: 10 m, ergänzend 50 m) ·
  E2 Maßstab der Testbilder (Empfehlung: zufällig 0,20–0,35 m) ·
  E3 Regionen über Kriterien statt Namen ·
  E4 Kernklassen (fünf Punktklassen + Gebäude) ·
  E5 Testsatz (3 × 70 geschichtet + 100 zufällig + 60 Negativbilder) ·
  E6 Vergleichsvarianten (vier, gepaart) ·
  E7 Suchraum mit Kandidatenerzeugung.
]

= Ausgangssituation und Problemstellung

#hinweis[
  *Absatz 1 — Einstieg über die allgemeine Aufgabe (A4, \#2b).*
  - Muss rein: ein senkrechtes Luftbild ohne Positionsangaben auf der Karte verorten. Anwendungen gleichrangig nennen:
    nachträgliche Verortung von Luftbildern, Drohnen bei GNSS-Ausfall oder Abschattung, Pflege offener Kartendaten.
  - Drohnen nur als eine Anwendung, nicht als Rahmen (deine Notiz zu A5: „nur ein Anwendungsfall“).
  - Belege (höchstens zwei): `couturier2021review`, `jarraya2025gnss`.
]
#schreiben[Absatz 1: Aufgabe und Anwendungen]

#hinweis[
  *Absatz 2 — Stand der Technik: Abgleich mit Bildern (A3).*
  - Muss rein: Abgleich der Aufnahme mit Orthofotos oder Satellitenbildern ist verbreitet; Schwächen: Jahreszeit,
    Beleuchtung, Geländestruktur.
  - Zahlen: mittlerer Fehler unter 8 m in 200 m Flughöhe (`goforth2019gps`); unter 50 m nach rund 2 km
    Flugstrecke (`kinnari2021orthophotos`).
  - Weitere Belege, gebündelt: `kinnari2022season`, `kinnari2023lsvl` (saisoninvariant); `conte2009vision` (Gelände).
  - Bisher 7 Zitate in 4 Sätzen: auf das Nötige kürzen.
]
#schreiben[Absatz 2: Bildabgleich und seine Grenzen]

#hinweis[
  *Absatz 3 — Karten als Referenz und warum nur OSM (A2, \#8, \#9).*
  - Warum OSM statt Orthofotos als Referenz, drei Gründe:
    (1) methodisch: Die Testbilder stammen selbst aus den DOP20; ein Abgleich dagegen wäre zirkulär.
    (2) praktisch: DOP20 kommt in Kacheln von etwa 50 MB je km², bis 126 GB je Landkreis; OSM-Objekte sind
    kompakte Vektordaten und weniger erscheinungsabhängig.
    (3) Beitrag: Der Bildabgleich ist etabliert (Absatz 2); diese Arbeit untersucht den kartenbasierten Weg.
    Kombination beider (OSM grob, Orthofoto fein) als Ausblick.
  - Nächste Nachbarn mit Unterschied:
    `costea2016`: Kreuzungen mit OSM, rund 90 % auf 2,5 m, aber bekannte Ausrichtung (Kompass) und 1 m/px.
    `ouyang2024vectormap`, `yuan2025swapf`: semantische Karten im Partikelfilter, brauchen Bildfolge und Anfangspose.
    `sarlin2023orienternet`: bodennahe Kamerabilder. `kunz2021osm`: Szenengraph mit OSM-Landmarken.
  - Bisher 8 Zitate in 4 Sätzen: nur die nächsten Nachbarn nennen, den Rest bündeln oder weglassen.
]
#schreiben[Absatz 3: OSM als Referenz, Abgrenzung zu den nächsten Arbeiten]

#hinweis[
  *Absatz 4 — Fall dieser Arbeit: Nadir, ohne Metadaten, Objektklassen (A5, \#3, \#6).*
  - Warum Nadir: nahezu einheitlicher Maßstab, kartenähnliche Geometrie; OSM-Objekte lassen sich mit Position,
    Drehung und Maßstab ins Bild legen, ohne volle Kamerapose. Orthofotos, Bildflüge und viele Kartierflüge
    liefern solche Bilder. Schrägaufnahmen bräuchten ein Perspektivmodell und Höhen: bewusste Grenze.
  - Warum ohne Metadaten: ungünstigster Fall (Archivbilder, weitergegebene Bilder, ausgefallene Sensoren).
    Vorhandene Teilangaben werden zu Vorwissen; das Suchgebiet ist bekannt (Größe nennen).
  - Klassen: Schwimmbecken, Tennis- und Fußballplätze, Laufbahnen, Lagertanks; Gebäude mit Grundfläche und
    Ausrichtung. Erweiterung: Strommasten, Straßenkreuzungen.
]
#schreiben[Absatz 4: Nadir-Bild ohne Metadaten, erkannte Objektklassen]

#hinweis[
  *Absatz 5 — Problem und Lücke (A6, \#10).*
  - Muss rein: Die Dichte kartierter Objekte schwankt stark zwischen Regionen; merkmalsarme Gebiete gelten als
    besonders schwierig (`jarraya2025gnss`, `zheng2026seqloc`).
  - Kein Beispiel aus der Vorprüfung, keine Ortsnamen (deine Notiz zu A6).
  - Den Widerspruch aus A6 auflösen: Die Arbeit ist nicht auf merkmalsarme Gebiete beschränkt; weil die Dichte
    schwankt, braucht das Verfahren eine begründete Enthaltung.
  - Problemsatz: Es fehlt ein Verfahren, das Erkennungsfehler berücksichtigt, seine Unsicherheit verlässlich
    angibt und sich enthält, wenn ein Bild nicht verortbar ist.
]
#schreiben[Absatz 5: schwankende Objektdichte, Problem]

= Relevanz

#hinweis[
  *Praktisch (A4, \#2b).*
  - Zuerst die Anwendung, die das Design direkt prüft: nachträgliche Verortung von Luftbildern. Dann GNSS-Ausfall
    und Abschattung, Rettungseinsätze, Kartenpflege.
  - Kernargument: Eine falsche, aber als sicher ausgegebene Position ist gefährlicher als eine begründete Enthaltung.
]
#schreiben[Praktische Relevanz]

#hinweis[
  *Theoretisch (\#9; der Reviewer las „keine Lösungen auf semantischen Karten“ heraus).*
  - Klarstellen: Die Bausteine gibt es einzeln. Objektabgleich mit OSM-Landmarken (`kunz2021osm`); Analyse, wann
    ununterscheidbare Landmarken eine Verortung erlauben (`hu2024localizability`); Ablehnung mehrdeutiger Lösungen
    auf semantischen Karten, bisher nur synthetisch geprüft (`sasgeo2026`).
  - Das Messmodell mit Erkennungswahrscheinlichkeit und Poisson-Fehlalarmen ist aus der Mehrzielverfolgung bekannt
    (`mahler2003phd`, `mullane2011rfsslam`; in ergaenzungen.bib, vor dem Zitieren lesen).
  - Neu ist die Kombination: globale Einzelbildsuche über einer Karte mit Enthaltung, je Klasse gemessene
    Detektorfehler, reale Daten, räumlich getrennte Prüfung. Sagen, was man daraus lernt (H1 in Abschnitt 3).
]
#schreiben[Theoretische Relevanz und Lücke]

= Zielsetzung und Ergebnisse

#hinweis[
  *Ziele (A4, \#1, \#11, \#13).*
  - Erster Satz: das Hauptziel. Bilder ohne Metadaten verorten und dabei eine verlässliche Unsicherheit angeben.
    Die Erkennung (FF1) ist Mittel zum Zweck; der Reviewer hielt sie für das Hauptziel.
  - Wissenschaftlich: (1) Erkennungsgüte je Klasse als Fehlermodell (Recall, Fehlalarme, Verwechslungen,
    Lageabweichung); (2) Verortung mit diesem Fehlermodell, kalibrierter Positionsverteilung und Enthaltung.
  - Hypothese H1 (\#8): Der Term für übersehene Kartenobjekte senkt falsche sichere Antworten bei regelmäßigen
    Anordnungen.
  - Praktisch: ein schlanker Prototyp (Bild hochladen, Positionsverteilung oder Enthaltung ausgeben).
  - Erwartete Ergebnisse: Kennzahlen je Klasse; Verortungsquote bei der Schwelle aus E1; Kalibrierung (ECE,
    Brier); Enthaltungsrate. „Empfehlungen zu Kartenmerkmalen“ nur mit Ablation je Klasse (\#11), sonst streichen.
]
#schreiben[Ziele, Hypothese, erwartete Ergebnisse]

#hinweis[
  *Forschungsfragen (\#1, \#2, \#5).*
  - Hauptfrage messbar machen: „zuverlässig“ = Verortungsquote unter beantworteten Bildern und Anteil falscher
    sicherer Antworten; „kalibriert“ = vorhergesagte gegen beobachtete Trefferquote (ECE).
  - FF1: Erkennungsgüte und Fehlermodell; 0,2 m als Trainingsauflösung, Testbilder im Maßstabsband aus E2.
  - FF2: Likelihood mit Fehlermodell und Enthaltung gegen den Abgleich, der nur übereinstimmende Objekte zählt.
  - Übertragbarkeit im Evaluationsdesign: Auswahlkriterien der Regionen (räumlich getrennt, deutlich andere
    Objektdichte, gleicher Befliegungsjahrgang) statt „beispielsweise Alpenvorland und Hochgebirge“.
]
#block(inset: (left: 0.9em), stroke: (left: 2pt + gray))[
  *Forschungsfrage:* #schreiben[Hauptfrage]
  - *FF1:* #schreiben[Erkennung und Fehlermodell]
  - *FF2:* #schreiben[Likelihood, Kalibrierung, Vergleich]
  #schreiben[Satz zur Übertragbarkeit mit den Regionskriterien]
]

= Vorgehensweise und Methoden

#hinweis[
  *Rahmen (\#13).* Design Science Research (`hevner2004design`); Prozess nach Peffers et al.
  (`peffers2007dsrm`, Name im Text, Jahr per `form: "year"`). Die Zieldefinition nennt Anforderungen an das
  Artefakt (Verortungsquote, Kalibrierung, Enthaltung, Laufzeit pro Bild), nicht FF1 und FF2.
]
#schreiben[Methodischer Rahmen]

#hinweis[
  *Daten (\#2, \#2b, \#6).*
  - OSM (ODbL, `osm2026`) über die Overpass API (`olbricht_overpass`) mit festem Abrufdatum; DOP20 (0,2 m,
    CC BY 4.0, `ldbv2026dop20`).
  - Testbilder mit zufälliger Lage, Drehung *und* Bodenauflösung (E2, nur durch Herunterrechnen); wahre Pose
    nur der Auswertung bekannt.
  - Orthofotos als Stellvertreter für senkrechte Drohnenbilder benennen (Zentralperspektive, andere Sensoren
    nicht abgebildet).
  - Bekanntes Suchgebiet: die Testregion, Größe nennen.
]
#schreiben[Daten und Testbilder]

#hinweis[
  *Erkennung, FF1 (\#3, \#7).*
  - Zwei Bausteine: (1) Detektor mit gedrehten Rahmen (`ultralytics2024yolo11`), vortrainiert auf DOTA
    (`xia2018dota`), feinabgestimmt mit OSM-Labels, für die fünf Punktklassen; (2) Gebäudesegmentierung mit
    OSM-Umrissen als Labels. DOTA hat keine Gebäudeklasse; rund 75 % der OSM-Gebäude sind nur `building=yes`,
    deshalb Grundfläche und Ausrichtung als Merkmale.
  - Detektorwahl in einem Satz begründen: einstufige Detektoren (YOLO, SSD) gegen zweistufige (Faster R-CNN).
    Für YOLO-OBB sprechen gedrehte Rahmen, vorhandene DOTA-Gewichte und Geschwindigkeit. Originalarbeiten zitieren
    (`redmon2016yolo`, `ren2017fasterrcnn`, `liu2016ssd` in ergaenzungen.bib), nicht den Medium-Artikel.
    Die Vergleichszahlen von 2016 (Pascal VOC, Bodenfotos) taugen nicht als Beleg für Luftbilder.
  - Aktuelle Belege für schnelle Erkennung kleiner Objekte von oben (wiki: detector-choice):
    YOLO11-OBB 78,4–81,3 mAP50 auf DOTA bei 4,4–28,6 ms je 1024-px-Kachel (T4; Herstellerangabe,
    `ultralytics2024yolo11`) gegen Oriented R-CNN 75,87 % bei etwa 66 ms (`xie2021orientedrcnn`);
    YOLO11 auf Drohnenbildern 32–46 % mAP50 bei 330–38 FPS (`mi2026yolo11suav`). Grenze: Objekte unter
    etwa 16 px (`wang2021aitod`); die Klassen dieser Arbeit sind bei 0,2 m größer (Becken 15–60 px).
    Fehlalarme durch kreisförmige Strukturen bei Tanks (`wan2024yolov7ot`).
  - Manuell geprüfte Teilmenge (z. B. 50 Ausschnitte): real-kartiert, real-unkartiert, Fehlalarm. So trennen sich
    Detektorfehler und OSM-Lücken; OSM-Vollständigkeit schwankt räumlich (`hecht2013completeness`).
]
#schreiben[Erkennung und Fehlermodell]

#hinweis[
  *Verortung, FF2 (\#6, \#8, A2).*
  - Kandidaten statt Vollraster (E7): Paare gleichklassiger Erkennungen ↔ Paare von OSM-Objekten mit passendem
    Abstand ergeben je eine Hypothese aus Position, Drehung, Maßstab. Ein Vollraster hätte etwa 10¹¹ Hypothesen.
  - Likelihood: übereinstimmende Erkennungen (Recall, Verwechslung, Lageabweichung), übersehene Kartenobjekte,
    Fehlalarme als Poisson-Prozess. Grenze: gehäufte Fehlalarme (Tanklager).
  - Enthaltung: größter Log-Likelihood-Quotient gegen „alle Erkennungen sind Fehlalarme“; Schwelle aus
    Negativbildern der Entwicklungsregion, z. B. höchstens 5 % falsche sichere Antworten.
  - Vergleich (E6), gepaart: (a) Zählen übereinstimmender Objekte (`fischler1981ransac`), (b) dasselbe mit
    Klassen-Diversitätsregel, (c) volle Likelihood, (d) ohne Term für übersehene Objekte.
  - Ein Satz, warum kein Bildabgleich gegen DOP verglichen wird: Anfrage und Referenz aus derselben Quelle.
]
#schreiben[Verortung, Enthaltung, Vergleichsverfahren]

#hinweis[
  *Kalibrierung und Evaluation (\#1, \#4, \#5).*
  - Erfolg: Positionsfehler unter der Schwelle aus E1 (keine „noch festzulegende Schwelle“ mehr).
  - Zielgrößen: Risiko-Abdeckungs-Kurve und Fläche darunter (`geifman2017selective`); ECE und Brier-Score,
    Zuverlässigkeitsdiagramm mit 5 Klassen (`guo2017calibration`); Positions-, Maßstabs-, Richtungsfehler.
  - Testsatz (E5): je 70 Bilder mit 1–3, 4–7, ≥ 8 kartierten Objekten; 100 zufällige; 60 Negativbilder.
  - Statistik: McNemar, gepaart. Teststärke 0,79 bei n = 150, 0,90 bei n = 200 (10 % gegen 2 % diskordant).
    Keine falsche sichere Antwort in 60 Negativbildern → Obergrenze 4,9 % (95 %).
  - Räumliche Trennung von Entwicklung und Test (`roberts2017cv`, `ploton2020spatial`); Auswertung nach
    Objektdichte geschichtet, damit Übertragung und Dichte nicht vermischt werden.
]
#schreiben[Kalibrierung, Evaluation, Stichprobe]

#hinweis[
  *Abgrenzung (\#2b, \#18, \#19).*
  - Ausgeschlossen: Schrägaufnahmen, Echtzeit-Navigation, Wechsel des Bildanbieters; Orthofotos als Stellvertreter.
  - Dual Use in zwei bis drei Sätzen: GNSS-unabhängige Navigation ist auch militärisch relevant; nur offene Daten,
    keine Echtzeit-Navigation, zivile Szenarien.
  - Optional: was bei Zeitmangel wegfällt (Strommasten, Kreuzungen, Gegenrichtung, Prototyp-Oberfläche).
]
#schreiben[Abgrenzung und Dual Use]

#pagebreak(weak: true)
#set text(size: 9pt)
#set par(spacing: 0.45em, leading: 0.5em)
#show heading.where(level: 1): set block(above: 0em, below: 0.6em)
#bibliography(("literatur.bib", "kandidaten.bib", "ergaenzungen.bib"), title: [Literatur], style: zitierstil, full: literatur-vollstaendig)
