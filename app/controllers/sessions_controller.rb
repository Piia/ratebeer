class SessionsController < ApplicationController

	def new
    # renderöi kirjautumissivun
  end

  def create
  	user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch."
    end
  end

  def destroy
  	# nollataan sessio
  	session[:user_id] = nil
  	# uudelleenohjataan sovellus pääsivulle
  	redirect_to :signin
  end

  def create_oauth
    
    auth = request.env["omniauth.auth"]  
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth) 
    session[:user_id] = user.id     
    redirect_to :root, :notice => "Signed in with GitHub!"
    



    #github_user = env["omniauth.auth"]
    #user = User.new username: github_user.nickname

    
    #session[:user_id] = user.id
    #redirect_to user, notice: "Welcome back!"
  end





end