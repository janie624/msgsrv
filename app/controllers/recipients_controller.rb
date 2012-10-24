class RecipientsController < ApplicationController

  respond_to :json

  def index
    @recipients = []
    users_scope = User.where('(users.first_name ILIKE ? OR users.last_name ILIKE ?)', "#{params[:q]}%", "#{params[:q]}%")
    if params[:restrict]
    end
    @recipients += users_scope
    respond_with(@recipients.as_json(:methods => [:name], :only => [:id, :name]))
  end
end
