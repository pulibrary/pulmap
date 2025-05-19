$(document).ready(function () {
  // Auto dismiss alert-info
  setTimeout(function () {
    $('.alert-info').fadeOut('slow', function () {
      $('.alert-info').remove()
    })
  }, 3000)
})
