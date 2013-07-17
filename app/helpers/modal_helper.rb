module ModalHelper
  def modal_for(name, title)
    content_tag :div, :id => "#{name}-modal", :class => "modal hide fade", :tabindex => "-1", :role => "dialog", "aria-labelledby" => "#{name}-label", "aria-hidden" => "true" do
      modal_header = content_tag :div, :class => "modal-header" do
        buf = "".html_safe
        buf.concat(content_tag :button, "\u00D7", :type => "button", :class => "close", "data-dismiss" => "modal", "aria-hidden" => "true")
        buf.concat(content_tag :h3, title)
      end

      modal_body = content_tag :div, :class => "modal-body" do
        content_tag :div, :id => "#{name}-modal-body" do
        end

      end
      modal_footer = content_tag :div, :class => "modal-footer" do
        buf = "".html_safe
        buf.concat(content_tag :button, "Close", :class => "btn", "data-dismiss" => "modal", "aria-hidden" => "true")
        buf.concat(content_tag :button, "Save", :class => "btn btn-primary")
      end
      modal_header.concat(modal_body).concat(modal_footer)
    end
  end
end