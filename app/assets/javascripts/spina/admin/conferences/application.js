document.addEventListener('turbo:load', (event) => {
  const customEvent = new CustomEvent('turbolinks:load', { cancelable: event.cancelable, bubbles: true, detail: event.detail })
  document.documentElement.dispatchEvent(customEvent)
})
