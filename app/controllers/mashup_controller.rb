class MashupController < ApplicationController
  def index
    if session[:auth] != true
          redirect_to :controller=>'users', :action=> 'index'
    end
    if session[:auth] == true
          redirect_to :controller=>'mashup', :action=> 'start'
    end
  end
  def start
        if session[:auth] != true
          redirect_to :controller=>'users', :action=> 'index'
    end
  
  end
end
 
 
 # Code to save the file ...................... 
  # @state = "#{Time.new} #{params[:url]}"
   #@key =  Digest::SHA1.hexdigest @state
   #@msg = "Your Key = #{@key}"
   #    post = DataFile.save(@key)
   #@user = Mashup.new(:key => @key, :url => params[:url], :user => session[:username])  
   #         if @user.save  
   #           @notice = 'The License has been saved ... '
   #           
   #         else  
   #           @notice = 'OoPs ! something went wrong!'  
   #       end