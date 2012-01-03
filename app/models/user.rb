class User < ActiveRecord::Base
require 'digest/sha2'
#Relationships
has_many :images


#-------------validations-----------------------
validates_uniqueness_of :username, :message => "This email address is already taken!<br>" #this will comb through the database and make sure email is unique
validates_presence_of :first_name, :password, :message => "This field is required!"
validates_confirmation_of :password, :message => ": Passwords Do Not Match!" #this will confirm the password, but you have to have an html input called password_confirmation
validates_length_of :username, :maximum => 255, :message => "Your Email address is too LONG!"
#-----------------------------------------------


#------------Login Authentication---------------
def self.authenticate(login, pass)
  u=find(:first, :conditions => ["username = ? and password_hash = ?", login, pass] )#check email column with the pass arg
  return nil if u.nil? 
  return u
end  
#----------------------------------------------- 

attr_accessor :password_confirmation, :password#these are the database columns, which are pulled from param
attr_accessor :extra

#--------Encrypt Password-------------------------
# make sure you're doing attr_accessor before this
def password=(pass)
  @password = pass 
  self.password_hash = Digest::SHA256.hexdigest(pass)
end
#-------------------------------------------------

end
