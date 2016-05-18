module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, messages|
      messages = messages.is_a?(Array) ? messages : [messages]
      messages.each do |message|
        concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
          concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
            concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
            concat content_tag(:span, 'Close', class: 'sr-only')
          end)
          concat message
        end)
      end
    end
    nil
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def errors_to_flash(model)
    if model && model.respond_to?(:errors) && model.errors.present?
      model.errors.each do |k, v|
        flash_message :error, k.to_s.humanize+" "+v
      end
    end
  end
end
