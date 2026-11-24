import { Controller } from "@hotwired/stimulus"

// A list of links that opens below a field, and that typing in the field filters.
export default class extends Controller {
  static targets = ["input", "menu", "option", "none"]

  connect() {
    this.name = this.inputTarget.value
  }

  open() {
    if (!this.menuTarget.hidden) return

    this.inputTarget.select()
    this.show("")
  }

  filter() {
    this.show(this.inputTarget.value.trim().toLowerCase())
  }

  show(query) {
    this.optionTargets.forEach((option) => (option.hidden = !option.textContent.toLowerCase().includes(query)))
    this.noneTarget.hidden = this.shown.length > 0
    this.menuTarget.hidden = false
    this.inputTarget.setAttribute("aria-expanded", "true")
    this.activate(query ? this.shown[0] : this.shown.find((option) => option.ariaSelected === "true"))
  }

  close() {
    this.menuTarget.hidden = true
    this.inputTarget.value = this.name
    this.inputTarget.setAttribute("aria-expanded", "false")
    this.activate(null)
  }

  closeOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  // Tab leaves; a click on an option takes the focus only for a moment.
  leave(event) {
    if (event.relatedTarget && !this.element.contains(event.relatedTarget)) this.close()
  }

  key(event) {
    const open = !this.menuTarget.hidden
    if (event.key === "Escape") this.close()
    else if (event.key === "Enter" && open) this.active?.click()
    else if (event.key === "ArrowDown") open ? this.move(1) : this.open()
    else if (event.key === "ArrowUp") open ? this.move(-1) : this.open()
    else return

    event.preventDefault()
  }

  move(step) {
    const shown = this.shown
    const index = shown.indexOf(this.active) + step
    this.activate(shown[Math.max(0, Math.min(index, shown.length - 1))])
  }

  activate(option) {
    this.active = option
    this.optionTargets.forEach((one) => one.toggleAttribute("data-active", one === option))
    option ? this.inputTarget.setAttribute("aria-activedescendant", option.id) : this.inputTarget.removeAttribute("aria-activedescendant")
    option?.scrollIntoView({ block: "nearest" })
  }

  get shown() {
    return this.optionTargets.filter((option) => !option.hidden)
  }
}
