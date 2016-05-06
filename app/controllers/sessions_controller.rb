class SessionsController < ApplicationController
  skip_before_action :ensure_user_login, only: [:new, :create]

  def new
    #it will invoke the new (login page) template
  end

  #POST sessions_path
  def create
    user_email = User.find_by(email: params[:user][:email])
    user_pass = params[:user][:password]

    if user_email && user_email.authenticate(user_pass)
      session[:user_id] = user_email.id #to be checked in the appcontroller to ensure user login
      redirect_to user_email
      flash[:notice] = "Logged in Successfully!"
    else
      redirect_to login_path, alert: "Invalid Username/Password!"
    end
  end

  def destroy
    reset_session #wipe out session and everything in it (end the connection)
    redirect_to root_path, notice: "You have logged out!"
  end
end
