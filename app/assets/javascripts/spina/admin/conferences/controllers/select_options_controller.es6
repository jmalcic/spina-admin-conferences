export class SelectOptionsController extends Stimulus.Controller {
  static get targets() {
    return ['select']
  }
  static get values() {
    return {
      records: Array,
      filteredData: Object,
      config: Object
    }
  }

  filteredDataValueChanged() {
    if (!this.hasFilteredDataValue) return

    this.selectTargets.forEach(target => {
      const config = this.configValue[target.id]
      if (config.trigger !== undefined) {
        if (this.filteredDataValue[config.trigger] === undefined) target.disabled = true
        else this.updateOptions(target, this.filteredDataValue[config.trigger][config.key], config)
      }
    })
  }

  updateOptions(target, newData, config) {
    target.disabled = false
    if (this.hasStaleOptions(target, newData)) {
      this.removeOptions(target)
      this.buildOptions(target, newData, config)
    }
  }

  hasStaleOptions(target, newData) {
    const targetOptions = this.getNonEmptyOptions(target).map(option => (new Option(option.text, option.value)))
    const newOptions = newData.map(record => this.generateOption(record, this.configValue[target.id]))
    return !targetOptions.some((option, index) => option.isEqualNode(newOptions[index]))
  }

  getNonEmptyOptions(target) {
    return Array.from(target.options).filter(element => element.value !== '')
  }

  generateOption(record, config) {
    return new Option(record[config.text], record[config.value])
  }

  removeOptions(target) {
    this.getNonEmptyOptions(target).forEach(element => element.remove())
  }

  buildOptions(target, records, config) {
    records.forEach(record => target.options.add(this.generateOption(record, config)))
  }

  updateFilteredData(event) {
    let filteredData = this.filteredDataValue
    const config = this.configValue[event.target.id]
    let data = config.trigger !== undefined ? filteredData : this.recordsValues
    filteredData[event.target.id] = this.filterItemsByValue(data, event.target.value, config)
    this.filteredDataValue = filteredData
  }

  filterItemsByValue(items, value, config) {
    if (config.trigger !== undefined) items = items[config.trigger][config.key]
    return items.find(item => item[config.value].toString() === value)
  }
}
