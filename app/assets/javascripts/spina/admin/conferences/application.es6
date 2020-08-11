//= require stimulus
//= require_directory ./controllers

/**
 * @external Stimulus
 */
/* global Stimulus, SelectOptionsController, PresentationAttachmentsFormController, ConferenceEventsFormController */
const application = Stimulus.Application.start()
application.register('select-options', SelectOptionsController)
application.register('presentation-attachments-form', PresentationAttachmentsFormController)
application.register('conference-events-form', ConferenceEventsFormController)

document.addEventListener('turbolinks:load', () => {
  Array.from(document.getElementsByClassName('conference-datepicker')).forEach(element => {
    $(element).datepicker({
      dateFormat: 'yy-mm-dd',
      firstDay: 1
    })
  })
})
