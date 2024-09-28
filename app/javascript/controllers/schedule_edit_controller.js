import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form", "status"]

  connect() {
    // Add event listener for form submission
    this.formTarget.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  disconnect() {
    // Remove event listener when controller is disconnected
    this.formTarget.removeEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  showForm() {
    this.formTarget.classList.remove("hidden")
    this.displayTarget.classList.add("hidden")
  }

  hideForm() {
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.hideForm()
    }
  }
}