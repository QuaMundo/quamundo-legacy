// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets: string[] = [
    "template",
    "input",
    "constituent",
    "roles"
  ];

  fcInput: FactConstituentInputHandler;

  connect(): void { this.fcInput = new FactConstituentInputHandler(this); }

  addItem(e): void {
    if (this.fcInput.value == undefined || this.fcInput.value == '') {
      return;
    }
    this.fcInput.addRow();
  }

  removeItem(e): void { this.fcInput.removeRow(e); }

  deleteItem(e): void { this.fcInput.deleteRow(e); }
}

// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class FactConstituentInputHandler {
  constituent: HTMLSelectElement;
  input: HTMLInputElement;
  role: HTMLInputElement;
  template: HTMLElement;

  constructor(obj) {
    // this.obj            = obj;
    this.constituent    = obj.constituentTarget;
    this.input          = obj.inputTarget;
    this.role           = obj.rolesTarget;
    this.template       = obj.templateTarget;
  }

  resetInput(): void {
    this.constituent.selectedIndex = 0;
    this.role.value = '';
  }

  addRow(): void {
    // FIXME: Is there a better way than using placeholders???
    const html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf().toString())
      .replace(/TPL_NEW_VAL/g, this.value)
      .replace(/TPL_NEW_TEXT/g, this.name + ' (' + this.type + ')')
      .replace(/TPL_NEW_ROLES/g, this.roles);
    this.input.insertAdjacentHTML('beforebegin', html);
    this.constituent.options[this.selected].disabled = true;
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
    const input: HTMLInputElement = row.
      querySelector('input[type="hidden"][id$="_destroy"]');
    input.value = '1';
    row.classList.add('d-none');
  }

  row(e): HTMLElement {
    return e.currentTarget.closest('div.fact_constituent_entry');
  }

  get selected()    { return this.constituent.selectedIndex; }
  get value()       { return this.constituent.value; }
  get option()      { return this.constituent.options[this.selected]; }
  get name()        { return this.option.text; }
  get type()        { return this.value.replace(/\.\d+$/, ''); }
  get roles()       { return this.role.value; }
}
