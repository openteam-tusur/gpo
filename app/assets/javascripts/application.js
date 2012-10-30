/*
 * = require jquery
 * = require jquery-ui
 * = require jquery_ujs
 * = require scroll_to
 * = require go_to_chair
 * = require datepicker
 * = require gpodays
 * = require main
 */

function hint() {
  $('#tray').append("<img class='hint-switcher' src='/assets/icon-help.png' />");
  $('#hint').addClass("hint-switcher");
  $('.hint-switcher').click(function() {
    $('#hint:visible').fadeOut('fast');
    $('#hint:hidden').fadeIn('fast');
  });
};

$(document).ready(function() {
  $("#hint").css("display", "none");
  $('.attention').effect("highlight", {color: '#ff0'}, 1000);
  hint();
});
