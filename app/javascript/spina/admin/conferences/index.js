import { Application } from 'stimulus'
import * as Controllers from './controllers'

const application = Application.start()
application.register('presentation-presentation-types', Controllers.PresentationPresentationTypesController)
application.register('presentation-room-uses', Controllers.PresentationRoomUsesController)
