// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

class PermissionsControllerBase extends Controller {
  selectedUsersTargets!: HTMLSelectElement[];
  selectedPermissionsTargets!: HTMLSelectElement[];
  userTarget!: HTMLSelectElement;
  permissionsTarget!: HTMLSelectElement;
  inputTarget!: HTMLElement;
  templateTarget!: HTMLElement;
}

export default class extends (Controller as typeof PermissionsControllerBase) {
  static targets: string[] = [
    "template",
    "input",
    "permissions",
    "user",
    "selectedUsers",
    "selectedPermissions"
  ];

  permInput: PermissionInputHandler;

  connect(): void {
    this.permInput = new PermissionInputHandler(this);
    this.disableSelectedUserOptions(this.permInput);
    this.disableSelectedPublicOptions(this.permInput);
  }

  addItem(e: Event): void {
    this.permInput.addRow(e);
    // FIXME: Missing instructions!
    if (this.permInput.permissions.value == '') {
    }
  }

  removeItem(e: Event): void { this.permInput.removeRow(e); }

  deleteItem(e: Event): void { this.permInput.deleteRow(e); }

  disableSelectedUserOptions(obj: PermissionInputHandler): void {
    this.selectedUsersTargets.forEach(function(user) {
      let option = obj.user.querySelector('option[value="' + user.value +'"]');
      (option as HTMLInputElement).disabled = true;
    });
  }

  disableSelectedPublicOptions(obj: PermissionInputHandler): void {
    if (this.selectedPermissionsTargets.some(function(perm) {
      return (perm.value == 'public');
    })) {
      let publicOption = obj
        .permissions
        .querySelector('option[value="public"]');
      (publicOption as HTMLInputElement).disabled = true;
    }
  }
}


// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class PermissionInputHandler {
  obj: PermissionsControllerBase;

  constructor(obj: PermissionsControllerBase) {
    this.obj = obj;
  }

  resetInput(): void {
    this.permissions.selectedIndex = 0;
    this.user.selectedIndex = 0;
  }

  addRow(e: Event): void {
    // FIXME: Is there a better way than using placeholders???
    let html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf().toString())
      .replace(/TPL_NEW_PERM_ID/g, this.permission_id)
      .replace(/TPL_NEW_PERM_NAME/g, this.permission_name)
      .replace(/TPL_NEW_USERID/g, this.user_id)
      .replace(/TPL_NEW_USER/g, this.user_name);
    this.input.insertAdjacentHTML('beforebegin', html);
    this.user.options[this.selectedUserIdx].disabled = true;
    this.resetInput();
  }

  removeRow(e: Event): void {
    // FIXME: Try this without a css selector, use data-? instead!?
    let row = this.row(e);
    let value = (
      row.querySelector('input[id$="_user_id"]') as HTMLInputElement
    ).value;
    let search = 'option[value="' + value + '"]';
    let option = this.input.querySelector(search);
    row.parentNode.removeChild(row);
    option.removeAttribute('disabled');
  }

  deleteRow(e: Event): void {
    let row = this.row(e);
    let input = row.querySelector('input[type="hidden"][id$="_destroy"]');
    // FIXME: This will fail if 'public' has been removed and re-enabled
    // since there would be two records with 'public' - which isnt allowed!
    // let user_id = row
    //   .querySelector('input[data-target="permissions.selectedUsers"]')
    //   .value
    // this.user.querySelector('option[value="' + user_id + '"]')
    //   .removeAttribute('disabled');

    // FIXME: This will fail if 'public' has been removed and re-enabled
    // since there would be two records with 'public' - which isnt allowed!
    // let permission = row
    //   .querySelector('input[data-target="permissions.selectedPermissions"]')
    //   .value;
    // this.permissions.querySelector('option[value="' + permission + '"]')
    //   .removeAttribute('disabled');

    (input as HTMLInputElement).value = '1';
    row.classList.add('d-none');
  }

  row(e: Event): HTMLElement {
    // FIXME: Maybe use (element) ID; see redmine #541
    return (e.currentTarget as HTMLElement).closest('div.permission_entry');
  }

  get user()              { return this.obj.userTarget; }
  get permissions()       { return this.obj.permissionsTarget; }
  get input()             { return this.obj.inputTarget; }
  get template()          { return this.obj.templateTarget; }
  get selectedUserIdx()   { return this.user.selectedIndex; }
  get selectedPermIdx()   { return this.permissions.selectedIndex; }
  get user_name()         { return this
      .user.options[this.selectedUserIdx].text; }
  get user_id()           { return this.user.value; }
  // Needed?
  get permission_id()     { return this.permissions.value; }
  get permission_name()   { return (this
      .permissions[this.selectedPermIdx] as HTMLOptionElement)
      .text; }
  // /Needed?
}

