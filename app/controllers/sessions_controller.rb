class SessionsController < ApplicationController

  def new
  end
 
 def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
     if user.activated?
      log_in user
      redirect_to user
    else
     # flash.now[:danger] = 'Senha ou email incorreto, por favor tente novamente' # Not quite right!     
      flash.now[:warning] = 'Conta não ativada, por favor ative sua conta e tente novamente' 
     render 'new'
   end
  else
   flash.now[:danger] = 'Senha ou email incorreto, por favor tente novamente'
   render 'new'
 end
end

  def destroy
   log_out
   redirect_to root_url
  end
end
