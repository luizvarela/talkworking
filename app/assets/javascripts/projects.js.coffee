# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
	$(".icon-eye-open").popover({delay: { show: 800 }})

@editProject = ->
	$("#edit-project-div").slideDown()
	$("#edit-project-link").hide();
	$("#save-project-link").show();
	$("#project-description-div").hide();
	$("#project-title-div").hide();