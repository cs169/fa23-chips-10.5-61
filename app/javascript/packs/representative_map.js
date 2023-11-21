$(document).ready(function () {
  $('#county_map').on('click', '.county', function () {
    var countyName = $(this).data('county-name');
    $.ajax({
      url: '/search',
      method: 'GET',
      data: { county: countyName },
      success: function (data) {
        $('#representatives-container').html(data);
      },
      error: function (error) {
        console.error('Error:', error);
      }
    });
  });
});
