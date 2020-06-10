// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  traitInput: TraitInputHandler;

  static targets: string[] = [
    "template",
    "input",
    "key",
    "value"
  ];

  connect(): void { this.traitInput = new TraitInputHandler(this); }

  addItem(): void {
    if (this.traitInput.key == undefined || this.traitInput.key == '') {
      return;
    }
    this.traitInput.addRow();
  }

  removeItem(e): void { this.traitInput.removeRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class TraitInputHandler {
  key_value: HTMLInputElement;
  value_value: HTMLInputElement;
  template: HTMLElement;
  input: HTMLInputElement;

  constructor(obj) {
    this.key_value    = obj.keyTarget;
    this.value_value  = obj.valueTarget;
    this.template     = obj.templateTarget;
    this.input        = obj.inputTarget;
  }

  resetInput(): void {
    this.key_value.value = '';
    this.value_value.value = '';
  }

  addRow(): void {
    const html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INDEX/g, new Date().valueOf().toString())
      .replace(/TPL_NEW_KEY/g, this.key)
      .replace(/TPL_NEW_VAL/g, this.value);
    // FIXME: Dublettes are not detected
    this.input.insertAdjacentHTML('beforebegin', html);
    this.resetInput();
  }

  removeRow(e): void {
    const row = this.row(e);
    row.parentNode.removeChild(row);
  }

  row(e): HTMLElement {
    return e.currentTarget.closest('div.trait_entry');
  }

  get key()     { return this.key_value.value; }
  get value()   { return this.value_value.value; }
}
