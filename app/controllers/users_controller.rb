class UsersController < ApplicationController
  before_filter :check_signed_in, only: [ :edit, :update ]
  before_filter :check_right_user, only: [ :edit, :update ]

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def check_signed_in
    unless signed_in?
      remember_redirect
      redirect_to signin_url, notice: "You must be signed in to view this page."
    end
  end

  def check_right_user
    @user = User.find(params[:id])
    redirect_to root_path, notice: "You cannot edit other people's information." unless current_user == @user
  end
end
