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

  connect() { this.faInput = new FigureAncestorInputHandler(this); }

  addItem(e) {
    if (this.faInput.value == undefined || this.faInput.value == '') {
      return;
    }
    this.faInput.addRow();
  }

  removeItem(e) { this.faInput.removeRow(e); }

  deleteItem(e) { this.faInput.deleteRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class FigureAncestorInputHandler {
  // FIXME: What about error handling???
  constructor(obj) {
    this.ancestor         = obj.ancestorTarget;
    this.input            = obj.inputTarget;
    this.name             = obj.nameTarget;
    this.template         = obj.templateTarget;
  }

  resetInput() {
    this.ancestor.selectedIndex = 0;
    this.name.value = '';
  }

  addRow() {
    // FIXME: Is there a better way than using placeholders???
    let html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf())
      .replace(/TPL_NEW_VAL/g, this.value)
      .replace(/TPL_NEW_TEXT/g, this.ancestor_name)
      .replace(/TPL_NEW_NAME/g, this.role);
    this.input.insertAdjacentHTML('beforebegin', html);
    this.ancestor.options[this.selected].disabled = true;
    this.resetInput();
  }

  removeRow(e) {
    // FIXME: Try this without a css selector, use data-? instead!?
    let row = this.row(e);
    let value = row.querySelector('input[type="hidden"]').value;
    let search = 'option[value="' + value + '"]';
    let option = this.input.querySelector(search);
    row.parentNode.removeChild(row);
    option.removeAttribute('disabled');
  }

  deleteRow(e) {
    // FIXME: Deleted ancestors don't show up in select list yet!
    let row = this.row(e);
    let input = row.querySelector('input[type="hidden"][id$="_destroy"]');
    input.value = '1';
    row.classList.add('d-none');
  }

  row(e) {
    return e.currentTarget.closest('div.figure_ancestor_entry');
  }

  get selected()      { return this.ancestor.selectedIndex; }
  get value()         { return this.ancestor.value; }
  get option()        { return this.ancestor.options[this.selected]; }
  get ancestor_name() { return this.option.text; }
  get role()          { return this.name.value; }
}
