import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "item", "none"]

  filter() {
    const query = this.queryTarget.value.trim().toLowerCase()
    this.itemTargets.forEach((item) => (item.hidden = !item.textContent.toLowerCase().includes(query)))
    this.noneTarget.hidden = this.itemTargets.some((item) => !item.hidden)
  }
}
