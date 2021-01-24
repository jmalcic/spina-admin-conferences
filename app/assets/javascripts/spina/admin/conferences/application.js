document.addEventListener('turbolinks:load', () => {
  Array.from(document.getElementsByClassName('conference-datepicker')).forEach(element => {
    $(element).datepicker({
      dateFormat: 'yy-mm-dd',
      firstDay: 1
    })
  })
})
