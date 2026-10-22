// Dokumentation der verwendeten KI-Tools (zweites PDF zur Exposé-Abgabe)
// Kompilieren:  typst compile expose/ki-dokumentation.typ
// Faktengrundlage: wiki/analyses/expose-material.md (Abschnitt "KI-Dokumentation") und wiki/log.md.
// Zeilen prüfen und anpassen: nur eintragen, was tatsächlich so war. Den Prozentwert legst du selbst fest (max. 50 %).

#let zeige-hinweise = true
#let ki-anteil = none        // z. B. 30 (Prozent); muss <= 50 sein

#set document(title: "Dokumentation der verwendeten KI-Tools", author: ())
#set page(paper: "a4", margin: 2.5cm, numbering: "1")
#set text(lang: "de", region: "AT", size: 10.5pt)
#set par(justify: true)

#let hinweis(body) = if zeige-hinweise {
  block(width: 100%, inset: 8pt, radius: 3pt, fill: rgb("#fff4d6"), stroke: rgb("#e0b84a"),
    text(size: 9pt, fill: rgb("#5a4500"))[*Hinweis (vor Abgabe entfernen):* #body])
}

#align(center, text(size: 15pt, weight: "bold")[Dokumentation der verwendeten KI-Tools])
#align(center, text(size: 10pt)[Zum Exposé zur Masterarbeit · Lehrveranstaltung „Wissenschaftliches Arbeiten“, WS 2026/27])
#v(1em)

#hinweis[
  Laut Aufgabenstellung genau dokumentieren, welche Tools für welche Aufgaben verwendet wurden, und den KI-Anteil
  in % schätzen (0 % = ohne KI, 100 % = komplett KI). Über 50 % sind nicht erlaubt. Nicht genutzte Zeilen löschen,
  weitere Tools (z. B. Rechtschreibprüfung, Literaturtools) ergänzen.
]

= Verwendete Tools und Aufgaben

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  stroke: 0.5pt + gray,
  table.header([*Tool*], [*Aufgabe / was die KI gemacht hat*], [*Eigene Leistung*]),
  [Claude Code (Anthropic)], [Aufbau einer Wissensbasis: Zusammenfassungen gesammelter Quellen, Querverweise, Entscheidungsübersichten],
    [Auswahl der Quellen, Fragestellungen, inhaltliche Entscheidungen (Untersuchungsraum, Eingabedaten, Umfang)],
  [Claude Code (Anthropic)], [Websuchen; Zusammenfassung von zwei Fachartikeln],
    [Lesen der Originalartikel; eigene Literaturrecherche zur Relevanz],
  [Claude Code (Anthropic)], [Vorschläge zur Gliederung der Forschungsfrage in Teilfragen],
    [Ursprüngliche Fragestellung und Anwendungsfälle; Festlegung der Forschungsfrage],
  [Claude Code (Anthropic)], [Programmierung von Prototyp-Werkzeugen und Durchführung KI-gestützter Machbarkeitsprüfungen mit offenen Daten],
    [Prüfung und Interpretation; Durchführung der eigentlichen Experimente in der Masterarbeit],
  [Claude Code (Anthropic)], [Checkliste und Stichpunktsammlung je Exposé-Abschnitt; Typst-Vorlage],
    [Formulierung des gesamten Exposé-Texts],
  [Claude Code (Anthropic)], [Rohfassung als Absatzplan: Kernaussage, Belege aus der eigenen Literaturliste und Belegstatus je geplantem Absatz (Datei `expose-rohfassung.typ`)],
    [Eigene Literaturrecherche (Quellenliste), Auswahl und Prüfung der Belege, Ausformulierung aller Absätze in eigenen Worten],
)

= Geschätzter KI-Anteil

#if ki-anteil == none [
  #hinweis[Wert in `ki-anteil` eintragen und kurz begründen (z. B. Anteil je Abschnitt schätzen und mitteln).]
] else [
  Geschätzter Anteil des KI-Einsatzes am Exposé: *#ki-anteil %*.
  #if ki-anteil > 50 { text(fill: red)[*Achtung: über 50 % ist nicht erlaubt.*] }
]

// Begründung (eigener Text):
