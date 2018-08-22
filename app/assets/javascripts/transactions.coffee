# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
delay = 500

$ ->
  $(".js-input").keyup ->
    label = jQuery(this).parent(".form-group").children(".my-label")
    if jQuery(this).val() != ""
      console.log("ne pusto")
      if label.css("opacity") == "0"
        label.animate opacity: "1", delay
    else
      console.log("pusto")
      label.animate opacity: "0" , delay
