class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ...
    else
      flash.now[:error] = 'Invalid login attempt.'
      render 'new'
    end
  end

  def destroy
  end
end
