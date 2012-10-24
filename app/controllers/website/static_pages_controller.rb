class Website::StaticPagesController < ApplicationController
  
  def home
    if user_signed_in?
      respond_to do |format|
        format.html {redirect_to home_index_path }
      end
    end
  end

  def features
  end

  def about
  end
  
  def faq
  end
end
