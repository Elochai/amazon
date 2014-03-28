// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require filterrific-jquery
$(window).load(function() {
  $('#use_ba').attr('checked', false);
  $('#sa_info').toggle(true)
  $('#use_ba').click(function() {
    $('#sa_info').toggle('#use_ba'.checked);
  });
  $('#use_bill_address').attr('checked', false);
  $('#use_bill_address').click(function() {
    $('#sa_fields').toggle('#use_bill_address'.checked);
  });
  $(".prices").toggle(false)
  $("#"+$("#radios input:radio:checked").attr('value')).toggle(true)
  var price = $("#total_price").data('price');
  var price_without_delivery = $("#total_price_id_edit").data('price');
  $("#radios input:radio").click(function(){
    $(".prices").toggle(false)
    $("#"+$(this).attr('value')).toggle(true)
    var total_price_in_edit = parseFloat(price_without_delivery) + parseFloat($("#"+$(this).attr('value')+" strong").data('price'));
    var total_price = parseFloat(price) + parseFloat($("#"+$(this).attr('value')+" strong").data('price'));
    $("#total_price").text("$"+total_price.toFixed(2));
    $("#total_price_id_edit").text("$"+total_price_in_edit.toFixed(2));
  });
});

$(document).on('page:load', function() {
  $('#use_ba').attr('checked', false);
  $('#sa_info').toggle(true)
  $('#use_ba').click(function() {
    $('#sa_info').toggle('#use_ba'.checked);
  });
  $('#use_bill_address').attr('checked', false);
  $('#use_bill_address').click(function() {
    $('#sa_fields').toggle('#use_bill_address'.checked);
  });
  $(".prices").toggle(false)
  $("#"+$("#radios input:radio:checked").attr('value')).toggle(true)
  var price = $("#total_price").data('price');
  var price_without_delivery = $("#total_price_id_edit").data('price');
  $("#radios input:radio").click(function(){
    $(".prices").toggle(false)
    $("#"+$(this).attr('value')).toggle(true)
    var total_price_in_edit = parseFloat(price_without_delivery) + parseFloat($("#"+$(this).attr('value')+" strong").data('price'));
    var total_price = parseFloat(price) + parseFloat($("#"+$(this).attr('value')+" strong").data('price'));
    $("#total_price").text("$"+total_price.toFixed(2));
    $("#total_price_id_edit").text("$"+total_price_in_edit.toFixed(2));
  });
});

