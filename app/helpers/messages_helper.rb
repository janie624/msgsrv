module MessagesHelper

  def unread_messages_counter
    content_tag(:span, unread_messages_count, :class => 'unread-messages-counter messages-counter').html_safe
  end

  def unread_messages_count
    Message.unread(current_user).count
  end

  def sent_messages_counter
    content_tag(:span, sent_messages_count, :class => 'sent-messages-counter messages-counter').html_safe
  end

  def sent_messages_count
    Message.sent(current_user).count
  end

end
