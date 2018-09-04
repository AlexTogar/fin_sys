# frozen_string_literal: true

module ApplicationHelper



  def my_input_tag(name, html_name, type, my_class)
    html = "
        <div class='form-group'>
          <label for='#{html_name}' class='control-label'>#{name.capitalize}</label>
          <input type='#{type}' class='form-control js-input #{my_class}' name='#{html_name}' id='#{html_name}' placeholder='#{name.capitalize}'>
        </div>
    "
    html.html_safe
  end

  def my_toggle_tag(params)
    toggle_name,
    toggle_name_html,
    toggle_class,
    my_class_input,
    my_class_label,
    class_one,
    class_two,
    active_one,
    name_one,
    name_two =
    params[:toggle_name],
    params[:toggle_name_html],
    params[:toggle_class],
    params[:my_class_input],
    params[:my_class_label],
    params[:class_one],
    params[:class_two],
    params[:active_one],
    params[:name_one],
    params[:name_two]

    toggle_name = "toggle_name" if toggle_name == nil
    class_one = "local_p" if class_one == nil
    class_two = "local_j" if class_two == nil
    active_one = true if active_one == nil
    name_one = "name_one" if name_one == nil
    name_two = "name_two" if name_two == nil


    html = "
        <div class='form-group #{toggle_class}'>
          <label for=' #{toggle_name} ' class=' control-label '> #{toggle_name.capitalize}</label>
          <div class=' btn-group ' data-toggle=' buttons '>
            <label class='#{my_class_label} btn btn-primary   #{class_one} '>
              <input class = '#{my_class_input}' type='radio' name='#{toggle_name_html}' id=' #{class_one}' autocomplete=' off ' value = '#{ active_one == true ? "true" : "false"}' checked>#{name_one.capitalize}
            </label>
            <label class='#{my_class_label} btn btn-outline-primary #{"active" if active_one == false }  #{class_two}'>
              <input class = '#{my_class_input}' type='radio' name='#{toggle_name_html}' id=' #{class_two}' autocomplete=' off ' value = '#{ active_one == true ? "false" : "true"}' >#{name_two.capitalize}
            </label>
          </div>
        </div>
    "
    html.html_safe
  end

  def my_toggle_three_tag(params) #пока не работает
    toggle_name = params[:toggle_name]
    toggle_name_html = params[:toggle_name_html]
    toggle_class = params[:toggle_class]
    my_class_input = params[:my_class_input]
    my_class_label = params[:my_class_label]
    class_one = params[:class_one]
    class_two = params[:class_two]
    class_three = params[:class_three]
    active_one = params[:active_one]
    name_one = params[:name_one]
    name_two = params[:name_two]
    name_three  = params[:name_three]
    value_one = params[:value_one]
    value_two = params[:value_two]
    value_three = params[value_three]


    toggle_name = "toggle_name" if toggle_name == nil
    class_one = "local_p" if class_one == nil
    class_two = "local_j" if class_two == nil
    active_one = true if active_one == nil
    name_one = "name_one" if name_one == nil
    name_two = "name_two" if name_two == nil
    name_three = "name_three" if name_three == nil

    html = "
        <div class='form-group #{toggle_class}'>
          <label for=' #{toggle_name} ' class=' control-label '> #{toggle_name.capitalize}</label>
          <div class=' btn-group ' data-toggle=' buttons '>
            <label class='#{my_class_label}' btn btn-outline-primary #{"active" if active_one == false} #{class_three}'>
              <input class = '#{my_class_input}' type='radio' name='#{toggle_name_html}' id=' #{class_three}' autocomplete=' off ' value = '#{value_one}' checked>#{name_three.capitalize}
            </label>
            <label class='#{my_class_label} btn btn-primary   #{class_one} '>
              <input class = '#{my_class_input}' type='radio' name='#{toggle_name_html}' id=' #{class_one}' autocomplete=' off ' value = '#{value_two}' >#{name_one.capitalize}
            </label>
            <label class='#{my_class_label} btn btn-outline-primary #{"active" if active_one == false }  #{class_two}'>
              <input class = '#{my_class_input}' type='radio' name='#{toggle_name_html}' id=' #{class_two}' autocomplete=' off ' value = '#{value_three}' >#{name_two.capitalize}
            </label>

          </div>
        </div>
    "
    html.html_safe

  end


end
