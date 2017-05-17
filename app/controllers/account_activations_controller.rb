class AccountActivationsController < ApplicationController
 def edit
  user = User.find_by(email: params[:email])
   if user && !user.activated?
    user.update_attribute(:activated, true)
    user.update_attribute(:activated_at, Time.zone.now)
    log_in user
    flash[:success] = "Sua conta foi ativada com sucesso"
    redirect_to user
   else
    flash[:danger] = "Nao foi possivel ativar sua conta, por favor verifique o link"
    redirect_to root_url
end
end
end
