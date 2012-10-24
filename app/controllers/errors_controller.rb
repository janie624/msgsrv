class ErrorsController < ApplicationController
    
  def routing_error
    respond_to do |format|
      format.html {render file: 'public/404', status: 404}
    end
  end
end