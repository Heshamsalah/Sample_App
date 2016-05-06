class UsersController < ApplicationController
  skip_before_action :ensure_user_login, only: [:new, :create]
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    # debugger => to invoke the bybug debugger in rails server (in the console)
  end

  #Create a new user, the submit button on the "new" page pass the params to here (through Strong parametes method)
  def create
    @user = User.new(user_params) #user_params here is a strong parameter
    if @user.save
      # Handle a successful save.
      log_in @user # log the user in
      flash[:success] = "Welcome to Social Network!"
      redirect_to @user #redirect to the "user name" show page
    else
      redirect_to signup_path
      #render 'new' #show the new page again
    end
  end

  private
    def user_params #strong Patams
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
