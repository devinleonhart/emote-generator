import { Controller } from "@hotwired/stimulus"

const KINDS = ["head", "eyebrows", "eyes", "mouth"]

// Shows the emote of the chosen parts, once there is one of each kind.
export default class extends Controller {
  static targets = ["part", "image", "empty", "copy"]
  static values = { character: String, path: String }

  connect() {
    this.draw()
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  draw() {
    const chosen = this.partTargets.filter((part) => part.checked)
    const complete = KINDS.every((kind) => chosen.some((part) => part.name === kind))
    if (complete) this.imageTarget.src = this.url(chosen)
    this.imageTarget.hidden = !complete
    this.emptyTarget.hidden = complete
    this.copyTarget.disabled = !complete
  }

  url(chosen) {
    const query = new URLSearchParams({ character: this.characterValue })
    KINDS.forEach((kind) => query.set(kind, chosen.find((part) => part.name === kind).value))
    return new URL(`${this.pathValue}?${query}`, window.location.origin).href
  }

  async copy() {
    await navigator.clipboard.writeText(this.imageTarget.src)
    this.copyTarget.textContent = "Copied!"
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => (this.copyTarget.textContent = "Copy URL"), 2000)
  }
}
