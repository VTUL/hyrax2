module IawaHelper

  def link_to_html(field, show_link = true)
    if field.is_a? Hash
        options = field[:config].separator_options || {}
        text = field[:value].to_sentence(options)
      else
        text = field
      end
      # this block is only executed when a link is inserted;
      # if we pass text containing no links, it just returns text.
      auto_link(text.html_safe) do |value|
        "<span class='glyphicon glyphicon-new-window'></span>#{('&nbsp;' + value) if show_link}"
      end
  end

end
