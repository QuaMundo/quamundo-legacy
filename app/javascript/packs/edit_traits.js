// Create new input fields when 'add' button is clicked
$(document).ready(function() {
  $('#add-trait').click(function() {
    create_new_input_pair();
  });
  $('.remove-trait').click(function() {
    remove_trait(this);
  });
});

// FIXME: Refactor this; function body too large
function create_new_input_pair() {
  var new_key = $('#trait_new_key').val();
  var new_val = $('#trait_new_value').val();
  if (new_key != '' && new_val != '') {
    var input_group = $('#add-trait')
      .closest('div[class="form-group row"]');
    input_group.before(
      $('<div/>', { class: 'form-group row' })
      .append(
        $('<label/>', {
          class: 'col-form-label col-4',
          for: 'trait_attributeset_' + new_key,
          text: new_key
        })
      )
      .append(
        $('<div/>', { class: 'col-8 input-group' })
        .append(
          $('<input/>', {
            class: 'form-control',
            id: 'trait_attributeset_' + new_key,
            type: 'text',
            value: new_val,
            name: 'trait[attributeset][' + new_key + ']'
          })
        )
        .append(
          $('<div/>', { class: 'input-group-append' })
          .append(
            $('<button/>', {
              class: 'btn input-group-text btn-outline-primary remove-trait',
              type: 'button',
              click: function() { remove_trait(this) }
            })
            .append($('<i/>', { class: 'fas fa-trash' }))
          )
        )
      )
    );
    $('#trait_new_key').val('');
    $('#trait_new_value').val('');
  }
};

function remove_trait(elem) {
  elem.closest('div[class="form-group row"]').remove();
}
