class UsersController < ApplicationController
  def index
    if session[:auth]
      @bodytext = " Hello #{session[:username]}"

    else
      @bodytext = ' Please <a href="/users/login"> login </a> / <a href="/users/signup"> signup</a>'
   
    end
  end
  
   #---------------------------------------------
  
  def signup
    session[:auth] = false
    session[:username] = ''
  end
  
  #---------------------------------------------
  
  def create  
       if  params[:users][:password] ==  params[:users][:password2] 
         @hashedpass = Digest::SHA1.hexdigest params[:users][:password]
      @user = Users.new(:name => params[:users][:name], :email => params[:users][:email], :password => @hashedpass)  
            if @user.save  
              @notice = 'Thanks for Registering!'
              session[:auth] = true
              session[:username] = params[:users][:name]
            else  
              @notice = 'Sorry, The username already exists click <a href="#" onClick="history.go(-1)">here</a> to go back'  
          end
    else 
      @notice = 'The passwords did not match ! Click <a href="#" onClick="history.go(-1)">here</a> to go back'
    end
   end
#-------------------------------------------------------------
def login
  
end

#-------------------------------------------------------------

def validate
   @hashedpass = Digest::SHA1.hexdigest params[:password]
  userdata1 = Users.first(:conditions => ["name = ?", params[:name]])
  if userdata1[:password] ==  @hashedpass
    session[:auth] = true
    session[:username] = userdata1[:name]
    @userdata = "The user has been validated"
    redirect_to :action=> 'index'
  else
   @userdata = 'Login not validated ! Click <a href="#" onClick="history.go(-1)">here</a> to go back'
  end
end

def logoff
  session[:auth] = false
    session[:username] = ''
    redirect_to :action=> 'index'
end
end
