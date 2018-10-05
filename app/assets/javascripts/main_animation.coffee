$ ->
  animation_duration = 1000
  $btn = $(".submit_new_transaction")
  $btn.click ->
    if this.classList.contains('animation') == false
      this.classList.add("animation")
      $btn.attr("value", "Done")
      setTimeout((-> ($btn.removeClass("animation"); $btn.attr("value", "Add transaction"))) , animation_duration)