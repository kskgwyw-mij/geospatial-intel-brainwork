# Peer Review des Exposé-Entwurfs (Mitstudierende/r) mit handschriftlichen Kommentaren des Autors

Transkription aus zwei Fotos des ausgedruckten Reviews, erstellt vom KI-Assistenten am 2026-10-26 auf Wunsch des Autors.
Fotos: `raw/assets/2026-10-26-peer-review-expose-p1.jpg`, `raw/assets/2026-10-26-peer-review-expose-p2.jpg`.
Begutachtet wurde der Exposé-Entwurf vom 22.10.2026 (PDF bytegleich mit `expose/expose-ki-entwurf.pdf`, Commit 411def2).
Name der begutachtenden Person: auf den Fotos nicht angegeben.

Konventionen: Gedruckter Text wörtlich. Handschriftliche Kommentare des Autors (grüner Stift) mit „✍“ markiert,
unsichere Lesungen mit [?], Tippfehler im Original mit [sic].

---

## Seite 1

Kalibrierte probabilistische Geolokalisierung von Nadir-Luftbildern anhan [sic] von OpenStreetMap-Objektmerkmalen.

### Summary

Das Exposé zur Arbeit beschreibt eine Möglichkeit, Nadir-Luftbilder ohne verfügbare Metadaten anhand von in
OpenStreetMap (OSM) verzeichneten Objekten mithilfe einer Wahrscheinlichkeitsfunktion zu lokalisieren. Zudem werden
bereits etablierte Ansätze vorgestellt, die Satellitenbilder oder Orthofotos verwenden, um Drohnen bei einem Ausfall
des Signalempfangs visuell zu lokalisieren.

Die Verwendung von OSM-Daten wird mit deren freier Verfügbarkeit sowie erscheinungsunabhängigen Referenzen der
enthaltenen Objekte begründet.

Im Exposé werden außerdem Zahlen genannt, die darauf hinweisen, dass in den als Zielregion für die Arbeit vorgesehenen
Gebieten nur wenige kartierte Objekte vorhanden sind.

Als praktische Relevanz der Arbeit wird die GNSS-unabhängige Lokalisierung von Drohnen genannt. Aus theoretischer
Sicht wird das Themengebiet als besonders interessant dargestellt, da laut Exposé bislang keine Lösungen zur
Lokalisierung auf Basis semantischer Karten existieren. Darüber hinaus soll eine Wahrscheinlichkeitsfunktion in das
Verfahren eingeführt werden.

Ziel der Arbeit ist die Untersuchung, wie gut OSM-Objekte in Nadir-Bildern ohne Metadaten erkannt werden können. Die
Entwicklung und das Training des Verfahrens erfolgen dabei in einer vollständig von der Testregion getrennten Gegend,
in der das System später evaluiert wird.

Der grundsätzliche Aufbau der Vorgehensweise und der gewählten Methodik ist schlüssig und logisch nachvollziehbar. Die
Forschungsfragen sind passend zum Thema formuliert und durch die im Exposé dargestellte Problemstellung sowie die
Zielsetzung der Arbeit angemessen begründet.

### Anmerkungen

Das Exposé ist insgesamt schwer zu lesen. Viele Sätze sind sehr lang und beeinträchtigen den Lesefluss.

✍ „änderbar ✓“

Es wird nicht deutlich begründet, warum ausschließlich mit OSM-Daten lokalisiert werden soll und warum
Satellitenbilder oder Orthofotos nicht ergänzend genutzt werden.

✍ „⇒ guter Punkt“

In einzelnen kurzen Abschnitten werden sehr viele Referenzen angeführt, wodurch die Übersichtlichkeit leidet.

✍ „⇒ Referenzen gezielter verwenden“ (letztes Wort am Seitenrand abgeschnitten [?])

Es bleibt unklar, ob das primäre Ziel die Navigation von Drohnen ist oder ob auch andere Anwendungsbereiche
adressiert werden sollen.

✍ „→ Ziel ist nicht leicht verständlich“

Ebenso wird nicht ausreichend erläutert, warum die korrekte Einordnung von Nadir-Aufnahmen in diesem Zusammenhang
besonders wichtig ist. Da Drohnen auch Bilder aus anderen

✍ (unten auf Seite 1) „Bezug zu Drohnen zu arg → nur ein Anwendungsfall“ (Ende abgeschnitten [?])

## Seite 2

Perspektiven aufnehmen könnten oder Metadaten erfassen, sollte begründet werden, weshalb der Fokus ausschließlich auf
Nadir-Aufnahmen liegt.

Es erscheint nicht vollständig schlüssig, warum die Lokalisierung auf Grundlage von Objekten erfolgen soll, die
überwiegend in gut kartierten Gebieten wie Städten oder Siedlungsräumen vorkommen, während als Einsatzgebiet im Exposé
der Bayerische Alpenrand genannt wird, in dem laut Exposé nur wenige kartierte Objekte vorhanden sind. Dieser
Widerspruch wird nicht ausreichend diskutiert oder begründet.

Nach dem Lesen des Exposés entsteht der Eindruck, dass ein sehr großer Teil des Textes mithilfe von KI erstellt oder
zumindest stark überarbeitet wurde. Dieser Eindruck wird insbesondere durch die Satzkonstruktionen verstärkt, die
häufig Semikolons, Gedankenstriche sowie lange und stark verschachtelte Formulierungen verwenden.

✍ (Pfeil vom linken Rand beim Absatz „Es erscheint nicht vollständig schlüssig …“, am letzten Absatz vorbei nach unten)
„Beispiel aus PoC nicht erwähnen → zu verwirrend“
