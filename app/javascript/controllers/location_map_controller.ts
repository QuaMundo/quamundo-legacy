// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

// FIXME: Bootstrap/Popper seems to depend on jQuery - maybe look for another
// solution in future
import $ from 'jquery';

import { Controller } from "stimulus"

import 'ol/ol.css';
import {Map, View} from 'ol';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import * as olProj from 'ol/proj';
import Point from 'ol/geom/Point';
import Feature from 'ol/Feature';
import Overlay from 'ol/Overlay';
import {Fill, Stroke, Circle, Icon, Style} from 'ol/style';

interface LocationData {
  geometry: Array<[number, number]>;
  name: string;
  description?: string;
  url?: string;
  img?: string;
}

// constants
const markerStrokeWidth: number = 3;
const markerStrokeColor: string = 'red';
const markerFillColor: string = 'rgba(255,255,255,0.1)';
const markerRadius: number = 8;
// const markerFillOpacity: number = 0.4;
const mapZoom: number = 14;
const maxZoom: number = 18;

// OL Styles
const markerStyle: Style = new Style({
  image: new Circle({
    stroke: new Stroke({
      color: markerStrokeColor,
      width: markerStrokeWidth
    }),
    fill: new Fill({
      color: markerFillColor
    }),
    radius: markerRadius
  })
});

// OL Sources, Layers and Features
const osmSource: OSM = new OSM();
const osmLayer: TileLayer = new TileLayer({ source: osmSource });
const vectorSource: VectorSource = new VectorSource();
const vectorLayer: VectorLayer = new VectorLayer({ source: vectorSource });

const view: View = new View({maxZoom: maxZoom});

// OL Overlays
const popup: Overlay = new Overlay({
  positioning: 'bottom-center',
  //stopEvent: false,
  //offset: [0, -10]
});

// OL - The map
const map: Map = new Map({
  layers: [osmLayer, vectorLayer],
  view: view,
  overlays: [popup]
});

// Workaround due to compiler/type error
// see:
// https://github.com/stimulusjs/stimulus/issues/221#issuecomment-457275513
class LocationMapControllerBase extends Controller {
  mapTarget!: HTMLElement;
  popupTarget!: HTMLElement;
  longValue: number;
  latValue: number;
  nameValue: string;
  descValue: string;
  urlValue: string;
  tileserverValue!: string;
  ajaxUrlValue: string;
  imgValue: string;
}

export default class extends (Controller as typeof LocationMapControllerBase) {
  static targets = [ 'map', 'popup' ];

  static values = {
    long: Number,
    lat: Number,
    name: String,
    desc: String,
    url: String,
    tileserver: String,
    ajaxUrl: String,
    img: String
  };

  private addLocationsAjax(locations: Object[]): void {
    // FIXME: Use .filter to get rid of locations w/o coords
    locations.forEach(location => {
      if (location['lon'] != undefined && location['lat'] != undefined ) {
        const lonLat = olProj.fromLonLat([location['lon'], location['lat']]);
        this.addFeature({
          geometry: lonLat,
          name: location['name'],
          description: location['description'],
          url: location['url'],
          img: location['img']
        });
      }
    });
    const p = markerRadius * 2;
    view.fit(vectorSource.getExtent(), {
      padding: [p, p, p, p]
    });
    this.setupPopup();
  }

  private addLocationsStimulus(): void {
    const lonLat = olProj.fromLonLat([this.longValue, this.latValue]);
    this.addFeature({
      geometry: lonLat,
      name: this.nameValue,
      description: this.descValue,
      url: this.urlValue,
      img: this.imgValue
    });
    view.setCenter(lonLat);
    view.setZoom(mapZoom);
    this.setupPopup();
  }

  // FIXME: Refactor this
  private addFeature(data: LocationData): void {
    const point: Point = new Point(data.geometry);
    data['geometry'] = point;
    const feature: Feature = new Feature(data);
    feature.setStyle(markerStyle);
    vectorSource.addFeature(feature);
  }

  private setupPopup(): void {
    const element = popup.getElement();
    map.on('click', (e) => {
      const feature = map.forEachFeatureAtPixel(e.pixel, (f) => f);
      if (feature) {
        $(element).popover('dispose');
        const name = feature.getProperties().name;
        const desc = feature.getProperties().description;
        const url = feature.getProperties().url;
        const img = feature.getProperties().img;
        const lonLat = feature.getGeometry().getCoordinates();

        // FIXME: Style this content better - maybe use html template
        let html: string;
        html = '<p class="small"><a href="' +
          url +
          '">';
        if (img) {
          html += `<img src="${img}" class="popup-img" />`;
        }
        html += desc  + '</a></p>';

        popup.setPosition(lonLat);
        $(element).popover({
          container: element,
          placement: 'auto',
          html: true,
          content: html,
          title: name
        });
        $(element).popover('show');
      } else {
        $(element).popover('dispose');
      }
    });
    map.on('pointermove', (e) => {
      if (e.dragging) {
        $(element).popover('dispose');
        return;
      }
      const px = map.getEventPixel(e.originalEvent);
      const hit = map.hasFeatureAtPixel(px);
      map.getTarget().style.cursor = hit ? 'pointer' : '';
    });
  }

  private setupMap(): void {
    if (!this.tileserverValue) { return; }

    osmSource.setUrl(this.tileserverValue);
    popup.setElement(this.popupTarget);

    if (this.ajaxUrlValue) {
      // do fetch...then...then...catch
      fetch(this.ajaxUrlValue)
      .then(response => response.json())
      .then(json => { this.addLocationsAjax(json) })
      .catch(error => console.log(error));
    }
    else {
      // use stimulus values
      this.addLocationsStimulus();
    }


    // view.setCenter(lonLat);
    // view.setZoom(mapZoom);
    map.setTarget(this.mapTarget);
  }

  connect(): void {
    this.setupMap();
  }
}
