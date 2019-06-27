// Amber Billings

var queryUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.geojson";
var platesUrl = "https://raw.githubusercontent.com/fraxen/tectonicplates/master/GeoJSON/PB2002_boundaries.json";

d3.json(queryUrl, function(data) {
  
  createFeatures(data.features);
});

function circleColor(quake) {
  if (quake >= 5) {
    return "#F06B6B";
  }
  else if (quake >= 4) {
    return "#F0A66B";
  }
  else if (quake >= 3) {
    return "#F3BA4C";
  }
  else if (quake >= 2) {
    return "#F4DA4C";
  }
  else if (quake >= 1) {
    return "#E1F34C";
  }
  else {
    return "#B7F34D";
  }
}

function createFeatures(earthquakeData) {

  function onEachFeature(feature, layer) {
    layer.bindPopup("<h3>" + feature.properties.place +
      "</h3><hr><p>" + new Date(feature.properties.time) + "</p>");
  }

  var earthquakes = L.geoJSON(earthquakeData, {
    onEachFeature: onEachFeature,
    pointToLayer: function(feature, latlng) {
      var quakeMarkers = {
        radius: feature.properties.mag * 4,
        fillColor: circleColor(feature.properties.mag),
        fillOpacity: 0.7,
        color: "#000",
        weight: 1
      };
      return L.circleMarker(latlng, quakeMarkers);
    }
  });

  createMap(earthquakes);
}

function createMap(earthquakes, faultLines) {

  var grayscale = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.light",
    accessToken: API_KEY
  });

  var satellite = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.satellite",
    accessToken: API_KEY
  });
  
  var outdoors = L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
    attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
    maxZoom: 18,
    id: "mapbox.outdoors",
    accessToken: API_KEY
  });

  var baseMaps = {
    "Grayscale": grayscale,
    "Satellite": satellite,
    "Outdoors": outdoors
  };

  var faultLines = new L.layerGroup();

  var overlayMaps = {
    "Earthquakes": earthquakes,
    "Fault Lines": faultLines
  };

  var myMap = L.map("map", {
    center: [39.828, -98.579],
    zoom: 4,
    layers: [grayscale, earthquakes, faultLines]
  });

  d3.json(platesUrl, function(platesData) {
    L.geoJSON (platesData, {
      color: "#F06B6B",
      weight: 2
    }).addTo(faultLines)
  });

  L.control.layers(baseMaps, overlayMaps, {
    collapsed: false
  }).addTo(myMap);

  var legend = L.control({ position: "bottomright" });
  legend.onAdd = function() {
    var div = L.DomUtil.create("div", "info legend");
    var limits = ["0-1", "1-2", "2-3", "3-4", "4-5", "5+"];

    var legendInfo =
      "<div class=\"labels\">" +
        "<div class=\"zero\"><p>" + limits[0] + "</p></div>" +
        "<div class=\"one\"><p>" + limits[1] + "</p></div>" +
        "<div class=\"two\"><p>" + limits[2] + "</p></div>" +
        "<div class=\"three\"><p>" + limits[3] + "</p></div>" +
        "<div class=\"four\"><p>" + limits[4] + "</p></div>" +
        "<div class=\"five\"><p>" + limits[5] + "</p></div>" + "</div>";

    div.innerHTML = legendInfo;
    return div;
  };

  legend.addTo(myMap);

}