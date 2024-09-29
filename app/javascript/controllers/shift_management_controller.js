import { Controller } from "@hotwired/stimulus"
import { patch } from "@rails/request.js"

export default class extends Controller {
  static targets = ["dogList", "availableDogsList"]
  static values = { shiftId: Number }
  static classes = ["activeDropzone", "activeItem", "dropTarget"]

  connect() {
    this.dogListTargets.forEach(list => {
      list.addEventListener('dragover', this.allowDrop.bind(this))
      list.addEventListener('drop', this.drop.bind(this))
    })

    this.availableDogsListTarget.addEventListener('dragover', this.allowDrop.bind(this))
    this.availableDogsListTarget.addEventListener('drop', this.dropToAvailable.bind(this))

    this.element.querySelectorAll('.dog-item').forEach(item => {
      item.addEventListener('dragstart', this.dragstart.bind(this))
      item.addEventListener('dragend', this.dragend.bind(this))
    })
  }

  allowDrop(event) {
    event.preventDefault()
  }

  dragstart(event) {
    this.element.classList.add(...this.activeDropzoneClasses)
    event.target.classList.add(...this.activeItemClasses)
    event.dataTransfer.setData("text/plain", event.target.dataset.dogId)
    event.dataTransfer.effectAllowed = "move"
  }

  dragend(event) {
    this.element.classList.remove(...this.activeDropzoneClasses)
    event.target.classList.remove(...this.activeItemClasses)
  }

  dragenter(event) {
    const dropTarget = event.target.closest('[data-walker-id]')
    if (dropTarget) {
      dropTarget.classList.add(...this.dropTargetClasses)
    }
  }

  dragleave(event) {
    const dropTarget = event.target.closest('[data-walker-id]')
    if (dropTarget) {
      dropTarget.classList.remove(...this.dropTargetClasses)
    }
  }

  async drop(event) {
    event.preventDefault()
    const dogId = event.dataTransfer.getData("text/plain")
    const newWalkerId = event.target.closest('[data-walker-id]').dataset.walkerId

    const dropTarget = event.target.closest('[data-walker-id]')
    if (dropTarget) {
      dropTarget.classList.remove(...this.dropTargetClasses)
    }

    try {
      const response = await patch(`/shifts/${this.shiftIdValue}/reassign_dog`, {
        body: JSON.stringify({ dog_id: dogId, new_walker_id: newWalkerId }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (!response.response.ok) {
        throw new Error('Network response was not ok')
      }
      
      // Move the dog item to the new walker's list
      const dogItem = this.element.querySelector(`[data-dog-id="${dogId}"]`)
      
      // Update the dog item's appearance
      dogItem.classList.remove('bg-green-100')
      dogItem.classList.add('bg-blue-100', 'mb-2')
            
      // Append the dog item to the drop target
      dropTarget.appendChild(dogItem)
    } catch (error) {
      console.error("An error occurred:", error)
      // Handle errors (e.g., show an error message to the user)
    }
  }

  async dropToAvailable(event) {
    event.preventDefault()
    const dogId = event.dataTransfer.getData("text/plain")

    try {
      const response = await patch(`/shifts/${this.shiftIdValue}/unassign_dog`, {
        body: JSON.stringify({ dog_id: dogId }),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (!response.response.ok) {
        throw new Error('Network response was not ok')
      }

      console.log("Dog unassigned successfully")
      
      // Move the dog item to the available dogs list
      const dogItem = this.element.querySelector(`[data-dog-id="${dogId}"]`)
      this.availableDogsListTarget.appendChild(dogItem)

    } catch (error) {
      console.error("An error occurred:", error)
      // Handle errors (e.g., show an error message to the user)
    }
  }
}