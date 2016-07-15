(function() {
  "use strict";

  function submit(e) {
    e.preventDefault();

    var toSend = e.data.toSend;
    toSend.value = $('#autochthon-value').val();

    $.ajax({
      url: e.data.url,
      type: e.data.type,
      data: JSON.stringify(toSend),
      dataType: 'json',
      contentType: 'application/json',
      headers: {
        'HTTP_X_CSRF_TOKEN': $.rails.csrfToken()
      },
      success: function(response){
        modal().close();
        $(e.data.target).html(response[toSend.key]);
        highlight(e.data.target);
      },
      error: function(xhr, status, error) {
        console.error(xhr);
      }
    });
  }

  function highlight(el) {
    el = $(el);
    var colors = [
      el.css("backgroundColor"),
      "#fffff0",
      "#ffffd0",
      "#ffffe0",
      "#ffffd0",
      "#fffec0",
      "#fffdb0",
      "#fffca0",
      "#fffb90",
      "#fffa80"
    ];

    var id;
    var time = 100;
    var hl = function() {
      var color = colors.pop();
      if(color)
        el.css({backgroundColor: color});
      else
        clearInterval(id);
    };

    id = setInterval(hl, time);
  }

  function modal() {
    return $('#autochthon-modal')[0];
  }

  function form() {
    return "<form id='autochthon-form'>" +
      "<p id='autochthon-p'></p>" +
      "<textarea id='autochthon-value' name='value'></textarea>" +
      "</br>" +
      "<button id='autochthon-cancel' type='button'>Cancel</button>" +
      "<button id='autochthon-submit' type='submit'>Submit</button>" +
      "</form>";
  }

  function appendModal() {
    document.body.innerHTML += "<dialog id='autochthon-modal'>" +
      form() +
      "</dialog>";
  }

  function openForm(t) {
    var p = 'Update translation for locale: ' + t.locale + ' and key: ' + t.key;

    $('#autochthon-p').text(p);
    $('#autochthon-value').val(t.value);
    $('#autochthon-value').attr('placeholder', 'A new value for key: ' + t.key);

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
    $('#autochthon-cancel').on('click', function(e){
      modal().close();
    });

    $(document).on('contextmenu', function(e) {
      var el = e.target;
      if(el instanceof Element &&
         el.title &&
         el.title.match(/^translation missing/)){

        if (typeof HTMLDialogElement !== 'function') {
          alert("Your browser does not support the 'dialog' element");
          return;
        }

        var key = el.title.match(/^translation missing: (.+)$/)[1];
        var mountPoint = $('#autochthon-metadata').data().mountPoint;

        openForm({
          value: el.textContent,
          locale: extractLocale(key),
          key: extractKey(key)
        });

        $('#autochthon-form').off().on('submit', {
          url: "/" + mountPoint + "/translations",
          type: 'POST',
          target: e.target,
          toSend: {
            key: extractKey(key),
            locale: extractLocale(key)
          }
        }, submit);
        e.preventDefault();
      }
    });
  }

  function init(){
    appendModal();
    contextListener();
    $.rails.refreshCSRFTokens();
  }

  document.addEventListener('DOMContentLoaded', init);
})();
