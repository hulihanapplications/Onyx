class Admin::UsersController < ApplicationController
  before_filter :authenticate_login , :except => [:login] # protect this area
 
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @users = User.find(:all)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def edit_account
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = '<div class=\"flash_success\">User was successfully updated.</div>'
      redirect_to :action => 'list'
    else
      flash[:notice] = '<div class=\"flash_failure\">User failed to be updated!</div>'
      render :action => 'edit'
    end
  end

  def destroy
    if params[:id].to_i == session[:user][:id].to_i
     flash[:notice] = "<div class=\"flash_failure\">Sorry, You can't delete the user you're logged in as.</div>"
     redirect_to :action => 'list'
    else
     flash[:notice] = "<div class=\"flash_success\">User destroyed successfully!</div>"
     User.find(params[:id]).destroy
     redirect_to :action => 'list'
    end
  end

  # Authentication Functions 

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:username], Digest::SHA256.hexdigest(params[:user][:password]))
       #redirect_to_stored
       session[:logged_in] = "y"
       flash[:notice] = "<div class=\"flash_success\">#{params[:user][:username]} logged in successfully!</div>"
       redirect_to :action => "index", :controller => "main"
      else # authentication failed!
        flash[:notice] = "<div class=\"flash_failure\">&nbsp;Login failed!</div>"
        redirect_to :action => "login", :controller => "../browse"
      end
    end
  end

 def logout
  session[:user] = nil
  reset_session
  flash[:notice] = "<div class=\"flash_success\">&nbsp;You have been logged out! Have a nice day.</div>"
  redirect_to  :action => "index", :controller => "../browse"
 end

end
