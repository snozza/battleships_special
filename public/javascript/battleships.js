$(document).ready(function() {

  $('.left').on('click', 'td', function() {
    console.log($(this).index());
    console.log($(this).parent('tr').index());
    $.post('/deploy', {
      ycoord: $(this).index(),
      xcoord: $(this).parent('tr').index(),
      direction: "R"
    });
  });
});

