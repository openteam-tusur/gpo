/*
 * = require jquery
 * = require jquery-ui
 * = require jquery_ujs
 * = require scroll_to
 * = require_tree .
 */

function init_datepicker_locale() {
  $.datepicker.regional['ru'] = {
    clearText: 'Очистить',
    clearStatus: '',
    closeText: 'Закрыть',
    closeStatus: '',
    prevText: '&#x3c;',
    prevStatus: '',
    prevBigText: '&#x3c;&#x3c;',
    prevBigStatus: '',
    nextText: '&#x3e;',
    nextStatus: '',
    nextBigText: '&#x3e;&#x3e;',
    nextBigStatus: '',
    currentText: 'Сегодня',
    currentStatus: '',
    monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь', 'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
    monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн','Июл','Авг','Сен','Окт','Ноя','Дек'],
    monthStatus: '',
    yearStatus: '',
    weekHeader: 'Не',
    weekStatus: '',
    dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
    dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
    dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
    dayStatus: 'DD',
    dateStatus: 'D, M d',
    dateFormat: 'dd.mm.yy',
    firstDay: 1,
    initStatus: '',
    isRTL: false
  };
  $.datepicker.setDefaults($.datepicker.regional['ru']);
};

function hint() {
  $('#tray').append("<img class='hint-switcher' src='/assets/icon-help.png' />");
  $('#hint').addClass("hint-switcher");
  $('.hint-switcher').click(function() {
    $('#hint:visible').fadeOut('fast');
    $('#hint:hidden').fadeIn('fast');
  });
};

function gpoday_clear() {
  $(".gpoday .input").remove();
  $(".gpoday .save").remove();
  $(".gpoday .cancel").remove();
  $(".gpoday .ratio").show();
  $(".gpoday .period").show();
  $(".gpoday .summ").show();
  $(".gpoday .edit").show();
};

function isNumeric(sText) {
  var ValidChars = "0123456789.";
  var Char;
  sText = sText.replace(",", ".");
  for (i = 0; i < sText.length; i++) {
    Char = sText.charAt(i);
    if (ValidChars.indexOf(Char) == -1) {
       return false;
    };
  };
  return true;
};

function set_wrapper_width() {
  $(".wrapper").each(function() {
    var width_wrapper = 0;
    $(".gpoday", this).each(function() {
      width_wrapper += $(this).width();
      $(this).parent().width(width_wrapper);
    });
    last_child = $("div.gpoday:last", this);
    $(this).parent().scrollTo(last_child);
  });
};

function gpoday() {
  set_wrapper_width();
  $(document).bind("keydown", function(event) {
    event.keyCode == 27 ? gpoday_clear() : null;
  });
  $(".gpoday li .edit").live("click", function() {
    var li = $(this).parent();
    gpoday_clear();
    var span = $(".ratio", li);
    $("span", li).hide();
    var text = span.text() == "—" ? "" : span.text();
    var edit = $(this).hide();
    li.append("<input id=" + li.attr("id") + " class='input'>");
    var input = $(".input", li).attr("value", text);
    li.append("<a href='' class='save'>save</a>");
    var save = $(".save", li);
    li.append("<a href='' class='cancel'>cancel</a>");
    var cancel = $(".save", cancel);

    input.show().focus();

    input.keydown(function(event) {
      event.keyCode == 13 ? save.click() : null;
    });

    $(".save", li).live("click", function() {
      var input = $(".input", $(this).parent()).css({"background-color": "#fff", "color": "#000"});
      var ids = $(this).parent().attr("id").split("_");
      var href = $(".edit", $(this).parent()).attr("href");
      var context = href.substr(href.indexOf("context=")+8);
      var js_project_id = input.parents("div:eq(3)").attr("id").replace("project_", "");
      if (!isNumeric(input.attr("value")) || input.attr("value") < 0 || input.attr("value") > 2) {
        input.css({"background-color": "#990000", "color": "#fff"});
        input.focus();
        return false;
      }
      input.attr("readonly", true).css({"background-color": "#f8f8f8", "color": "#999"});
      $.post("/chairs/" + ids[0] + "/projects/" + ids[1] + "/visitations/" + ids[2],
        { "_method": "put",
          "visitation][rate]": input.attr("value"),
          "context": context,
          "js_project_id": js_project_id,
          "authenticity_token": "8cbSHUFhpGFubSNloGMdx5SWNX9scaAmNV1C+fXsk0A="
        },
        function(data) {
          var rating = $(".visitationlog #project_" + js_project_id + " .rating", data);
          $(".visitationlog #project_" + js_project_id + " .rating").html(rating.html());
          set_wrapper_width();
        }
      );
      return false;
    });

    $(".cancel", li).live("click", function() {
      gpoday_clear();
      return false;
    });

    return false;
  });
};

function go_to_chair() {
  $("#go-to-chair input[type=submit]").hide();
  $("#go-to-chair select").change(function() {
    console.log(this);
    $(this).closest("form").submit();
  });
}

$(document).ready(function() {
  init_datepicker_locale();
  $("#hint").css("display", "none");
  $('input.datepicker').datepicker();
  $('.attention').effect("highlight", {color: '#ff0'}, 1000);
  hint();
  gpoday();
  go_to_chair();
});
