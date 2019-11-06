// FIXME: This works due to:
// https://stackoverflow.com/a/49581029

global.moment = require('moment');
require('tempusdominus-bootstrap-4');
import 'tempusdominus-bootstrap-4/src/sass/tempusdominus-bootstrap-4-build';
import 'moment-timezone';
import modernizr from 'modernizr';

if (!modernizr.inputtypes['datetime-local']) {
  // Use TempusDominusDatetimePicker
  $.fn
    .datetimepicker
    .Constructor
    .Default = $.extend({}, $.fn.datetimepicker.Constructor.Default, {
      icons: {
        time: 'fas fa-clock',
        date: 'fas fa-calendar',
        up: 'fas fa-arrow-up',
        down: 'fas fa-arrow-down',
        previous: 'fas fa-chevron-left',
        next: 'fas fa-chevron-right',
        today: 'fas fa-calendar-check-o',
        clear: 'fas fa-trash',
        close: 'fas fa-times',
      },
      // FIXME: Dates after year 9999 are not shown in datetimepicker
      // locale is set via `data-locale` attr in body tag 
      // in views/layouts/application.html.erb
      format: 'YYYY-MM-DD HH:mm',
      locale: $('body').data('locale') || 'de'
    });

  // start date
  // add classes and target
  $('#fact_start_date')
    .addClass('datetimpicker-input')
    .data("target", "#datetimepicker_start_date");

  // div is not rendered by using class 'd-none' - use js to make it visible
  $('#datetimepicker_start_date_picker').removeClass('d-none');

  $(function () {
    $('#datetimepicker_start_date')
      .datetimepicker({
        date: $('#fact_start_date').val()
      });
    $('#datetimepicker_start_date')
      .on('change.datetimepicker', function(e) {
        $('#datetimepicker_end_date').datetimepicker('minDate', e.date);
      });
  });

  // end date
  // add classes and target
  $('#fact_end_date')
    .addClass('datetimpicker-input')
    .data("target", "#datetimepicker_end_date");

  // div is not rendered by using class 'd-none' - use js to make it visible
  $('#datetimepicker_end_date_picker').removeClass('d-none');

  $(function () { $('#datetimepicker_end_date')
      .datetimepicker({
        date: $('#fact_end_date').val(),
        useCurrent: false
      });
    $('#datetimepicker_end_date')
      .on('change.datetimepicker', function(e) {
        $('#datetimepicker_start_date').datetimepicker('maxDate', e.date);
      });
  });

} // else {
// Use native input type datetime-local
// }
