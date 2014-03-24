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
$(document).on('page:load', function() {
	$('#use_ba').attr('checked', true);
  $('#sa_info').toggle(false)
  	$('#use_ba').click(function() {
	 	return $('#sa_info').toggle('#use_ba'.checked);
	});
});
$(window).load(function() {
	$('#use_ba').attr('checked', true);
  $('#sa_info').toggle(false)
  	$('#use_ba').click(function() {
	 	return $('#sa_info').toggle('#use_ba'.checked);
	});
});
$(document).on('page:load', function() {
  $('#use_bill_address').attr('checked', false);
    $('#use_bill_address').click(function() {
    return $('#sa_fields').toggle('#use_bill_address'.checked);
  });
});
$(window).load(function() {
  $('#use_bill_address').attr('checked', false);
    $('#use_bill_address').click(function() {
    return $('#sa_fields').toggle('#use_bill_address'.checked);
  });
});