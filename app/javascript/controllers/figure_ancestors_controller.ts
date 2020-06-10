// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "template",
    "input",
    "ancestor",
    "name"
  ]

  faInput: FigureAncestorInputHandler;

  connect(): void { this.faInput = new FigureAncestorInputHandler(this); }

  addItem(e): void {
    if (this.faInput.value == undefined || this.faInput.value == '') {
      return;
    }
    this.faInput.addRow();
  }

  removeItem(e): void { this.faInput.removeRow(e); }

  deleteItem(e): void { this.faInput.deleteRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class FigureAncestorInputHandler {
  ancestor: HTMLSelectElement;
  input: HTMLInputElement;
  name: HTMLInputElement;
  template: HTMLElement;

  constructor(obj) {
    this.ancestor         = obj.ancestorTarget;
    this.input            = obj.inputTarget;
    this.name             = obj.nameTarget;
    this.template         = obj.templateTarget;
  }

  resetInput(): void {
    this.ancestor.selectedIndex = 0;
    this.name.value = '';
  }

  addRow(): void {
    // FIXME: Is there a better way than using placeholders???
    const html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf().toString())
      .replace(/TPL_NEW_VAL/g, this.value)
      .replace(/TPL_NEW_TEXT/g, this.ancestor_name)
      .replace(/TPL_NEW_NAME/g, this.role);
    this.input.insertAdjacentHTML('beforebegin', html);
    this.ancestor.options[this.selected].disabled = true;
    this.resetInput();
  }

  removeRow(e): void {
    // FIXME: Try this without a css selector, use data-? instead!?
    const row = this.row(e);
    const field: HTMLInputElement = row.querySelector('input[type="hidden"]');
    const value = field.value;
    const search = 'option[value="' + value + '"]';
    const option = this.input.querySelector(search);
    row.parentNode.removeChild(row);
    option.removeAttribute('disabled');
  }

  deleteRow(e): void {
    // FIXME: Deleted ancestors don't show up in select list yet!
    const row = this.row(e);
    const input: HTMLInputElement = row.
      querySelector('input[type="hidden"][id$="_destroy"]');
    input.value = '1';
    row.classList.add('d-none');
  }

  row(e): HTMLElement {
    return e.currentTarget.closest('div.figure_ancestor_entry');
  }

  get selected()      { return this.ancestor.selectedIndex; }
  get value()         { return this.ancestor.value; }
  get option()        { return this.ancestor.options[this.selected]; }
  get ancestor_name() { return this.option.text; }
  get role()          { return this.name.value; }
}

