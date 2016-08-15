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
    getMeals()

    return

  google.maps.event.addDomListener(window, 'load', initialize)

  getLocation = () ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(showPosition)
    else
      console.log('Cannot determine location')

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
#        if !_current_location
#          alert 'specify location'
        latitude = _current_location.latitude
        longitude = _current_location.longitude
        description = $('#description').val()
        createMeal(name, 'bla', latitude, longitude)

        $(this).dialog('close')
        true
      'Cancel': ()->
        $(this).dialog('close')
        false

  createMeal = (name, description, latitude, longitude) ->
    $.ajax
      url: new_meal_path
      type: 'get'
      data:
        name: name
        description: description
        latitude: latitude
        longitude: longitude
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(textStatus)
      success: (data) ->
        console.log(data)
        return
    true

  getMeals = () ->
    $.ajax
      url: meals_show_path
      type: 'get'
      success: (points) ->
        for point in points
          latLng = new google.maps.LatLng(point.latitude, point.longitude)
          marker = new google.maps.Marker(
            position: latLng,
            map: _map
          )
          marker.addListener 'click', () ->
            infowindow = buildInfoWindow(point)
            infowindow.open(_map, this)
          _markers.push(marker)
          setMapCenterAndZoom()
      error: (data) ->
        console.log(data)
    return

  clearAllMarkers = () ->
    marker.setMap(null) for marker in _markers
    _markers = []
    false

  buildInfoWindow = (point) ->
    contentString = '<div><b>Name: ' + point.name +
      '</b></div>' + '<div><b>Description: ' + point.description + '</div>'

    infoWindow = new google.maps.InfoWindow(content: contentString)


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

  getBoundsForMarkers = () ->
    bounds = new google.maps.LatLngBounds()
    for marker in _markers
      bounds.extend(marker.position)
    bounds



  $('#create-meal-button').click ()->
    BootstrapDialog.show(
      title: 'Create new meal'
      message: [
        $('<input id="name" class="form-control">'),
        $('<input id="description" class="form-control">')
      ]
      buttons:[
        {
          label: 'Save'
          hotKey: 13
          action: () ->
            name = $('#name').val()
            latitude = _current_location.lat
            longitude = _current_location.lng
            description = $('#description').val()
            createMeal(name, description, latitude, longitude)
            dialogRef.close()
        },
        label: 'Cancel'
        action: () ->
          dialogRef.close()
      ]
    )
    false

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