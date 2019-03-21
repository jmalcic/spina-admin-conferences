(() => {
  const application = Stimulus.Application.start()

  application.register('presentation-room-uses', class extends Stimulus.Controller {
    static get targets() {
      return ['inputId', 'outputOptions']
    }

    updateOptions() {
      fetch(Routes.spina_admin_conferences_presentation_type_room_uses_path(this.inputIdTarget.value), {
        headers: { 'Accept': 'application/json' }
      })
        .then(response => response.json())
        .then(json => this.buildOptions(json))
    }

    buildOptions(roomUses) {
      console.log(roomUses)
      Array.from(this.outputOptionsTarget.options).forEach(element => element.remove())
      roomUses.forEach(roomUse => {
        this.outputOptionsTarget.options.add(new Option(roomUse.room_name, roomUse.id))
      })
      this.outputOptionsTarget.dispatchEvent(new Event('change'))
    }
  })
})()
