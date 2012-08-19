class UsersController < ApplicationController
  
  def show
    expires_in 1.minute , :public => true
    respond_with User.find(params[:id])
  end 
  
  def index
    expires_in 1.minute , :public => true
    respond_with User.all
  end
  
  def create
    respond_with User.create(params[:user])
  end
  
  def destroy
    respond_with User.find(params[:id]).delete
  end
  
  def update
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    respond_with(user)
  end
  
end
