namespace :onyx do


 desc "Erase All Image Files"
 task :erase_image_files do
      path = "#{RAILS_ROOT}/public/images/normal/*" 
      FileUtils.rm(path) # delete the files
      path = "#{RAILS_ROOT}/public/images/thumbnails/*" 
      FileUtils.rm(path) # delete the files
      path = "#{RAILS_ROOT}/public/images/pinky/*" 
      FileUtils.rm(path) # delete the files
 end

end
