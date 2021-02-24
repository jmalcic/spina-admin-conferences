document.addEventListener('turbolinks:load', () => {
  Array.from(document.getElementsByClassName('conference-datepicker')).forEach(element => {
    $(element).datepicker({
      dateFormat: 'yy-mm-dd',
      firstDay: 1
    })
  })
})

document.addEventListener('turbo:load', (event) => {
  const customEvent = new CustomEvent('turbolinks:load', { cancelable: event.cancelable, bubbles: true, detail: event.detail })
  document.documentElement.dispatchEvent(customEvent)
})
