# Author note: use cases for drone localisation without satellite navigation (2026-10-21)

Pasted by the author with the instruction "ingest". Verbatim:

Anwendungsfall von lokalisierung von Drohnen ohne die Verwendung von Geolokalisationsdiensten
Drohnen ohne GPS oder andere Satellitennavigation (GNSS) zu lokalisieren heißt in der Literatur meist GNSS-denied visual localization. Die Drohne bestimmt ihre Position allein aus ihrem Kamerabild, indem sie es mit Kartendaten vergleicht. Genau das macht euer Matcher-Prototyp (`geo_match.py`): ein Nadirfoto ohne Metadaten mit OSM-Objekten abgleichen.
Typische Anwendungsfälle

1. GPS-Ausfall oder -Störung (Jamming, Spoofing)
   * GPS kann absichtlich gestört oder gefälscht werden. Eine Drohne, die sich zusätzlich visuell verortet, bleibt dann navigierbar und kann gefälschte GPS-Positionen erkennen, indem sie beide vergleicht.
   * Das war auch die Motivation von Costea & Leordeanu (2016): Drohnen sollen weiterfliegen können, wenn das GPS-Signal ausfällt.
2. Abschattung im Gebirge und in Tälern
   * In engen Alpentälern, an Steilwänden oder in Schluchten ist der GPS-Empfang oft schlecht oder durch Reflexionen verfälscht.
   * Das passt gut zum Suchgebiet Oberbayern Süd. Dort hilft zusätzlich das Gelände als Merkmal, zum Beispiel über das Copernicus-Höhenmodell (DEM).
3. Such- und Rettungseinsätze (Bergwacht, Katastrophenschutz)
   * Bei Unwettern oder Lawinen kann GPS gestört sein. Die Bilder sollen trotzdem verlässlich verortet werden, etwa um Fundstellen von Personen oder Schäden einzutragen.
4. Nachträgliche Verortung von Bildmaterial
   * Luftbilder ohne Metadaten: Metadaten entfernt, alte gescannte Luftbilder, Screenshots, Bilder aus Fremdquellen.
   * Anwendungen: Dokumentation, Gutachten, Versicherungsfälle, Abgleich historischer Aufnahmen.
5. Prüfung und Verbesserung der GPS-Position
   * Selbst mit GPS liegen günstige Drohnen oft einige Meter daneben. Der Abgleich mit Kartenobjekten kann die Position auf unter einen Meter verfeinern. In euren Simulationen lag der Positionsfehler bei sicheren Treffern bei etwa 0,2–0,4 m.
   * Davon profitieren Vermessung, Inspektion und das Erstellen von Orthophotos.
6. Inspektion von Infrastruktur
   * Bei Stromleitungen, Masten, Seilbahnen, Brücken und Tanks soll jede Aufnahme exakt dem richtigen Objekt zugeordnet werden.
   * Diese Objekte sind zugleich gute Anker für die Lokalisierung, zum Beispiel `power=tower`, `aerialway=*` oder `man_made=storage_tank`.
7. Kartenpflege: OSM abgleichen und ergänzen
   * Ist das Bild verortet, kann man es mit OSM vergleichen und erkennen, welche Objekte in OSM fehlen und welche dort veraltet sind. Das schließt den Kreis zum ursprünglichen Thesis-Ziel.
8. Militärische und sicherheitsrelevante Nutzung
   * Lokalisierung ohne GNSS ist dort ein großes Thema, das Verfahren ist also Dual-Use.
   * Das gehört in den Ethik- und Rechtsteil der Arbeit (Modul ETHR: DSGVO, AI Act), ebenso die Privatsphäre bei der Verortung fremder Bilder.

Grenzen, die eure Simulation gezeigt hat

* Ein Foto braucht etwa 8 erkannte Objekte, um in einer Region von rund 7.700 km² sicher verortet zu werden. Bei nur 3–4 Objekten scheitert es.
* Auf dem Land reichen Punktobjekte wie Pools oder Tanks daher oft nicht. Zusätzlich braucht es Gebäudegrundrisse, Waldränder, Gewässer und Geländeform.
* Ein Suchgebiet als Vorwissen ist nötig. Je kleiner das Gebiet, desto zuverlässiger der Treffer.

Mögliche Forschungsfrage für das Exposé:
„Wie zuverlässig lässt sich eine Drohnenaufnahme ohne Metadaten allein anhand erkannter OSM-Objekte lokalisieren, skalieren und ausrichten, und wie viele Objekte sind dafür in alpinen und ländlichen Gebieten nötig?”
