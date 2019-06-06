import { Controller } from 'stimulus'
import Routes from '../../../../../routes.js.erb'

export default class extends Controller {
  static targets = ['inputId', 'outputOptions']

  updateOptions() {
    fetch(Routes.spina_admin_conferences_conference_presentation_types_path(this.inputIdTarget.value), {
      headers: { 'Accept': 'application/json' }
    })
      .then(response => response.json())
      .then(json => this.buildOptions(json))
  }

  buildOptions(presentationTypes) {
    Array.from(this.outputOptionsTarget.options).forEach(element => element.remove())
    presentationTypes.forEach(presentationType => {
      this.outputOptionsTarget.options.add(new Option(presentationType.name, presentationType.id))
    })
    this.outputOptionsTarget.dispatchEvent(new Event('change'))
  }
}
