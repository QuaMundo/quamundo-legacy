// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "template",
    "input",
    "constituent",
    "role"
  ]

  rcInput: RelationConstituentInputHandler;

  connect(): void { this.rcInput = new RelationConstituentInputHandler(this); }

  addItem(e): void {
    if (this.rcInput.value == undefined || this.rcInput.value == '') {
      return;
    }
    this.rcInput.addRow();
  }

  removeItem(e): void { this.rcInput.removeRow(e); }

  deleteItem(e): void { this.rcInput.deleteRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class RelationConstituentInputHandler {
  constituent: HTMLSelectElement;
  input: HTMLInputElement;
  role: HTMLInputElement;
  template: HTMLElement;

  constructor(obj) {
    this.constituent    = obj.constituentTarget;
    this.input          = obj.inputTarget;
    this.role           = obj.roleTarget;
    this.template       = obj.templateTarget;
  }

  resetInput(): void {
    this.constituent.selectedIndex = 0;
  }

  addRow(): void {
    // FIXME: Is there a better way than using placeholders???
    const html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf().toString())
      .replace(/TPL_NEW_VAL/g, this.value)
      .replace(/TPL_NEW_TEXT/g, this.name + ' (' + this.type + ')')
      .replace(/TPL_NEW_ROLE/g, this.roles);
    this.input.insertAdjacentHTML('beforebegin', html);
    // set role of newly created row
    const r = this.input.previousElementSibling;
    r.querySelector('select').value = this.roles;
    this.constituent.options[this.selectedIdx].disabled = true;
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
    // FIXME: Deleted constituents don't show up in select list yet!
    const row = this.row(e);
    const input = row.querySelector('input[type="hidden"][id$="_destroy"]');
    input.value = '1';
    row.classList.add('d-none');
  }

  row(e) {
    return e.currentTarget.closest('div.relation_constituent_entry');
  }

  get selectedIdx()   { return this.constituent.selectedIndex; }
  get value()         { return this.constituent.value; }
  get option()        { return this.constituent.options[this.selectedIdx]; }
  get name()          { return this.option.text; }
  get roles()         { return this.role.value; }
  get type()          {
    // return this.option.parentNode.label;
    const typeNode: HTMLOptGroupElement = <HTMLOptGroupElement>this
      .option.parentElement;
    return typeNode.label;
  }
}
