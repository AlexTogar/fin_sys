# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
delay = 200

$ ->
  $("#sum").focus ->
    this.value = ""
  $("#sum").focusout ->
    this.value = "0"

  $(".close").click (e)->
    e.stopPropagation()
    $(".alert").slideUp(delay * 2.5).delay(0).fadeOut(delay * 2.5)
    console.log("fadeout")


  setTimeout (-> $(".alert").slideUp(delay * 2.5).delay(0).fadeOut(delay * 2.5)), 5000

  $("body").css display: "none" #Удалить body
  $("body").fadeIn(delay) #Проявить body

  $("a").click (e) -> #воизбежание перехода по ссылке с классом .off
    e.preventDefault()

  $("a:not(.off)").click (e) -> #реакция на нажатие ссылки, не содержащей класс .off
    e.preventDefault() #при нажтии на кнопку не выполнять переход по указанному url
    path = this.href
    console.log "mailto or # not included"
    $("body").fadeOut(delay)
    console.log "fadeout"
    $(location).attr('href', path)
  #  setTimeout (-> $(location).attr('href', path)), delay #перейти по указанному адресу

  flag = false
  $(".btn-details").click ->
    $(".details").slideToggle(delay)
    if flag == false
      flag = true
    else
      flag = false

    if !flag
      console.log("pusto")
      $(".down").css("display", "inline-block")
      $(".up").css("display","none")
    else
      console.log("ne pusto")
      $(".up").css("display", "inline-block")
      $(".down").css("display", "none")


  $("#submit_new_transaction").click (e) ->
    e.preventDefault()
    $form = $(this).parent("form")
#    data =  {reason: "r1", description: "d1", sum: "s1", local: "l1"}
    $.ajax
      url: "../base/response_on_new_transaction",
      data: $form.serialize(),
      dataType: "json",
      type: "GET",
      success: (data) ->
        #trash
        console.log "slideDown"
        $("tbody").prepend("<tr class = '#{"table-success" if data.sign == false } #{"table-danger" if data.sign == true}' id='prepend'><td>#{data.sum}</td><td>#{data.reason}</td><td>#{data.user}</td><td>#{data.date}</td></tr>")
        $("#prepend").css("display", "none")
        $("#prepend").fadeIn()
        if $("tbody").find("tr").length > 5
          $("tbody tr").last().fadeOut(delay)
          setTimeout ( -> $("tbody tr").last().remove()), delay





  $(".local_p").click ->
    $(this).removeClass("btn-outline-primary")
    $(this).addClass("btn-primary")
    $(".local_j").removeClass("btn-primary")
    $(".local_j").addClass("btn-outline-primary")
  $(".local_j").click ->
    $(this).removeClass("btn-outline-primary")
    $(this).addClass("btn-primary")
    $(".local_p").removeClass("btn-primary")
    $(".local_p").addClass("btn-outline-primary")