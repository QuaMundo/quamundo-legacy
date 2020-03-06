// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "template",
    "input",
    "key",
    "value"
  ];

  connect() { this.tInput = new TraitInputHandler(this); }

  addItem() {
    if (this.tInput.key == undefined || this.tInput.key == '') {
      return;
    }
    this.tInput.addRow();
  }

  removeItem(e) { this.tInput.removeRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class TraitInputHandler {
  // FIXME: What about error handling???
  constructor(obj) {
    this.key_value    = obj.keyTarget;
    this.value_value  = obj.valueTarget;
    this.template     = obj.templateTarget;
    this.input        = obj.inputTarget;
  }

  resetInput() {
    this.key_value.value = '';
    this.value_value.value = '';
  }

  addRow() {
    let html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INDEX/g, new Date().valueOf())
      .replace(/TPL_NEW_KEY/g, this.key)
      .replace(/TPL_NEW_VAL/g, this.value);
    // FIXME: Dublettes are not detected
    this.input.insertAdjacentHTML('beforebegin', html);
    this.resetInput();
  }

  removeRow(e) {
    let row = this.row(e);
    row.parentNode.removeChild(row);
  }

  row(e) {
    return e.currentTarget.closest('div.trait_entry');
  }

  get key()     { return this.key_value.value; }
  get value()   { return this.value_value.value; }
}
