//= require ./exports
//= require stimulus
//= require_directory ./controllers

const application = Stimulus.Application.start()
application.register('itemnav', exports.ItemnavController)
application.register('slideshow', exports.SlideshowController)
application.register('underlinenav', exports.ItemnavController)
