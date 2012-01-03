class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t| 
      t.column :name, :string
      t.column :setting_type, :string
      t.column :value, :string
      t.column :description, :string
      t.column :item_type, :string
    end
   #add a name index, since we'll do most of our searching on the name field
   add_index :settings, :name, :unique => true # unique on, since each name field should be unique

   #populate default settings
   #Setting.create(:name => "site_url", :value => "http://www.example.com", :setting_type => "public", :description => "The url of your gallery, example: http://www.example.com NO TRAILING SLASH!", :item_type => "string")
   Setting.create(:name => "site_title", :value => "My Onyx Gallery", :setting_type => "public", :description => "The Title of your Site", :item_type => "string")
   Setting.create(:name => "site_keywords", :value => "Ruby on Rails Gallery, open source, ruby on rails, gallery, onyx gallery, gallery software, hulihan applications", :setting_type => "public", :description => "The Keywords Metatag for your site. Used for search engine submission", :item_type => "string")
   Setting.create(:name => "site_description", :value => "Onyx is an open source free ruby on rails gallery written by Hulihan Applications. It is designed to be easy to use, flexible and customizable.", :setting_type => "public", :description => "The Description Metatag for your site. Used for search engine submission", :item_type => "string")
   Setting.create(:name => "welcome_title", :value => "Welcome!", :setting_type => "public", :description => "The Welcome Message title that shows on the gallery homepage", :item_type => "string")
   Setting.create(:name => "welcome_message", :value => "Welcome to my gallery! Take a look around, leave a comment, and let me know what you think!", :setting_type => "public", :description => "This is the welcome message that shows on the gallery homepage.", :item_type => "string")
   Setting.create(:name => "uniform_width", :value => "500", :setting_type => "public", :description => "This is the width you want your images(of your choice) to be automatically resized to.", :item_type => "string")
   Setting.create(:name => "uniform_height", :value => "500", :setting_type => "public", :description => "This is the height you want your images(of your choice) to be automatically resized to.", :item_type => "string")
   Setting.create(:name => "thumbnail_width", :value => "100", :setting_type => "public", :description => "This is the width you want your thumbnail images(in pixels) to be automatically resized to.", :item_type => "string")
   Setting.create(:name => "thumbnail_height", :value => "100", :setting_type => "public", :description => "This is the height you want your thumbnail images(in pixels) to be automatically resized to.", :item_type => "string")
   Setting.create(:name => "dummy_watermark_enabled", :value => "0", :setting_type => "public", :description => "This Enables an HTML Dummy Watermark over images. This is not a true watermark, it is designed to fool users without HTML experience. The actual image can still be viewed by a knowledgable user.", :item_type => "bool")
   Setting.create(:name => "tooltips_enabled", :value => "1", :setting_type => "public", :description => "This enables tooltips when your mouse hovers over an image. This will make pages load a tiny bit slower, due to the extra code.", :item_type => "bool")
   Setting.create(:name => "tooltip_width", :value => "300", :setting_type => "public", :description => "This sets the size(in px) of the tooltips(if enabled). ", :item_type => "string")
   Setting.create(:name => "maximum_uploadable_files", :value => "10", :setting_type => "public", :description => "This is the number of files you can upload at one time.", :item_type => "string")
   Setting.create(:name => "theme", :value => "mocha", :setting_type => "public", :description => "The Visual Theme of your gallery, the look and feel", :item_type => "custom")
  end

  def self.down
    drop_table :settings
  end
end
  
