class MessagesController < ApplicationController
  include MessagesHelper

  before_filter :authenticate_user!
  before_filter :build_message, :only => [:new, :create]
  before_filter :find_message, :only => [:show, :destroy]
  before_filter :get_all_messages, :only => [:mark_all_read]

  respond_to :html, :js

  def index
    session['slideSelected'] = "Messages"
    @messages = {
      :inbox => Message.inbox(current_user),
      :sent => Message.sent(current_user)
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
  end
  
  def mark_all_read
    @messages.each {|m| m.read!(current_user)}
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
  
end
