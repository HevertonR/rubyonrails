class UsersController < ApplicationController
 
  before_action :logged_in_user, only: [:edit, :index, :update, :delete, :show]
  before_action :correct_user, only: [:edit, :update]
  

  def show
    @user = User.find(params[:id])
  end

 def correct_user
 end

  def new
    @user = User.new
  end

  def index
   @users = User.paginate(page: params[:page])
  end

 
def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
     @user.update_attributes(activated_at: Time.zone.now)
    flash[:success] = "Perfil atualizado com sucesso"
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
  redirect_to users_url
 end 

 def create
    @user = User.new(user_params)
    if @user.save
  # log_in @user
  # flash[:success] = "Seja bem vindo ao Sample App!"
  # redirect_to @user
   UserMailer.account_activation(@user).deliver_now
   flash[:info] = "Por favor, ative sua conta acessando o link enviado no seu e-mail"
   redirect_to root_url
    else
      render 'new'
    end
  end

 private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :activated, :remember_digest)
    end

 def logged_in_user
      unless logged_in?
        flash[:danger] = "Por favor, acesse o sistema para visualizar esta area"
        redirect_to login_url
      end
    end
 
 def admin_user
  redirect_to(root_url) unless current_user.admin?
 end

end

