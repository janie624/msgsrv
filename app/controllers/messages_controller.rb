class MessagesController < ApplicationController
  include MessagesHelper

  before_filter :authenticate_user!
  before_filter :build_message, :only => [:new, :create]
  before_filter :find_message, :only => [:show, :destroy]
  before_filter :get_all_messages, :only => [:mark_all_read]
  before_filter :get_selected_messages, :only => [:mark_selected_read, :delete_selected]
  
  respond_to :html, :js

  def index
    @messages = {
      :inbox => Message.inbox(current_user).page(params[:page_inbox]),
      :sent => Message.sent(current_user).page(params[:page_sent])
    }
    
    case params[:box]
    when 'inbox'
      render :partial => '/messages/inbox', :locals => {:messages => @messages[:inbox]}
    when 'sent'
      render :partial => '/messages/sent', :locals => {:messages => @messages[:sent]}
    end if request.xhr?
  end

  def counters
    render :json => {:unread => unread_messages_count, :sent => sent_messages_count}
  end

  def create
    @message.sender = current_user
    render :partial => '/messages/form', :locals => {:message => @message} unless @message.save
  end

  def show
    @message.read!(current_user)
  end

  def destroy
    @message.destroy(current_user)
    render :js, :text => ""
  end
  
  def mark_all_read
    @messages.each {|m| m.read!(current_user)}
    render :js, :text => ""
  end

  def mark_selected_read
    @messages.each {|m| m.read!(current_user)}
    render :js, :text => ""
  end

  def delete_selected
    (params[:box] == 'sent') ? @messages.each {|m| m.delete_sent(m)} : @messages.each {|m| m.destroy(current_user)}
    render :js, :text => ""
  end
  
private

  def find_message
    @message = Message.find(params[:id])
  end

  def build_message
    @message = Message.new(params[:message])
  end
  
  def get_all_messages
    @messages = Message.inbox(current_user)
  end
  
  def get_selected_messages
    if params[:box] == 'sent'
      @messages = params[:message] ? Message.where("sender_id = #{current_user.id} AND id IN (#{params[:message].keys.join(',')})") : []
    else
      @messages = params[:message] ? Message.where({:message_recipients => {:user_id => current_user.id}}).where("message_recipients.message_id IN (#{params[:message].keys.join(',')})") : []
    end
  end
  
end
