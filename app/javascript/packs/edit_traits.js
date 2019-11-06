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

  var new_key = $('[data-id="trait_new_key"]').val();
  var new_val = $('[data-id="trait_new_value"]').val();

  if (new_key != '' && new_val != '') {
    var input_group = $('#add-trait')
      .closest('div[class="form-group row"]');
    input_group.before(
      $('<div/>', { class: 'form-group row' })
      .append(
        $('<label/>', {
          class: 'col-form-label col-4',
          for: build_id(),
          text: new_key
        })
      )
      .append(
        $('<div/>', { class: 'col-8 input-group' })
        .append(
          $('<input/>', {
            class: 'form-control',
            id: build_id(),
            type: 'text',
            value: new_val,
            name: build_name()
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

    $('[data-id="trait_new_key"]').val('');
    $('[data-id="trait_new_value"]').val('');
  };

   function get_traitable_type() {
    return $('#traits-input').data('type') || 'trait';
   };

  function get_attributes_params() {
    if (get_traitable_type() != 'trait') {
      return 'trait_attributes';
    };
    return undefined;
  };

  function build_name() {
    res = get_traitable_type();
    if (get_attributes_params() != undefined) {
      res += '[' + get_attributes_params() + ']'
    };
    res += '[attributeset][' + new_key + ']';
    console.log(res);
    return res;
  };

  function build_id() {
    res = get_traitable_type();
    if (get_attributes_params() != undefined) {
      res += '_trait_attributes';
    };
    res += '_attributeset_' + new_key;
    console.log(res);
    return res;
  };
};

function remove_trait(elem) {
  elem.closest('div[class="form-group row"]').remove();
};

