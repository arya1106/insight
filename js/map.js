var API = "93fb557921f04f9c8a1cecab83930c97";
var longitude = 0;
var latitude = 0;

//init map
var map = L.map('map').setView([37.3861, -122.0839], 14);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);
L.control.scale().addTo(map);

//marker variable
var marker;
//place marker on click
map.on('click', function(e){
    if (marker) {
        map.removeLayer(marker);
    }
    marker = new L.marker(e.latlng).addTo(map);
    marker._icon.style.filter = "hue-rotate(170deg)";
    getAddress(e);
    adjustRadius();
});


//geocode address from click
function getAddress(e) {
    
    var api_key = API;
    var loc = e.latlng.toString();
    latitude = loc.split(",")[0].split("(")[1];
    longitude = loc.split(",")[1].split(")")[0];

    document.getElementById("coords-label").textContent = latitude + ", " + longitude;
 
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

// map.on('moveend', function() { 
//     console.log("LatLng: "+map.getBounds().toBBoxString() + "\nZoom: " + map.getZoom());
// });


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
            fillOpacity: 0.25,
            radius: radius
        }).addTo(map);
    }
}


// submit Location
function submitLocation() {

    if(radius === "" || (latitude === 0 && longitude === 0)) {
        alert("Enter a valid input!");
        return;
    }

    document.getElementById("loader").style.visibility = "visible";

    var outJson = {
        "location": [latitude, longitude],
        "radius": radius
    }

    var markergroup = L.markerClusterGroup();

    fetch('http://138.197.104.208:5000/query', {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(outJson)
    }).then(response => response.json()).then(response => {

        document.getElementById("loader").style.visibility = "hidden";

        for(var i = 0; i < response["markers"].length; i++) {
            (function () {
                var lat = response["markers"][i]["location"][0];
                var lon = response["markers"][i]["location"][1];
                var damageType = response["markers"][i]["damageType"];
                var imageString = response["markers"][i]["image"];
                var dataSource = response["markers"][i]["dataSource"];

                // 1 = predicted, 2 = reported
                var dataSourceString = "";
                switch(dataSource) {
                    case 1:
                        dataSourceString = "Predicted";
                        break;
                    case 2:
                        dataSourceString = "Reported";
                        break;
                    default:
                        dataSourceString = dataSource;
                }

                //{0: "long_crack", 1: "trans_crack", 2: "aligator_crack", 3: "pothole"}
                var damageTypeString = "";
                switch(damageType) {
                    case 0:
                        damageTypeString = "Longitudinal Crack";
                        break;
                    case 1:
                        damageTypeString = "Transverse Crack";
                        break;
                    case 2:
                        damageTypeString = "Alligator Crack";
                        break;
                    case 3:
                        damageTypeString = "Pothole";
                        break;
                    default:
                        damageTypeString = damageType;
                }
                
                var markerLocation = new L.LatLng(lat, lon);
                var newmarker = new L.marker(markerLocation).bindPopup('');
                newmarker.on('mouseover', function(e) {
                    
                    var binaryImg = atob(imageString);
                    var length = binaryImg.length;
                    var ab = new ArrayBuffer(length);
                    var ua = new Uint8Array(ab);
                    for (var j = 0; j < length; j++) {
                        ua[j] = binaryImg.charCodeAt(j);
                    }
                    var blob = new Blob([ab], {
                        type: "image/jpeg"
                    });
                    const url = URL.createObjectURL(blob)
                    
                    var popup = e.target.getPopup();
                    popup.setContent(`
                    <div class='popup-div'>
                        <p class="popup-label-1">${dataSourceString}</p>
                        <br>
                        <p class="popup-label">${damageTypeString}</p>
                        <img src='${url}'>
                    </div>
                    `);
                    e.target.bindPopup(popup, {maxWidth : "auto", position : "relative"}).openPopup();
                });
                newmarker.on('mouseout', function(e) {
                    e.target.closePopup();
                });
                //map.addLayer(newmarker);
                markergroup.addLayer(newmarker);
                //if (response["markers"][i]["dataSource"] == 1) {
                //  markergroup.getAllChildMarkers()[i]._icon.style.filter = "hue-rotate(270deg)";
                //}
            }());
        }
        map.addLayer(markergroup);
        for (var i = 0; i < response["markers"].length; i++) {
            if (response["markers"][i]["dataSource"] == 1) {
                markergroup.getLayers()[i]._icon.style.filter = "hue-rotate(270deg)";
            }
        }
    });
}
