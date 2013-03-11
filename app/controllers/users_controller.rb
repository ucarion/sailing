class UsersController < ApplicationController
  before_filter :check_signed_in,  only: [ :edit, :update, :index ]
  before_filter :check_right_user, only: [ :edit, :update ]
  before_filter :check_admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def index
    @users = User.all
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

  def destroy
    user = User.find(params[:id]).destroy
    flash[:success] = "User #{user.name} destroyed."
    redirect_to users_url
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

  def check_admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
