class RecipientsController < ApplicationController

  respond_to :json

  def index
    @recipients = []
    users_scope = User.where('(users.first_name ILIKE ? OR users.last_name ILIKE ?) AND id !=?', "#{params[:q]}%", "#{params[:q]}%", current_user.id)
    if params[:restrict]
    end
    @recipients += users_scope
    respond_with(@recipients.as_json(:methods => [:name], :only => [:id, :name]))
  end
end
