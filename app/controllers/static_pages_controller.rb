class StaticPagesController < ApplicationController
  skip_before_action :ensure_user_login
  def home
  end

  def help
  end

  def about
  end

  def contact
  end
end
