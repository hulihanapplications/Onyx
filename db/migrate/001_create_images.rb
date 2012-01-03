class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :url, :string
      t.column :thumb_url, :string
      t.column :pinky_url, :string
      t.column :width, :string, :default => "0"
      t.column :height, :string, :default => "0" 
      t.column :description, :string, :default => "No Description."
      t.column :category_id, :integer, :default => 1
      t.column :user_id, :integer, :default => 1
      t.column :created_at, :datetime#this will get populated automatically
      t.column :updated_at, :datetime#this will get populated automatically
    end
  end

  def self.down
     #Clear out the actual image dirs
     FileUtils.rm_rf("#{RAILS_ROOT}/public/images/normal")     
     FileUtils.mkdir("#{RAILS_ROOT}/public/images/normal")

     FileUtils.rm_rf("#{RAILS_ROOT}/public/images/thumbnails")     
     FileUtils.mkdir("#{RAILS_ROOT}/public/images/thumbnails")

     FileUtils.rm_rf("#{RAILS_ROOT}/public/images/pinky")     
     FileUtils.mkdir("#{RAILS_ROOT}/public/images/pinky")

     FileUtils.rm_rf("#{RAILS_ROOT}/public/images/tmp")     
     FileUtils.mkdir("#{RAILS_ROOT}/public/images/tmp")

    drop_table :images
  end
end
