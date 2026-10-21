# Bayern OpenGeoData portal: DOP20 RGB detail page + further datasets (search notes)

URLs given by the author:
- https://geodaten.bayern.de/opengeodata/OpenDataDetail.html?pn=dop20rgb
- https://geodaten.bayern.de/opengeodata/index.html
Captured 2026-10-21. geodaten.bayern.de was blocked from the research environment; these are web-search snippets. Check the pages directly.

## DOP20 RGB
- The OpenData portal of the Bavarian surveying administration offers "Digitales Orthophoto RGB 20cm (DOP20 RGB)" free as download,
  bulk download and service. https://data-lra-cha.opendata.arcgis.com/documents/LRA-CHA::-opengeodata-portal-bayern
- WMS: https://geoservices.bayern.de/od/wms/dop/v1/dop20?REQUEST=GetCapabilities&SERVICE=WMS ; info:
  https://geodatenonline.bayern.de/geodatenonline/seiten/wms_dop20cm ; CRS among others EPSG:25832 (ETRS89 / UTM 32N); image/tiff output; licence CC BY 4.0.
- Federal DOP20 documentation (BKG, as of 26.01.2026), https://sg.geodatenzentrum.de/web_public/gdz/dokumentation/deu/dop.pdf :
  1 x 1 km tiles, GeoTIFF with JPEG compression, by default only in UTM32 (EPSG:25832); a .csv metadata file per raster file with the same name.
  (Federal product; the Bavarian download tiling is assumed similar but not confirmed.)
- Bavarian DOP info: https://geodatenonline.bayern.de/geodatenonline/seiten/dop_info

## Other Bavarian OpenData products (free since early 2023)
Sources: https://www.ldbv.bayern.de/aktuell/archiv/datenschaetze_vermessungsverwaltung-00409.html ,
https://www.geobranchen.de/mediathek/geonews/item/bayerische-vermessungsverwaltung-zahlreiche-geobasisdaten-werden-als-opendata-zur-verf%C3%BCgung-gestellt ,
https://gispoint.de/news-einzelansicht/200004058-noch-mehr-opendata-in-der-bvv.html , https://www.geodaten.bayern.de/odd/m/3/html/faq.html
- Digital topographic maps, Webkarte Bayern, digital orthophotos (DOP20, DOP40), digital terrain model (DGM), 3D building models (LoD2),
  laser data (Laserpunkte, added H1 2023), digital landscape model ATKIS Basis-DLM, ALKIS parcel map (Parzellarkarte), building outlines (Hausumringe).
- DGM1 (1 m grid) and DGM5 (5 m grid) for all of Bavaria, CC BY 4.0. https://geodatenonline.bayern.de/geodatenonline/seiten/dgm_info ,
  https://twin4clim.gis.lrg.tum.de/dataset/digitales-gelandemodell-1m-dgm1-bayern
- Product groups: cyclically updated (DOP/DOM), continuously updated (LoD2, ALKIS administrative areas), others.
- Licence note: for sensitive data such as parcel boundaries the right to modify is excluded; other products may be edited and used commercially
  with attribution and licence notice.
- Community bulk-download helper: https://github.com/mueckl/opendata_bayern_download
