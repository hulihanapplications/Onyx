class Comment < ActiveRecord::Base
 belongs_to :image

 validates_presence_of :name, :message => "No Name Specified<br>"
 validates_presence_of :comment, :message => "No Comment Specified<br>"
end
