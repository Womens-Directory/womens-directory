import * as leaflet from "leaflet";
import "leaflet/dist/leaflet.css";
import "../map.scss";
import marker1x from "leaflet/dist/images/marker-icon.png";
import marker2x from "leaflet/dist/images/marker-icon-2x.png";
import markerSh from "leaflet/dist/images/marker-shadow.png";

interface Point {
  name: string;
  latitude: number;
  longitude: number;
}

const DENVER_DOWNTOWN: leaflet.LatLngTuple = [
  39.75316148610883,
  -105.00014407137768
];

function tileSet(): leaflet.TileLayer {
  return leaflet.tileLayer(
    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    {
      tileSize: 256,
      // detectRetina: true,
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }
  );
}

// HACK: URL is corrupted on the way into Rails; we fix the URLs and leave the other options at default
// https://github.com/Leaflet/Leaflet/blob/0f904a515879fcd08f69b7f51799ee7f18f23fd8/src/layer/marker/Icon.Default.js#L23-L30
const pin = new leaflet.Icon({
  iconUrl: marker1x,
  iconRetinaUrl: marker2x,
  shadowUrl: markerSh,
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  tooltipAnchor: [16, -28],
  shadowSize: [41, 41]
});

const tgts: HTMLElement[] = Array.prototype.slice.call(
  document.querySelectorAll(".map-embed")
);

tgts.forEach(tgt => {
  const latitude = parseFloat(tgt.getAttribute("data-latitude"));
  const longitude = parseFloat(tgt.getAttribute("data-longitude"));
  const map = leaflet.map(tgt, { center: [latitude, longitude], zoom: 13 });
  tileSet().addTo(map);
  leaflet.marker([latitude, longitude], { icon: pin }).addTo(map);
});

const birdseyes: HTMLElement[] = Array.prototype.slice.call(
  document.querySelectorAll(".map-embed-birdseye")
);

birdseyes.forEach(tgt => {
  const map = leaflet.map(tgt, { center: DENVER_DOWNTOWN, zoom: 10 });
  tileSet().addTo(map);
  const locs = JSON.parse(tgt.getAttribute("data-locs"));
  const opts = { radius: 10, color: "red" };
  const markers: leaflet.Marker[] = locs.map((point: Point) => {
    const coords: leaflet.LatLngTuple = [point.latitude, point.longitude];
    const marker = leaflet.circleMarker(coords, opts);
    marker.bindPopup(point.name);
    return marker;
  });
  markers.forEach(m => m.addTo(map));
  map.fitBounds(leaflet.featureGroup(markers).getBounds());
});
