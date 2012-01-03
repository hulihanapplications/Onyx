class Tag < ActiveRecord::Base
 belongs_to :image
 
 validates_presence_of :name
 validates_length_of :name, :maximum => 50, :message => "Please specify a name 50 characters or less."

end
