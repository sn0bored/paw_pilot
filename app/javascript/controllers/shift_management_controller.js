import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"
import Turbo from "@hotwired/turbo"

export default class extends Controller {
  static targets = ["dogList"]
  static values = { shiftId: Number }

  connect() {
    this.dogListTargets.forEach(list => {
      list.addEventListener('dragover', this.allowDrop.bind(this))
      list.addEventListener('drop', this.drop.bind(this))
    })

    this.element.querySelectorAll('.dog-item').forEach(item => {
      item.addEventListener('dragstart', this.drag.bind(this))
    })
  }

  allowDrop(event) {
    event.preventDefault()
  }

  drag(event) {
    event.dataTransfer.setData("text", event.target.dataset.dogId)
  }

  async drop(event) {
    event.preventDefault()
    const dogId = event.dataTransfer.getData("text")
    const newWalkerId = event.target.closest('[data-walker-id]').dataset.walkerId

    try {
      const response = await patch(`/shifts/${this.shiftIdValue}/reassign_dog`, {
        body: JSON.stringify({ dog_id: dogId, new_walker_id: newWalkerId }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html", // Changed from application/json
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (!response.ok) {
        throw new Error('Network response was not ok')
      }

      const html = await response.text()
      Turbo.renderStreamMessage(html)
    } catch (error) {
      console.error("An error occurred:", error)
      // Handle network errors or other exceptions
    }
  }
}