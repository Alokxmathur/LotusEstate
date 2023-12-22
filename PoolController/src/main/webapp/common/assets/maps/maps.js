var googleMapsApi = googleMapsApi || {};
var mapsArray = new Array();
 
googleMapsApi.showMaps = function () {
  var createMap = function (mapDiv, latitude, longitude, title) {
  	var coordinates = new google.maps.LatLng(latitude, longitude);
	var mapOptions = {
	      center: coordinates,
	      mapTypeId: google.maps.MapTypeId.ROADMAP,
	      zoom: 11
	}; 
	var map = new google.maps.Map(mapDiv, mapOptions);
	var marker = new google.maps.Marker({
	    position: coordinates,
	    map: map,
	    visible: true,
	    title: title
	});
	mapsArray.push({marker:marker, map:map});
	return map;
  };
  $( ".visitMap" ).each(function() {
	var id = $(this).attr('id');
	var latitude = $("#Latitude_" + id).val();
	var longitude = $("#Longitude_" + id).val();
	var title = $("#Title_" + id).val();

    if (latitude != "0" && longitude != "0") {
    	createMap(this, latitude, longitude, title);
    	console.log("Created map for " + latitude + ":" + longitude + ", title:" + title);
    }
  });
};
googleMapsApi.resizeMaps = function() {
  var index = 0;
  while (index < mapsArray.length) {
	  google.maps.event.trigger(mapsArray[index].map, "resize");	
	  mapsArray[index].map.setZoom( mapsArray[index].map.getZoom() );        //force redrawn
	  mapsArray[index].map.setCenter(mapsArray[index].marker.getPosition()); //recenter on marker  
	  index++;
  }
};