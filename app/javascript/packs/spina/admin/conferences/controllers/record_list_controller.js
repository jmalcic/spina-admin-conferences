import { Controller } from 'stimulus'

export class RecordListController extends Controller {
  static targets = ['inputId', 'outputOptions']

  updateOptions() {
    fetch(this.route(this.inputIdTarget.value), {
      headers: { 'Accept': 'application/json' }
    })
      .then(response => response.json())
      .then(json => this.buildOptions(json))
  }

  buildOptions(records) {
    Array.from(this.outputOptionsTarget.options).forEach(element => element.remove())
    records.forEach(record => {
      this.outputOptionsTarget.options.add(new Option(record[this.optionLabel], record.id))
    })
    this.outputOptionsTarget.dispatchEvent(new Event('change'))
  }
}
