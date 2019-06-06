import { Controller } from 'stimulus'
import Routes from '../../../../../routes.js.erb'

export default class extends Controller {
  static targets = ['inputId', 'outputOptions']

  updateOptions() {
    fetch(Routes.spina_admin_conferences_presentation_type_room_uses_path(this.inputIdTarget.value), {
      headers: { 'Accept': 'application/json' }
    })
      .then(response => response.json())
      .then(json => this.buildOptions(json))
  }

  buildOptions(roomUses) {
    Array.from(this.outputOptionsTarget.options).forEach(element => element.remove())
    roomUses.forEach(roomUse => {
      this.outputOptionsTarget.options.add(new Option(roomUse.room_name, roomUse.id))
    })
    this.outputOptionsTarget.dispatchEvent(new Event('change'))
  }
}
