# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_onyx_session_id'

  before_filter :load_settings

# Admin Actions -------------------------------------------------------------
 # Dave: this action is only used for filter checks in admin/* controllers.
 # All login/logout functions are handled by admin/user controller.
 # The login form is located in the browse controller, login action. Usually I put the form in the admin area, but I don't want the non-logged-in users to see the admin menu in this case, since it is stored in the admin layout.
	
 def authenticate_login
  if session[:user].nil? #There's definitely no user logged in
   flash[:notice] = "<div class=\"flash_failure\">&nbsp;You are not logged in!</div>"
   redirect_to :action => "login", :controller => "../browse"
  else #there's a user logged in, but what type is he?
    @user = User.find(session[:user][:id]) # make sure user is in db, make sure they're not spoofing a session id
    if @user.nil?
     flash[:notice] = "<div class=\"flash_failure\">&nbsp;You are not logged in!</div>"
     redirect_to :action => "login", :controller => "../browse"
    else
     #session passed too!
    end
  end
 end

# --------------------------------------------------------------------------

 def index
 end

private 
  # this will grab the errors, like error_messages_for, but for controllers
  def get_errors_for(object) #format errors
   if object.errors
    @string = "<div class=\"flash_failure\">There was a problem! Details:<br>"
     object.errors.each do |error, message|
     @string +=  "&nbsp;&nbsp;&nbsp;(#{error}) : #{message}<br>"
    end
    @string += "</div>"
    return @string
   end
  end

  def get_setting(name) # get a setting
   @setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   return @setting.value
  end


  def load_settings
   #@site_url = get_setting("site_url")
   @title = get_setting("site_title")
   @meta_title = get_setting("site_title")
   @meta_keywords = get_setting("site_keywords")
   @meta_desc = get_setting("site_description")
   @tooltips_enabled = get_setting("tooltips_enabled")
   @tooltip_width = get_setting("tooltip_width")
   @theme = get_setting("theme")
  end


end
