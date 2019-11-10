//= require ./exports
//= require stimulus
//= require_directory ./controllers

const application = Stimulus.Application.start()
application.register('select-options', exports.SelectOptionsController)

document.addEventListener('DOMContentLoaded', () => {
  Array.from(document.getElementsByClassName('conference-datepicker')).forEach(element => {
    $(element).datepicker({
      dateFormat: 'yy-mm-dd',
      firstDay: 1
    })
  })
})
