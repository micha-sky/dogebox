# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
do (main = (window.main = window.main || {}), $ = jQuery) ->
  _map = null

  initialize = () ->
    mapOptions =
      center: new google.maps.LatLng(-34.397, 150.644)
      zoom: 12
    _map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)
    return

  google.maps.event.addDomListener(window, 'load', initialize)
return