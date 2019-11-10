export class SelectOptionsController extends Stimulus.Controller {
  static get targets() {
    return ['select']
  }
  static get values() {
    return {
      records: Array,
      filteredData: Object,
      route: String,
      optionsConfig: Object
    }
  }

  connect() {
    this.fetchJSON()
  }

  fetchJSON() {
    const url = new URL(this.routeValue, document.URL)
    fetch(url.toString(), { headers: { 'Accept': 'application/json' } })
      .then(response => response.json())
      .then(json => this.recordsValues = json)
  }

  filteredDataValueChanged() {
    if (!this.hasFilteredDataValue) return

    this.selectTargets.forEach(target => {
      const optionsConfig = this.optionsConfigValue[target.id]
      if (optionsConfig.trigger !== undefined) {
        if (this.filteredDataValue[optionsConfig.trigger] === undefined) target.disabled = true
        else this.updateOptions(target, this.filteredDataValue[optionsConfig.trigger][optionsConfig.key], optionsConfig)
      }
    })
  }

  updateOptions(target, newData, optionsConfig) {
    target.disabled = false
    if (this.hasStaleOptions(target, newData)) {
      this.removeOptions(target)
      this.buildOptions(target, newData, optionsConfig)
    }
  }

  hasStaleOptions(target, newData) {
    const targetOptions = this.getNonEmptyOptions(target).map(option => (new Option(option.text, option.value)))
    const newOptions = newData.map(record => this.generateOption(record, this.optionsConfigValue[target.id]))
    return !targetOptions.some((option, index) => option.isEqualNode(newOptions[index]))
  }

  getNonEmptyOptions(target) {
    return Array.from(target.options).filter(element => element.value !== '')
  }

  generateOption(record, optionsConfig) {
    return new Option(record[optionsConfig.text], record[optionsConfig.value])
  }

  removeOptions(target) {
    this.getNonEmptyOptions(target).forEach(element => element.remove())
  }

  buildOptions(target, records, optionsConfig) {
    records.forEach(record => target.options.add(this.generateOption(record, optionsConfig)))
  }

  updateFilteredData(event) {
    let filteredData = this.filteredDataValue
    const optionsConfig = this.optionsConfigValue[event.target.id]
    let data = optionsConfig.trigger !== undefined ? filteredData : this.recordsValues
    filteredData[event.target.id] = this.filterItemsByValue(data, event.target.value, optionsConfig)
    this.filteredDataValue = filteredData
  }

  filterItemsByValue(items, value, optionsConfig) {
    if (optionsConfig.trigger !== undefined) items = items[optionsConfig.trigger][optionsConfig.key]
    return items.find(item => item[optionsConfig.value].toString() === value)
  }
}
