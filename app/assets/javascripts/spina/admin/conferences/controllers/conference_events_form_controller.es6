/* global Stimulus */

/**
 * @external Stimulus
 * @see {@link https://stimulusjs.org}
 */

/**
 * @classdesc Controller that manages conference event inputs.
 */
class ConferenceEventsFormController extends Stimulus.Controller { // eslint-disable-line no-unused-vars
  // noinspection JSUnusedGlobalSymbols
  static get targets() {
    return [
      /**
       * @private
       * @property {HTMLElement[]} formLinkTargets - The form link elements.
       */
      'formLink',
      /**
       * @private
       * @property {HTMLElement} addFormLinkTarget - The button element for adding forms.
       */
      'addFormLink',
      /**
       * @private
       * @property {HTMLElement[]} formPaneTargets - The form pane elements.
       */
      'formPane',
      /**
       * @private
       * @property {HTMLElement[]} destroyFieldTargets - The destroy field hidden inputs.
       */
      'destroyField',
      /**
       * @private
       * @property {HTMLElement[]} formLinkLabelTargets - The form link label elements.
       */
      'formLinkLabel'
    ]
  }
  // noinspection JSUnusedGlobalSymbols
  /**
   * @private
   * @property {string} activeClass - The class used to mark elements as active.
   */
  static get classes() {
    return ['active']
  }

  /**
   * Returns visible form pane targets.
   * @private
   * @return {HTMLElement[]} Form pane targets currently shown.
   */
  get visibleFormPaneTargets() {
    return this.getVisibleTargets(this.formPaneTargets)
  }

  /**
   * Returns visible form link targets.
   * @private
   * @return {HTMLElement[]} Form link targets currently shown.
   */
  get visibleFormLinkTargets() {
    return this.getVisibleTargets(this.formLinkTargets)
  }

  // noinspection JSUnusedGlobalSymbols
  /**
   * Removes the form for the button firing the event.
   * @param {Event} event - The event fired by the button.
   */
  removeForm(event) {
    if (!(event.currentTarget instanceof HTMLElement)) return
    const index = this.getIndexOfChild(this.formPaneTargets, event.currentTarget)
    const visibleIndex = this.getIndexOfChild(this.visibleFormPaneTargets, event.currentTarget)
    this.destroyFieldTargets[index].value = true.toString()
    this.hideTargetPair(index)
    if (this.visibleFormPaneTargets.length > 0) {
      let newIndex = visibleIndex <= this.visibleFormPaneTargets.length - 1 ? visibleIndex : visibleIndex - 1
      this.makeTargetPairActive(newIndex)
    }
    this.updateURL()
  }

  // noinspection JSUnusedGlobalSymbols
  /**
   * Updates the form link labels with new type.
   * @param {Event} event - The event fired by the select element.
   */
  updateType(event) {
    if (!(event.currentTarget instanceof HTMLSelectElement)) return
    const index = this.getIndexOfChild(this.formPaneTargets, event.currentTarget)
    this.formLinkLabelTargets[index].textContent = event.currentTarget.selectedOptions[0].label
  }

  /**
   * Updates the URL used to get new forms.
   */
  updateURL() {
    const params = new URLSearchParams(this.addFormLinkTarget.search)
    params.set('index', String(this.formPaneTargets.length))
    params.set('active', String(this.visibleFormPaneTargets.length === 0))
    this.addFormLinkTarget.search = params.toString()
  }

  /**
   * Hides a form pane and form link target sharing an index.
   * @private
   * @private
   * @param {Number} index - The index of the targets to hide.
   */
  hideTargetPair(index) {
    this.hide(this.formPaneTargets[index])
    this.hide(this.formLinkTargets[index])
  }

  /**
   * Marks a form pane and form link target sharing an index as active.
   * @private
   * @param {Number} index - The index of the targets to show.
   */
  makeTargetPairActive(index) {
    this.makeActive(this.visibleFormPaneTargets[index])
    this.makeActive(this.visibleFormLinkTargets[index])
  }

  /**
   * Makes an element inactive and hides it.
   * @private
   * @param {HTMLElement} element - The element.
   */
  hide(element) {
    this.makeInactive(element)
    element.hidden = true
  }

  /**
   * Makes an element inactive.
   * @private
   * @param {HTMLElement} element - The element.
   */
  makeInactive(element) {
    element.classList.remove(this.activeClass)
  }

  /**
   * Makes an element active.
   * @private
   * @param {HTMLElement} element - The element.
   */
  makeActive(element) {
    element.classList.add(this.activeClass)
  }

  /**
   * Gets the index of an element within a collection.
   * @private
   * @param {HTMLElement[]} collection
   * @param {HTMLElement} child
   */
  getIndexOfChild(collection, child) {
    return collection.indexOf(collection.find(element => element.contains(child)))
  }

  /**
   * Gets visible targets within a collection.
   * @private
   * @param {HTMLElement[]} targets
   */
  getVisibleTargets(targets) {
    return targets.filter(target => target.hidden === false)
  }
}
