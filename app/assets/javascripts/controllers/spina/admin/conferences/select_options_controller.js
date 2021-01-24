/**
 * @external Controller
 * @see {@link https://stimulusjs.org}
 */
import { Controller } from 'stimulus'

/**
 * @classdesc Controller that links related select elements.
 */
export default class SelectOptionsController extends Controller {
  // noinspection JSUnusedGlobalSymbols
  static get targets() {
    return [
      /**
       * @private
       * @property {HTMLElement[]} selectTargets - The select elements.
       */
      'select'
    ]
  }
  // noinspection JSUnusedGlobalSymbols
  static get values() {
    return {
      /**
       * @private
       * @property {Array} recordValue - The record values.
       */
      record: Array,
    }
  }

  // noinspection JSUnusedGlobalSymbols
  /**
   * Hook to ensure that the initial value of each select element is used to set visibility of the corresponding records.
   * @private
   */
  connect() {
    this.selectTargets.forEach(target => target.dispatchEvent(new Event('change')))
  }

  // noinspection JSUnusedGlobalSymbols
  /**
   * Hook to update select targets when record values change.
   * @private
   */
  recordValueChanged() {
    this.selectTargets.forEach(target => {
      if (!(target instanceof HTMLSelectElement)) return
      this.updateOptions(target)
    })
  }

  // noinspection JSUnusedGlobalSymbols
  /**
   * Updates the visibility of records according to the selected option of a select element.
   * @param {Event} event - The event fired by the select element.
   */
  setVisibility(event) {
    const target = event.currentTarget
    if (!(target instanceof HTMLSelectElement)) return
    const recordFilter = new SelectOptionsController.RecordFilter(this.recordValue, target)
    this.recordValue = recordFilter.setVisibility()
  }

  /**
   * Updates the options of a select element.
   * @private
   * @param {HTMLSelectElement} target - The select element to update the options of.
   */
  updateOptions(target) {
    let newRecords = this.recordValue
    if ('keyPath' in target.dataset) {
      const keyPath = new SelectOptionsController.KeyPath(target.dataset.keyPath)
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

/**
 * @private
 * @classdesc A series of property keys, used to traverse objects. A parent object or array of objects is recursively mapped to child
 * objects identified by each property key.
 */
SelectOptionsController.KeyPath = class {
  /**
   * Creates a new key path.
   * @private
   * @constructor
   * @param {String} string - The string used to create the key path. Should be in the format 'segment:segment:segment'.
   */
  constructor(string) {
    if (typeof string !== 'string') throw TypeError(`${string} is not a string`)
    /**
     * @property {string[]} segments - The segments of the key path.
     */
    this.segments = string.split(':')
  }

  /**
   * Traverses an object or array of objects by recursively mapping objects to the objects identified by the series of key path segments.
   * @private
   * @param {Object|Object[]} object - The object or array of objects to be traversed.
   * @param {Boolean} filter - Whether, when encountering an array within the top-level object or array,
   * elements marked as invisible should be ignored.
   * @return Any
   */
  traverseObject(object, filter = false) {
    let childObject = object
    this.segments.forEach(key => {
      switch (childObject.constructor) {
      case Array:
        if (filter) childObject = childObject.filter(object => object.hidden !== true)
        childObject = childObject.flatMap(object => object[key])
        break
      case String:
      case Number:
      case Boolean:
        break
      case Object:
        childObject = childObject[key]
        break
      }
    })
    return childObject ? childObject : []
  }

  /**
   * Traverses an object or array of objects by recursively mapping objects to the objects identified by the series of key path segments.
   * When encountering an array within the top-level object or array, elements marked as invisible are ignored.
   * @private
   * @param {Object|Object[]} object - The object or array of objects to be traversed.
   * @return Any
   */
  visibleObjectsAtKeyPath(object) {
    return this.traverseObject(object, true)
  }

  /**
   * Traverses an object or array of objects by recursively mapping objects to the objects identified by the series of key path segments.
   * @private
   * @param {Object|Object[]} object - The object or array of objects to be traversed.
   * @return Any
   */
  objectsAtKeyPath(object) {
    return this.traverseObject(object)
  }
}

/**
 * @private
 * @classdesc Identifies a set of records presented as options by a select element target within a possibly larger set of records.
 * The visibility of each target record can be set by comparing the value of the target to the value of some property of each target record.
 */
SelectOptionsController.RecordFilter = class {
  /**
   * @private
   * @property {Object[]} targetRecords - If a key path exists, the records within the raw records identified by the key path.
   * Else the raw records.
   */
  get targetRecords() {
    return this.keyPath ? this.keyPath.objectsAtKeyPath(this.rawRecords) : this.rawRecords
  }

  /**
   * Creates a new record filter.
   * @private
   * @constructor
   * @param {Object[]} rawRecords - The records to be filtered.
   * @param {HTMLSelectElement} target - The target providing the value.
   * @param {String} [target.dataset.keyPath] - The key path.
   * @param {String} [target.dataset.valueKey=id] - The value key.
   */
  constructor(rawRecords, target) {
    /**
     * @private
     * @property {Object[]} rawRecords - The entire set of records.
     */
    this.rawRecords = Array.from(rawRecords)
    if ('keyPath' in target.dataset) {
      /**
       * @private
       * @property {KeyPath} [keyPath] - The key path used to filter records.
       */
      this.keyPath = new SelectOptionsController.KeyPath(target.dataset.keyPath)
    } 
    if (!('valueKey' in target.dataset)) target.dataset.valueKey = 'id'
    /**
     * @private
     * @property {String} valueKey - The property of the target records to be compared to the target value.
     */
    this.valueKey = target.dataset.valueKey
    /**
     * @private
     * @property {String} targetValue - The value of the target.
     */
    this.targetValue = target.value
  }

  /**
   * Marks the target record whose property value matches the value of the target as visible and others as invisible.
   * @returns {Object[]} The raw records, with the target records marked for visibility.
   */
  setVisibility() {
    this.targetRecords.forEach(record => record.hidden = record[this.valueKey].toString() !== this.targetValue)
    return this.rawRecords
  }
}
