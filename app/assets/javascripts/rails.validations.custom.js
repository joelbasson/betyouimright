clientSideValidations.validators.remote['valid_date'] = function(element, options) {
  if ($.ajax({
    url: '/validators/valid_date.json',
    data: { id: element.val() },
    // async *must* be false
    async: false
  }).status == 404) { return options.message; }
}