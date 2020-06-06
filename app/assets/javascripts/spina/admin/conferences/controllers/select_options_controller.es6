class SelectOptionsController extends Stimulus.Controller {
  static get targets() {
    return ['select']
  }
  static get values() {
    return {
      record: Array,
    }
  }

  connect() {
    this.selectTargets.forEach(target => target.dispatchEvent(new Event('change')))
  }

  recordValuesChanged() {
    this.selectTargets.forEach(target => this.updateOptions(target))
  }

  setVisibility(event) {
    const target = event.target
    const recordFilter = new RecordFilter(this.recordValues, target)
    this.recordValues = recordFilter.setVisibility()
  }

  // Private methods

  updateOptions(target) {
    let newRecords = this.recordValues
    if ('keyPath' in target.dataset) {
      const keyPath = new KeyPath(target.dataset.keyPath)
      newRecords = keyPath.visibleObjectsAtKeyPath(newRecords)
    }
    const textKey = target.dataset.textKey
    if (!('valueKey' in target.dataset)) target.dataset.valueKey = 'id'
    const valueKey = target.dataset.valueKey
    const newOptions = newRecords.map(record => new Option(record[textKey], record[valueKey] ))
    const oldOptions = Array.from(target.options).filter(option => option.value !== '')
    oldOptions.filter(option => !newOptions.some(newOption => newOption.value === option.value))
      .forEach(option => target.remove(option.index))
    newOptions.filter(newOption => !oldOptions.some(option => option.value === newOption.value)).forEach(option => target.add(option))
  }
}

class KeyPath {
  constructor(string) {
    if (typeof string !== 'string') throw TypeError(`${string} is not a string`)
    this.segments = string.split(':')
  }

  forEach(callbackFn) {
    this.segments.forEach(callbackFn)
  }

  traverseObject(object, filter = false) {
    let objectSubpart = object
    this.segments.forEach(key => {
      switch (objectSubpart.constructor) {
      case Array:
        if (filter) objectSubpart = objectSubpart.filter(object => object.visible === true)
        objectSubpart = objectSubpart.flatMap(object => object[key])
        break
      case String:
      case Number:
      case Boolean:
        break
      case Object:
        objectSubpart = objectSubpart[key]
        break
      }
    })
    return objectSubpart ? objectSubpart : []
  }

  visibleObjectsAtKeyPath(object) {
    return this.traverseObject(object, true)
  }

  objectsAtKeyPath(object) {
    return this.traverseObject(object)
  }
}

class RecordFilter {
  get records() {
    return this.keyPath ? this.keyPath.objectsAtKeyPath(this.rawRecords) : this.rawRecords
  }

  constructor(rawRecords, target) {
    this.rawRecords = Array.from(rawRecords)
    if ('keyPath' in target.dataset) this.keyPath = new KeyPath(target.dataset.keyPath)
    if (!('valueKey' in target.dataset)) target.dataset.valueKey = 'id'
    this.valueKey = target.dataset.valueKey
    this.targetValue = target.value
  }

  setVisibility() {
    this.records.forEach(record => record.visible = record[this.valueKey].toString() === this.targetValue)
    return this.rawRecords
  }
}
