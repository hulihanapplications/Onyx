class Image < ActiveRecord::Base
 before_destroy :delete_comments
 before_destroy :delete_files
 before_destroy :delete_tags
 
 belongs_to :user
 belongs_to :category 
 has_one :hit
 has_many :comments
 has_many :tags


 validates_presence_of :url, :thumb_url
 validates_uniqueness_of :url, :thumb_url, :message => "There is already an image in the gallery with this same filename!" 
 
 # protect attributes from bulk assignment, eg: new()
 attr_accessible :description , :category_id, :width, :height, :created_at, :updated_at # allow bulk override of these

 def delete_comments
  for comment in self.comments
   comment.destroy
  end
 end 

 def delete_files
    message = "" 

    image_path = "#{RAILS_ROOT}/public/images/normal" + "/" + self.url
    thumb_path = "#{RAILS_ROOT}/public/images/thumbnails" + "/" + self.thumb_url
    pinky_path = "#{RAILS_ROOT}/public/images/pinky" + "/" + self.pinky_url

    if File.exists?(image_path) # does the file exist?
     FileUtils.rm(image_path) # delete the file
    else # file doesn't exist
     self.errors.add('error', "I couldn't find the file: #{self.url} in the images directory! Continuing...<br>")
    end

    if File.exists?(thumb_path) # does the file exist?
     FileUtils.rm(thumb_path) # delete the file
    else # file doesn't exist
     self.errors.add('error',  "I couldn't find the file: #{self.thumb_url} in the thumbnail directory! Continuing...<br>")
    end

    if File.exists?(pinky_path) # does the file exist?
     FileUtils.rm(pinky_path) # delete the file
    else # file doesn't exist
     self.errors.add('error', "I couldn't find the file: #{self.pinky_url} in the pinky directory! Continuing...<br>")
    end

#    self.destroy

    return message
 end

 def delete_tags
  for tag in self.tags
   tag.destroy
  end
 end 

end
