// Add button to get current position
$(document).ready(function() {
  var lonlat = $('#location_lonlat');
  $('#get_device_pos')
    .removeClass('d-none')
    .click(function() { getPos(lonlat); });
  // FIXME: Add callback/button to read coords from exif of image
});

// Get current position of device
function getPos(lonlat_field) {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      lonlat_field
        .val(position.coords.latitude + ', ' + position.coords.longitude)
    });
  }
};
