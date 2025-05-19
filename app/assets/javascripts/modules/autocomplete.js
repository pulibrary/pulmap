// Reinitializes autocomplete to add limit value. Fixes issue where
// autocomplete results are hidden. Can remove when fixed upstream.

$(document).ready(function () {
  $('[data-autocomplete-enabled="true"]').each(function () {
    const $el = $(this)

    if ($el.hasClass('tt-hint')) {
      return
    }

    const suggestUrl = $el.data().autocompletePath
    const terms = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: suggestUrl + '?q=%QUERY',
        wildcard: '%QUERY'
      }
    })
    terms.initialize()
    $el.typeahead({
      hint: true,
      highlight: true,
      minLength: 2
    }, {
      name: 'terms',
      limit: 10,
      displayKey: 'term',
      source: terms.ttAdapter()
    })
  })
})
