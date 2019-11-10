//= require ./exports
//= require stimulus
//= require_directory ./controllers

const application = Stimulus.Application.start()
application.register('select-options', exports.SelectOptionsController)
