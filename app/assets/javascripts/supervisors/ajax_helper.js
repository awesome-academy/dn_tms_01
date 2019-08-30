
$('.btn-load-modal').click(function(){
  let id = $(this).attr('data-id');
  $('#btn-delete').attr('data-id', id)

});

$('#btn-delete').click(function () {
  let id = $(this).attr('data-id');
  let url = window.location.origin + '/supervisors/courses/' + id;
  $.ajax({
    method: 'DELETE',
    dataType: 'json',
    url,
    success: function (data) {
      $('#data-row-id-' + id).remove();
      $('#myModal').modal('hide');
      $('#showmsg').append('<div class="alert alert-'+ data.cls + '">'
        +data.msg+'</div>');
    },
  });
});
