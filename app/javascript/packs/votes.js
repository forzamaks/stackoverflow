$(document).on('turbolinks:load',function(){
    $('.btn-vote').on('ajax:success', function(e) {
      console.log(e.detail)
      var votesResult = e.detail[0];

      $('.vote-result[data-vote-id="'+votesResult.name+'-'+votesResult.id+'"]').text(votesResult.rating);
  })
  .on('ajax:error', function(e) {
    var errors = e.detail[0];
    $.each(errors, function(index, value) {
      $('.question').prepend('<div class="alert alert-danger">'+value+'</div>')
    })
    
  })
})