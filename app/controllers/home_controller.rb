class HomeController < ApplicationController
  before_filter :authenticate_user! , :except => [:reset_password, :reset ]
  
  def index
    session['slideSelected'] = ''
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js   { render :json => @events }
    end
  end
  
  def reset_password
    @new_user = UserInvite.find_by_code(params[:invite_code])
    
    if !@new_user.nil?
      if @new_user.activate.eql? true
        flash[:error] = "Your link is expired"
        redirect_to root_path
      else
        @new_user.update_attribute(:activate,  true)
      end
    else
      flash[:error] = "Invalid Link"
      redirect_to root_path
    end
  end

  def reset
    @user = User.find_by_email(params[:user][:email])
    
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:alert] = "Your account is activated."
    else
      flash[:error] = "Your account is not activated"
    end
    redirect_to root_path
  end
end
