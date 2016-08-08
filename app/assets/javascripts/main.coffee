do (main = (window.main = window.main || {}), $ = jQuery) ->
  _map = null
  _markers = []
  _loading = null
  _timeout = 500
  _current_location = null

  initialize = () ->
    mapOptions =
      center: city
      zoom: zoom
    _map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)
    getLocation()

    return

  google.maps.event.addDomListener(window, 'load', initialize)

  getLocation = () ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(showPosition)
    else
      console.log('err')

  showPosition = (position) ->
    latLng =
      lat: position.coords.latitude
      lng: position.coords.longitude

    _current_location = latLng

    marker = new google.maps.Marker(
      position: latLng
      map: _map
      title: 'You are here'
    )

    _map.setCenter(latLng)

  $('#create-meal-dialog').dialog
    autoOpen: false
    height: 300
    width: 600
    modal: true
    buttons:
      'Create': ()->
        name = $('#name').val()
        latitude = _current_location.latitude
        longitude = _current_location.longitude


        $(this).dialog('close')
        true
      'Cancel': ()->
        $(this).dialog('close')
        false

  $('#create-meal-button')



  setMapCenterAndZoom = () ->
    bounds = getBoundsForMarkers()
    northEast = bounds.getNorthEast()
    southWest = bounds.getSouthWest()
    oneMarkerOnly = northEast.lat() == southWest.lat() and northEast.lng() == southWest.lng()

    if (oneMarkerOnly)
      _map.setCenter(bounds.getCenter())
      _map.setZoom(16)
    else
      _map.fitBounds(bounds)

    return


  return