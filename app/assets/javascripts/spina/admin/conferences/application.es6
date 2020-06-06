//= require stimulus
//= require_directory ./controllers

const application = Stimulus.Application.start()
application.register('select-options', SelectOptionsController)
application.register('presentation-attachments-form', PresentationAttachmentsFormController)

document.addEventListener('turbolinks:load', () => {
  Array.from(document.getElementsByClassName('conference-datepicker')).forEach(element => {
    $(element).datepicker({
      dateFormat: 'yy-mm-dd',
      firstDay: 1
    })
  })
})
