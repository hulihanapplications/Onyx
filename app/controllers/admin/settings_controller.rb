class Admin::SettingsController < ApplicationController
  before_filter :authenticate_login # protect this area

  def index
   @settings = Setting.find(:all, :conditions => ["item_type != ?", "custom"], :limit => 1000)
   @themes = Array.new
   themes_folder = RAILS_ROOT + "/public/themes" # the folder containing the themes
   Dir.new(themes_folder).entries.each do |file|
     if (file.to_s != ".") && (file != "..")
      @themes << file
     end 
   end

  end
  
  def list
   redirect_to :action => "index"
  end

  def update
   flash[:notice] = "" 
   params[:setting].each do |name, value| 
    # Dave: here were are querying the db once for EVERY setting in the table, just to get the setting name.
    # This is a little costly, the alternative being a find(:all) that is indexed with a integer-style counter
    # ie: @settings[counter], but the problem is that if the settings in the html form are listed in any 
    # different order, updating will do nothing, since the form setting and the indexed find(:all) won't match.
    # In the long run, this won't be too bad, since the size of the settings table shouldn't be very large(< 100)
    @setting = Setting.find(:first, :conditions => ["name = ?", name]) 
    if @setting.value != value # the value of the setting has changed
     if @setting.update_attribute("value", value) # update the setting
      flash[:notice] << "The setting(#{name}) was updated!<br>"
     else
      flash[:notice] << "<font color=red>The setting(#{name}) failed updating!</font><br>"
     end
    else
     flash[:notice] << "<font color=grey>The Setting(#{name}) has not changed.<br></font>"
    end
   end
   redirect_to :action => "index"
  end

  def update_theme # change the theme of onyx
   flash[:notice] = "" 
    @setting = Setting.find(:first, :conditions => ["name = ?", "theme"]) 
     if @setting.update_attribute("value", params[:theme]) # update the setting
      flash[:notice] << "The Theme is now set to (#{@setting.value}).<br>"
     else
      flash[:notice] << "The Theme could not be saved.<br>"
     end
   redirect_to :action => "index"
  end

  def update_faster
    # Dave: this is the faster updater described above. This find(:all) here and the find(:all) in the 
    # form MUST match or this will do nothing, as the params array will be in a different order
    @settings = Settings.find(:all)
    @counter = 0
    params[:setting].each do |name, value|
     if @settings[@counter].name == name and @settings[@counter].value != value # the value changed!
      @setting = Setting.find(:first, :conditions => ["name = ?", name])
      if @setting.update_attribute("value", value)
       flash[:notice] << "The setting: #{name} was updated!<br>"
      else
       flash[:notice] << "<font color=red>The setting: #{name} failed update!</font><br>"
      end
     end 
     @counter += 1
    end
    redirect_to :action => "index"
  end 

end
