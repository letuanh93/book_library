jQuery(function() {
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    if($('fieldset').length < 4) {
      $(this).before($(this).data('fields').replace(regexp, time));
    }
    else {
      alert(I18n.t('number_specifications_errors'));
    }
    return event.preventDefault();
  });
  return $('form').on('change', '.check-change', function(event) {
    $('.check-change').each(function(index, element) {
      return $(element).prop('checked', false);
    });
    $(this).prop('checked', true);
    return event.preventDefault();
  });
});
