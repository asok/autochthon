(function() {
  "use strict";

  function submit(e) {
    e.preventDefault();

    var data = e.data.toSend;
    data.value = $('#local-value').val();

    $.ajax({
      url: e.data.url,
      type: e.data.type,
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      headers: {
        'HTTP_X_CSRF_TOKEN': $.rails.csrfToken()
      },
      success: function(data, status, xhr){
        modal().close();
      },
      error: function(xhr, status, error) {
        console.error(xhr);
      }
    });
  }

  function modal() {
    return $('#local-modal')[0];
  }

  function form() {
    return "<form id='local-form'>" +
      "<p id='local-p'></p>" +
      "<textarea id='local-value' name='value'></textarea>" +
      "<button id='local-cancel' type='button'>Cancel</button>" +
      "<button id='local-submit' type='submit'>Submit</button>" +
      "</form>";
  }

  function appendModal() {
    document.body.innerHTML += "<dialog id='local-modal'>" +
      form() +
      "</dialog>";
  }

  function query(q) {
    $.ajax({
      method: 'GET',
      url: '/local/query',
      data: {q: q},
      dataType: 'json',
      contentType: 'application/json',
      headers: {
        'HTTP_X_CSRF_TOKEN': $.rails.csrfToken()
      },
      success: function(data, status, xhr){
        if(data.length == 0)
          alert('Sorry I could not find the entry for it. Please try finding it in the list of all translations.');
        if(data.length > 1)
          alert('There is more than 1 translation with value "' + q.value + '". Please try finding it in the list of all translations.');
        if(data.length == 1) {
          var t = data[0];

          $('#local-form').off().on('submit', {
            url: '/local/translations/' + t.id,
            type: 'PUT',
            toSend: {
              key: t.key,
              locale: t.locale
            }
          }, submit);

          openForm(t);
        }
      },
      error: function(xhr, status, error) {
        console.error(xhr);
      }
    });
  }

  function openForm(t) {
    var p;
    if(t.id)
      p = 'Edit a translation for locale: ' + t.locale + ' and key: ' + t.key;
    else
      p = 'Create a new translation for locale: ' + t.locale + ' and key: ' + t.key;

    $('#local-p').text(p);
    $('#local-value').val(t.value);
    $('#local-value').attr('placeholder', 'A new value for key: ' + t.key);

    modal().showModal();
  }

  function extractLocale(str) {
    return str.split('.')[0];
  }

  function extractKey(str) {
    var parts = str.split('.');
    return parts.splice(1, parts.length).join('.');
  }

  function contextListener(){
    $('#local-cancel').on('click', function(e){
      modal().close();
    });

    $(document).on('contextmenu', function(e) {
      var el = e.target;
      if(el instanceof Element &&
         el.title &&
         el.title.match(/^translation missing/)){

        var key = el.title.match(/^translation missing: (.+)$/)[1];

        openForm({
          value: el.textContent,
          locale: extractLocale(key),
          key: extractKey(key)
        });

        $('#local-form').off().on('submit', {
          url: '/local/translations',
          type: 'POST',
          toSend: {
            key: extractKey(key),
            locale: extractLocale(key)
          }
        }, submit);
      } else if(el.textContent != '') {
        query({value: $.trim(el.textContent)});
      }


      e.preventDefault();
    });
  }

  function init(){
    appendModal();
    contextListener();
    // $('#local-form').on('ajax:beforeSend', function(e, xhr, settings){
    //   settings.dataType = 'json';
      // settings.processData = false;
      // xhr.setRequestHeader('Content-Type', 'application/json');
      // settings.data = JSON.stringify(settings.data);
    // });
    $.rails.refreshCSRFTokens();
  }

  document.addEventListener('DOMContentLoaded', init);
})();
