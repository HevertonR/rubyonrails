class UsersController < ApplicationController
 
  before_action :logged_in_user, only: [:edit, :index, :update]
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def index
   @user = User.paginate(page: params[:page])
  end

 
def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:success] = "Perfil atualizado"
    redirect_to @user
   else
  render 'edit'
 end
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

 def logged_in_user
      unless logged_in?
        flash[:danger] = "Por favor, acesse o sistema para visualizar esta pagina"
        redirect_to login_url
      end
    end
end

