var API = "93fb557921f04f9c8a1cecab83930c97";
var longitude = 0;
var latitude = 0;

//init map
var map = L.map('map').setView([37.3861, -122.0839], 14);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);


//marker variable
var marker;
//place marker on click
map.on('click', function(e){
    if (marker) {
        map.removeLayer(marker);
    }
    marker = new L.marker(e.latlng).addTo(map);
    getAddress(e);
    adjustRadius();
});


marker.on('mouseover', function(e){
    var popup = e.target.getPopup();
    popup.setContent("<div><p>hello bitch</p></div>");
    popup.openPopup();
});


function createMarkers() {
    //TEST ARRAY BELOW
    var markers = [
        [ -0.1244324, 51.5006728, "Big Ben" ],
        [ -0.119623, 51.503308, "London Eye" ],
        [ -0.1279688, 51.5077286, "Nelson's Column<br><a href=\"https://en.wikipedia.org/wiki/Nelson's_Column\">wp</a>" ] 
     ];
     
     //Loop through the markers array
     for (var i = 0; i < markers.length; i++) {
       
        var lon = markers[i][0];
        var lat = markers[i][1];
        var popupText = markers[i][2];
        
         var markerLocation = new L.LatLng(lat, lon);
         var newmarker = new L.Marker(markerLocation);
         map.addLayer(newmarker);
     
         newmarker.bindPopup(popupText);
     
     }
}

//geocode address from click
function getAddress(e) {
    
    var api_key = API;
    var loc = e.latlng.toString();
    latitude = loc.split(",")[0].split("(")[1];
    longitude = loc.split(",")[1].split(")")[0];
 
    var api_url = 'https://api.opencagedata.com/geocode/v1/json'
 
    var request_url = api_url
    + '?'
    + 'key=' + api_key
    + '&q=' + encodeURIComponent(latitude + ',' + longitude)
    + '&pretty=1'
    + '&no_annotations=1';
 
    // see full list of required and optional parameters:
    // https://opencagedata.com/api#forward
 
    var request = new XMLHttpRequest();
    request.open('GET', request_url, true);
 
    request.onload = function() {
    // see full list of possible response codes:
    // https://opencagedata.com/api#codes
 
       if (request.status === 200){
          // Success!
          var data = JSON.parse(request.responseText);
          // alert(data.results[0].formatted); // print the location
          document.getElementById("addressBox").value = data.results[0].formatted;
    
       } else if (request.status <= 500){
          // We reached our target server, but it returned an error
    
          console.log("unable to geocode! Response code: " + request.status);
          var data = JSON.parse(request.responseText);
          console.log('error msg: ' + data.status.message);
       } else {
          console.log("server error");
       }
    };
 
    request.onerror = function() {
    // There was a connection error of some sort
    console.log("unable to connect to server");
    };
 
    request.send();  // make the request
}

map.on('moveend', function() { 
    console.log("LatLng: "+map.getBounds().toBBoxString() + "\nZoom: " + map.getZoom());
});


//adjust radius
var circle;
var radius;
function adjustRadius() {
    radius = document.getElementById("radius").value;
    if (marker) {
        if (circle || radius == '') {
            map.removeLayer(circle);
        }
        circle = L.circle([latitude, longitude], {
            color: 'red',
            fillColor: '#f03',
            fillOpacity: 0.5,
            radius: radius
        }).addTo(map);
    }
}


// submit Location

function submitLocation() {
    var outJson = {
        "location": [latitude, longitude],
        "radius": radius
    }

    fetch('138.197.104.208:5000/query', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(outJson)
    }).then(function(response) {
        console.log(response)
        return response.json();
    });
}
