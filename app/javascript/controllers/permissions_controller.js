// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "template",
    "input",
    "permissions",
    "user",
    "selectedUsers",
    "selectedPermissions"
  ]

  connect() {
    this.permInput = new PermissionInputHandler(this);
    this.disableSelectedUserOptions(this.permInput);
    this.disableSelectedPublicOptions(this.permInput);
  }

  addItem(e) {
    this.permInput.addRow(e);
    if (this.permInput.permissions == '') {
    }
  }

  removeItem(e) { this.permInput.removeRow(e); }

  deleteItem(e) { this.permInput.deleteRow(e); }

  disableSelectedUserOptions(obj) {
    this.selectedUsersTargets.forEach(function(user) {
      let option = obj.user.querySelector('option[value="' + user.value +'"]');
      option.disabled = true;
    });
  }

  disableSelectedPublicOptions(obj) {
    if (this.selectedPermissionsTargets.some(function(perm) {
      return (perm.value == 'public');
    })) {
      let publicOption = obj
        .permissions
        .querySelector('option[value="public"]');
      publicOption.disabled = true;
    }
  }
}


// FIXME: Is this the right way to do it?
// FIXME: Extract common code from relation_constituents_controller
// and fact_constituents_controller
class PermissionInputHandler {
  // FIXME: What about error handling???
  constructor(obj) {
    this.obj = obj;
  }

  resetInput() {
    this.permissions.selectedIndex = 0;
    this.user.selectedIndex = 0;
  }

  addRow(e) {
    // FIXME: Is there a better way than using placeholders???
    let html = this
      .template
      .innerHTML
      .replace(/TPL_NEW_INPUT/g, new Date().valueOf())
      .replace(/TPL_NEW_PERM_ID/g, this.permission_id)
      .replace(/TPL_NEW_PERM_NAME/g, this.permission_name)
      .replace(/TPL_NEW_USERID/g, this.user_id)
      .replace(/TPL_NEW_USER/g, this.user_name);
    this.input.insertAdjacentHTML('beforebegin', html);
    this.user.options[this.selectedUserIdx].disabled = true;
    this.resetInput();
  }

  removeRow(e) {
    // FIXME: Try this without a css selector, use data-? instead!?
    let row = this.row(e);
    let value = row.querySelector('input[id$="_user_id"]').value;
    let search = 'option[value="' + value + '"]';
    let option = this.input.querySelector(search);
    row.parentNode.removeChild(row);
    option.removeAttribute('disabled');
  }

  deleteRow(e) {
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

    input.value = '1';
    row.classList.add('d-none');
  }

  row(e) {
    // FIXME: Maybe use (element) ID; see redmine #541
    return e.currentTarget.closest('div.permission_entry');
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
  get permission_name()   { return this
      .permissions[this.selectedPermIdx].text; }
  // /Needed?
}
