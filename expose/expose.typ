// Exposé zur Masterarbeit — Typst-Gerüst
// Kompilieren:  typst compile expose/expose.typ
// Anonym: Name nirgends eintragen (auch nicht in `set document`), PDF-Eigenschaften nach dem Export prüfen.
// Vorgaben: Kurs "Wissenschaftliches Arbeiten" (siehe wiki/sources/wa-course-expose.md),
// Material je Abschnitt: wiki/analyses/expose-material.md

// --- Schalter ---------------------------------------------------------------
#let zeige-hinweise = true   // für die Abgabe auf false setzen
#let zitierstil = "apa"      // HOK-Leitfaden prüfen; Alternativen: "ieee", "harvard-cite-them-right"

// --- Metadaten (ohne Namen!) -------------------------------------------------
#let arbeitstitel = [Arbeitstitel (max. 8–12 Wörter, ohne Abkürzungen)]
#let untertitel = none       // z. B. [am Beispiel …] oder none
#let studiengang = [Masterstudiengang Data Science & Intelligent Analytics (berufsbegleitend)]
#let hochschule = [Hochschule Kufstein Tirol]
#let kurs = [Lehrveranstaltung „Wissenschaftliches Arbeiten“, WS 2026/27]
#let abgabe = datetime(year: 2026, month: 10, day: 23)

#set document(title: "Exposé zur Masterarbeit", author: ())
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  number-align: center,
)
#set text(lang: "de", region: "AT", size: 11pt)
#set par(justify: true, leading: 0.7em, spacing: 1.1em)
#set heading(numbering: "1.")
#show heading.where(level: 1): set block(above: 1.6em, below: 0.9em)

// Hinweisbox: zeigt, was in den Abschnitt gehört; verschwindet mit zeige-hinweise = false
#let hinweis(body) = if zeige-hinweise {
  block(
    width: 100%, inset: 8pt, radius: 3pt,
    fill: rgb("#fff4d6"), stroke: rgb("#e0b84a"),
    text(size: 9pt, fill: rgb("#5a4500"))[*Hinweis (vor Abgabe entfernen):* #body],
  )
}

// --- Titelblock ---------------------------------------------------------------
#align(center)[
  #text(size: 10pt, upper[Exposé zur Masterarbeit]) \
  #v(0.4em)
  #text(size: 17pt, weight: "bold", arbeitstitel)
  #if untertitel != none [ \ #text(size: 12pt, untertitel) ]
  #v(0.6em)
  #text(size: 10pt)[#studiengang · #hochschule \ #kurs · #abgabe.display("[day].[month].[year]")]
]
#v(1em)

#hinweis[
  Titel: einfach, selbsterklärend für Fachfremde, auf den Punkt (ab 8–12 Wörtern lässt das Interesse nach,
  möglichst eine Zeile), neugierig machend, ohne Ergebnisse vorwegzunehmen. Keine Abkürzungen wie OSM, GNSS, DOP.
]

= Ausgangssituation und Problemstellung

#hinweis[
  Ausgangslage (GNSS-Abhängigkeit, offene Karten- und Orthofotodaten) → Problem (Foto ohne Metadaten verorten,
  skalieren, ausrichten; Erkennung ist Teil der Arbeit) → Vorarbeiten (Schlüssel z. B. `@costea2016`, `@maggiori2017labeling`)
  → Problembereich (ländliche und alpine Gebiete mit wenigen markanten Objekten) → Untersuchungsraum.
  Zahlen und Quellen: `wiki/analyses/expose-material.md`.
]

// Eigener Text hier.

= Relevanz

#hinweis[
  Theoretische Relevanz: Wissenslücke (objektbasierte Verortung in merkmalsarmen Gebieten, wie viele Objekte nötig sind).
  Praktische Relevanz: GNSS-unabhängige Navigation, Bergrettung, nachträgliche Verortung, OSM-Pflege.
  Der Leser soll den Mehrwert verstehen. *Begutachtete Literatur zur Relevanz noch selbst recherchieren und lesen.*
]

// Eigener Text hier.

= Zielsetzung und Ergebnisse

#hinweis[
  Wissenschaftliche Ziele (FF1 Erkennung, FF2 Verortung), praktische Ziele (Prototyp mit Upload),
  erwartete Ergebnisse (Kennzahlen je Klasse, Erfolgsquote nach Objektanzahl, Grenzen, Empfehlungen)
  und die abgeleitete Forschungsfrage (mit der Betreuung fixieren). Je genauer, desto leichter die Durchführung.
]

// Eigener Text hier.

// Forschungsfrage hervorheben, z. B.:
// #block(inset: (left: 1em), stroke: (left: 2pt + gray))[*Forschungsfrage:* …]

= Vorgehensweise und Methoden

#hinweis[
  Theoretisches Rahmenwerk → Ablauf (Daten, Erkennung, Verortung, Evaluation, Prototyp) → Methode je Schritt
  (z. B. vortrainierter Detektor `@xia2018dota`, robuste Transformationsschätzung `@fischler1981ransac`,
  Training mit ungenauen Kartenlabels `@maggiori2017osm`). KI-gestützte Vorprüfungen als solche kennzeichnen.
]

// Eigener Text hier.

// Optional: Ablauf als Tabelle
// #table(columns: (auto, 1fr, 1fr), [*Schritt*], [*Ziel*], [*Methode*], …)

#hinweis[
  Literatur: Vorarbeiten, Literatur zur Relevanz, existierende Ergebnisse, Referenzen zu geplanten oder ähnlichen
  Methoden. Nur selbst gelesene und geprüfte Quellen zitieren; Einträge in `literatur.bib` vorher kontrollieren.
  Im Verzeichnis erscheinen nur tatsächlich zitierte Quellen (Zitat im Text: `@schluessel`).
]

#bibliography("literatur.bib", title: "Literatur", style: zitierstil)
