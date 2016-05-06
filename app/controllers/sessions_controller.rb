class SessionsController < ApplicationController
  skip_before_action :ensure_user_login, only: [:new, :create]

  def new
    #it will invoke the new (login page) template
  end

  #POST sessions_path
  def create
    user = User.find_by(email: params[:session][:email])
    user_password = params[:session][:password]

    if user && user.authenticate(user_password)
      log_in(user) #invoke the log_in method in the sessions_helper.rb file which sets session[:user_id]=user.id
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user #go to the user personal page
      flash[:success] = "Logged in Successfully!"
    else
      flash[:danger] = "Invalid Email/Password!"
      #render 'new'
      redirect_to login_path
    end
  end

  def destroy
    #reset_session #wipe out session and everything in it (end the connection)
    log_out if logged_in? #SessionsHelper method to delete the user id from session[] and set current_user to nil
    flash[:success] = "Logged Out!"
    redirect_to root_url
  end
end
