class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :non_signed_in_user, only: [:new, :create]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile update'
      sign_in @user
      redirect_to @user
    else
      flash.now[:error] = 'Please fix the errors below'
      render 'edit'
    end
  end

  def destroy
    usr = User.find(params[:id])
    if current_user?(usr)
      flash[:error] = 'Do not delete yourself!'
    elsif
      usr.destroy
      flash[:success] = 'User destroyed.'
    end
    redirect_to users_url
  end

  private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: 'Please sign in'
    end
  end
  
  def non_signed_in_user
    redirect_to(user_url(current_user)) if signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
