# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
delay = 200

$ ->
  $(".my-form #sum").val "0"

  $(".my-form #sum").focus ->
    if $(this).val() == "0"
      $(this).val ""
  $(".my-form #sum").focusout ->
    if $(this).val() == ""
      $(this).val "0"

  $(".table-five").tablesorter(headers: 4: sorter: false)
  $(".main-table").tablesorter(headers: 5: sorter: false)


  $(".close").click (e)->
    e.stopPropagation()
    $(".alert").slideUp(delay * 2.5).delay(0).fadeOut(delay * 2.5)


  setTimeout (-> $(".alert").slideUp(delay * 2.5).delay(0).fadeOut(delay * 2.5)), 5000

  $("body").css display: "none" #Удалить body
  $("body").fadeIn(delay) #Проявить body

  $("a").click (e) -> #воизбежание перехода по ссылке с классом .off
    e.preventDefault()

  $("a:not(.off)").click (e) -> #реакция на нажатие ссылки, не содержащей класс .off
    e.preventDefault() #при нажтии на кнопку не выполнять переход по указанному url
    path = this.href
    $("body").fadeOut(delay)
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
      $(".down").css("display", "inline-block")
      $(".up").css("display","none")
    else
      $(".up").css("display", "inline-block")
      $(".down").css("display", "none")


  $(".submit_new_transaction").click (e) ->
    e.preventDefault()
    $form = $(this).parent("form")
#    data =  {reason: "r1", description: "d1", sum: "s1", local: "l1"}
    $.ajax
      url: "../base/response_on_new_transaction",
      data: $form.serialize(),
      dataType: "json",
      type: "GET",
      success: (data) ->
        $("#no-tran").remove()
        $("#sum").val "#{data.sum}"
        $("tbody").prepend("<tr class = '#{"table-success" if data.sign == false } #{"table-warning" if data.sign == true}' id='prepend'><td>#{data.sum}</td><td>#{data.reason}</td><td>#{data.user}</td><td>#{data.date}</td><td><button id='t#{data.id}' class = 'delete-transaction btn btn-outline-danger'><span class='icon-nav'>X</span></button></td></tr>")
        $("#prepend").css("display", "none")
        $("#prepend").fadeIn()
        if $("tbody").find("tr").length > 5
          $("tbody tr").last().fadeOut(delay)
          setTimeout ( -> $("tbody tr").last().remove()), delay
        $(".table-five").trigger("update")



  $(".submit_new_debt").click (e) ->
    e.preventDefault()
    $form = $(this).parent("form")
    #    data =  {reason: "r1", description: "d1", sum: "s1", local: "l1"}
    $.ajax
      url: "../base/new_debt",
      data: $form.serialize(),
      dataType: "json",
      type: "GET",
      success: (data) ->
        $("#no-tran").remove()
        $("#sum").val "#{data.sum}"
        $("tbody").prepend("<tr class = '#{"table-success" if data.sign == false } #{"table-warning" if data.sign == true}' id='prepend'><td>#{data.sum}</td><td>#{data.reason}</td><td>#{data.user}</td><td>#{data.date}</td><td><button id='t#{data.id}' class = 'delete-transaction btn btn-outline-danger'><span class='icon-nav'>X</span></button></td></tr>")
        $("#prepend").css("display", "none")
        $("#prepend").fadeIn()
        if $("tbody").find("tr").length > 5
          $("tbody tr").last().fadeOut(delay)
          setTimeout ( -> $("tbody tr").last().remove()), delay



  $(".btn-group label").click ->
    $label1 = ($($(this).parent(".btn-group")).children("label")[0])
    $label2 = ($($(this).parent(".btn-group")).children("label")[1])
    $(this).removeClass("btn-outline-primary")
    $(this).addClass("btn-primary")
    if $label1 == this
      $($label2).removeClass("btn-primary")
      $($label2).addClass("btn-outline-primary")
    else
      $($label1).removeClass("btn-primary")
      $($label1).addClass("btn-outline-primary")


  $(document).delegate '.delete-transaction', 'click',-> #для динамически сгенерированных delete-transaction кнопок
    tran_id = String($(this).attr("id"))[1..String($(this).attr("id").size)]
    $.ajax
      url: "../base/delete_transaction",
      data: {tran_id: tran_id},
      dataType: "json",
      type: "get"
      success: (data) ->
        location.reload()


  $(".btn-group button").click -> #toggle - 3 button on new_transaction_page
    switch $(this).attr("id")
      when "b1"
        $(this).addClass("active")
        $("#b2").removeClass("active")
        $("#b3").removeClass("active")

        $(".new-debt").fadeOut delay
        $(".fast-tran").fadeOut delay
        setTimeout ( -> $(".new-tran").fadeIn delay), delay
        $(".h3-header").animate opacity: "0", delay
        setTimeout ( -> $(".h3-header").html "New Transaction"), delay
        $(".h3-header").animate opacity: "1", delay
      when "b2"
        $(this).addClass("active")
        $("#b1").removeClass("active")
        $("#b3").removeClass("active")

        $(".new-tran").fadeOut delay
        $(".fast-tran").fadeOut delay
        setTimeout ( -> $(".new-debt").fadeIn delay), delay
        $(".h3-header").animate opacity: "0", delay
        setTimeout ( -> $(".h3-header").html "New Debt"), delay
        $(".h3-header").animate opacity: "1", delay
      else
        $(this).addClass("active")
        $("#b1").removeClass("active")
        $("#b2").removeClass("active")

        $(".new-tran").fadeOut delay
        $(".new-debt").fadeOut delay
        setTimeout ( -> $(".fast-tran").fadeIn delay), delay
        $(".h3-header").animate opacity: "0", delay
        setTimeout ( -> $(".h3-header").html "Fast Transaction") , delay
        $(".h3-header").animate opacity: "1", delay

