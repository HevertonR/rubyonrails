class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def index
   @user = User.all
  end

 
def update
  
end



 def edit
  @user = User.find(params[:id])
 end

 def destroy
  @user = User.find(params[:id])
  @user.destroy
  flash[:success] = "Usuario excluido com sucesso"
  redirect_to @user
 end 

 def create
    @user = User.new(user_params)
    if @user.save
    log_in @user
    flash[:success] = "Seja bem vindo ao Sample App!"
    redirect_to @user
      # Handle a successful save.
    else
      render 'new'
    end
  end

 private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end

