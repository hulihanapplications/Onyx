class Admin::MainController < ApplicationController

 before_filter :authenticate_login # protect this area

 def index
 end

end
