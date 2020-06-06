class PresentationAttachmentsFormController extends Stimulus.Controller {
  static get targets() {
    return ['formLink', 'addFormLink', 'formPane', 'destroyField', 'formLinkLabel']
  }
  static get classes() {
    return ['active']
  }
  get visibleFormPaneTargets() {
    return this.getVisibleTargets(this.formPaneTargets)
  }
  get visibleFormLinkTargets() {
    return this.getVisibleTargets(this.formLinkTargets)
  }

  removeForm(event) {
    const index = this.getIndexOfChild(this.formPaneTargets, event.currentTarget)
    const visibleIndex = this.getIndexOfChild(this.visibleFormPaneTargets, event.currentTarget)
    this.destroyFieldTargets[index].value = true
    this.hideTargetPair(index)
    if (this.visibleFormPaneTargets.length > 0) {
      let newIndex = visibleIndex <= this.visibleFormPaneTargets.length - 1 ? visibleIndex : visibleIndex - 1
      this.makeTargetPairActive(newIndex)
    }
    this.updateURL()
  }

  updateType(event) {
    const index = this.getIndexOfChild(this.formPaneTargets, event.currentTarget)
    this.formLinkLabelTargets[index].textContent = event.currentTarget.selectedOptions[0].label
  }

  updateURL() {
    const params = new URLSearchParams(this.addFormLinkTarget.search)
    params.set('index', this.formPaneTargets.length)
    params.set('active', this.visibleFormPaneTargets.length === 0)
    this.addFormLinkTarget.search = params
  }

  hideTargetPair(index) {
    this.hide(this.formPaneTargets[index])
    this.hide(this.formLinkTargets[index])
  }

  makeTargetPairActive(index) {
    this.makeActive(this.visibleFormPaneTargets[index])
    this.makeActive(this.visibleFormLinkTargets[index])
  }

  hide(element) {
    this.makeInactive(element)
    element.hidden = true
  }

  makeInactive(element) {
    element.classList.toggle(this.activeClass)
  }

  makeActive(element) {
    element.classList.add(this.activeClass)
  }

  getIndexOfChild(collection, child) {
    return collection.indexOf(collection.find(element => element.contains(child)))
  }

  getVisibleTargets(targets) {
    return targets.filter(target => target.hidden === false)
  }
}
