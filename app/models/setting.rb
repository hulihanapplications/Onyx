class Setting < ActiveRecord::Base
 validates_uniqueness_of :name
 validates_presence_of :name, :value
  
 def validate
 end
 

end
