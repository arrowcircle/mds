import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["close"]

  dismiss() {
    this.element.remove();
  }
}
