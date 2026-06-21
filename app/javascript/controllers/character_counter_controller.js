import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static targets = ["input", "output"]

  connect() {
    this.update()
  }

  update() {
    const count = this.inputTarget.value.length
    this.outputTarget.textContent = `${count} characters`
  }
}
