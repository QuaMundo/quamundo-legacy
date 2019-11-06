// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "template",
    "input",
    "constituent",
    "roles"
  ];

  connect() { this.fcInput = new FactConstituentInputHandler(this); }

  addItem(e) {
    if (this.fcInput.value == undefined || this.fcInput.value == '') {
      return;
    }
    this.fcInput.addRow();
  }

  removeItem(e) { this.fcInput.removeRow(e); }

  deleteItem(e) { this.fcInput.deleteRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class FactConstituentInputHandler {
  // FIXME: What about error handling???
  constructor(obj) {
    // this.obj            = obj;
    this.constituent    = obj.constituentTarget;
    this.input          = obj.inputTarget;
    this.role           = obj.rolesTarget;
    this.template       = obj.templateTarget;
  }

  resetInput() {
    this.constituent.selectedIndex = 0;
    this.role.value = '';
  }

  addRow() {
    // FIXME: Is there a better way than using placeholders???
    let html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf())
      .replace(/TPL_NEW_VAL/g, this.value)
      .replace(/TPL_NEW_TEXT/g, this.name + ' (' + this.type + ')')
      .replace(/TPL_NEW_ROLES/g, this.roles);
    this.input.insertAdjacentHTML('beforebegin', html);
    this.constituent.options[this.selected].disabled = true;
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
    // FIXME: Deleted constituents don't show up in select list yet!
    let row = this.row(e);
    let input = row.querySelector('input[type="hidden"][id$="_destroy"]');
    input.value = '1';
    row.classList.add('d-none');
  }

  row(e) {
    return e.currentTarget.closest('div.fact_constituent_entry');
  }

  get selected()    { return this.constituent.selectedIndex; }
  get value()       { return this.constituent.value; }
  get option()      { return this.constituent.options[this.selected]; }
  get name()        { return this.option.text; }
  get type()        { return this.value.replace(/\.\d+$/, ''); }
  get roles()       { return this.role.value; }
}
