<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Simple Map</title>
    <meta name="viewport" content="initial-scale=1.0">
    <meta charset="utf-8">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    
    <script>
    
      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: 34.841826, lng: 128.429258},
          zoom: 15
        });
        
      }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAielEI8uwxowfwwoNiElV53KdwTHbe1ew&callback=initMap&sensor=true"></script>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script> 

    
    <script>
    
    $(document).ready(function() {
    	
        $.getJSON("/sample/dataEx.json", function(json1) {
        	$.each(json1, function(key, data) {
        	 
	       		var title = data.title;
	       		var descs = data.descs;
	       		
	            var latLng = new google.maps.LatLng(data.lat, data.lng); 
	            
	            var infoWindow = new google.maps.InfoWindow;
	            
	            var infowincontent = document.createElement('div');
	            var strong = document.createElement('strong');
	            strong.textContent = title;
	            infowincontent.appendChild(strong);
	            infowincontent.appendChild(document.createElement('br'));
	            
	            var text = document.createElement('text');
	            text.textContent = descs;
	            infowincontent.appendChild(text);
	            
	            // Creating a marker and putting it on the map
	            var marker = new google.maps.Marker({
	            	map: map,
	                position: latLng,
	                title: data.title
            	});
	            marker.addListener('click',function() {
	            	infoWindow.setContent(infowincontent);
	            	infoWindow.open(map, marker);
	            });
	            marker.addListener('mouseout',function() {
	            	infoWindow.close();
	            });
	            
          	}); // end each
        }); // end getJSON
      });
    
    </script>
  </body>
</html>