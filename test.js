var map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);




//TEST ARRAY BELOW
var markers = [
    [ -0.1244324, 51.5006728, "Big Ben" ],
    [ -0.119623, 51.503308, "London Eye" ],
    [ -0.1279688, 51.5077286, "Nelson's Column<br><a href=\"https://en.wikipedia.org/wiki/Nelson's_Column\">wp</a>" ] 
 ];

createMarkers();

function createMarkers() {
     //Loop through the markers array
     for (var i = 0; i < markers.length; i++) {
       
        var lon = markers[i][0];
        var lat = markers[i][1];
        var popupText = markers[i][2];
        
        var markerLocation = new L.LatLng(lat, lon);
        var newmarker = new L.marker(markerLocation).bindPopup('');
        map.addLayer(newmarker);
     
        newmarker.on('mouseover', function(e) {
            var popup = e.target.getPopup();
            popup.setContent("<div><p>hello bitch</p><img src='images/insight_logo.png' width='100' height='100'></div>");
            e.target.bindPopup(popup).openPopup();
        });

        newmarker.on('mouseout', function(e) {
            e.target.closePopup();
        });
     }
}