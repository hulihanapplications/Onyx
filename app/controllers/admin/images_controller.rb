class Admin::ImagesController < ApplicationController
  require "RMagick"
  require "net/http"
  require "open-uri"


  before_filter :authenticate_login # protect this area

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @images = Image.find(:all, :order => "created_at DESC")
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
    @categories = Category.find(:all)
    @width = get_setting("uniform_width")
    @height = get_setting("uniform_height")
    @maximum_uploadable_files = get_setting("maximum_uploadable_files")
  end

 
 def create
   counter = 0
   flash[:notice] = ""
   while(params["file_#{counter}".to_s] != "") # the first file is params[:file_0]
     proceed = false
     if params["file_#{counter}".to_s] != ""  && params[:url] == ""  #from their computer
      filename = clean_filename(params["file_#{counter}".to_s].original_filename)
      if check_filename(filename) #the filename isn't valid
       image = Magick::Image.from_blob(params["file_#{counter}".to_s].read).first    # read in image binary
       proceed = true
      else
       flash[:notice] << "<div class=\"flash_failure\">#{params["file_#{counter}".to_s].original_filename} upload failed! Please make sure that this is an image file, and that it ends in .png .jpg .jpeg .bmp or .gif </div> "     
       redirect_to :action => "new"
      end 
  
     elsif params[:url] != "" && params["file_#{counter}".to_s] == ""  #from the web
      filename = clean_filename(File.basename(params[:url]))#.downcase # get the filename only
      if check_filename(filename) #the filename is valid
       @url_file = open(params[:url]) # Open the image from net
       tmp_path = "#{RAILS_ROOT}/public/images/tmp" #location of the tmp folder
       FileUtils.mkdir_p(tmp_path) if !File.exist?(tmp_path) # create the tmp folder if it doesn't exist
       @file = open(tmp_path + "/" + filename, "wb") # open up the new file, binary style
       @file.write(@url_file.read) # copy the image
       if @file # temp file got copied successfully.
        # create files from tmp file
        # Dave: normally, I'd use the create_image or whatever method in this controller, but those are only written to handle file upload forms(it uses original_filename), not actual $
        @file.close
        @file = open(tmp_path + "/" + filename, "rb") #reopen the temp file
        image = Magick::Image.from_blob(@file.read).first    # read in image binary
        # Remove temp image
        FileUtils.rm(tmp_path + "/" + filename)
        proceed = true
       end
      else # filename isn't valid!
       flash[:notice] << "<div class=\"flash_failure\">#{filename} upload failed! Please make sure that this is an image file, and that it ends in .png .jpg .jpeg .bmp or .gif </div> "     
      end
  
     elsif !params[:url].nil? && !params["file_#{counter}".to_s].nil? #they accidentally did both
       flash[:notice] << "<div class=\"flash_failure\">Please select <b>one</b> image, either from your computer or the web, <b>not both.</b></div> "     
     else #random
       flash[:notice] << "random"
     end 
  
     if proceed # name okay, image object created

   
      @image = Image.new(params[:image]) # don't worry, this is protected with attr_accessible
      @image.url = filename
      @image.thumb_url = filename
      @image.pinky_url = filename
     
      #@image.width =  Magick::Image.columns(params[:file])
      if @image.save  # if image record was saved successfully... 
       image = create_image(image, filename) # make image, returns the new version of the image(if there's any effects, so the thumb and pinky have the same effects)
       create_thumbnail(image, filename) # make thumbnail 
       create_pinky(image, filename) # make pinky
       flash[:notice] << "<div class=\"flash_success\">Image: <b>#{filename}</b> added successfully!</div>"     
       if !params[:tag].empty? # a tag was entered
        flash[:notice] << "<div class=\"flash_success\"><br>Tag: #{params[:tag]} added!</div>" if add_tag(params[:tag], @image.id)
       end
      else # save failed
       flash[:notice] = "<div class=\"flash_failure\">Failed saving <b>#{filename}</b>...</font><br>" + get_errors_for(@image)
      end
     end
     counter += 1 
    end # end multiple file upload loop
    redirect_to :action => "new" 
  end
  
  def create_tag
   flash[:notice] = "<br>Tag: #{params[:tag][:name]} added!" if add_tag(params[:tag][:name],params[:tag][:image_id]) 
   redirect_to :action => "edit", :id => params[:tag][:image_id].to_i
  end

  def edit
    @image = Image.find(params[:id])
    @tags = Tag.find(:all, :conditions => ["image_id = ?", @image.id ], :limit => 100)
    @comments = Comment.find(:all, :conditions => ["image_id = ?", params[:id] ], :limit => 1000)
    @categories = Category.find(:all)
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      flash[:notice] = 'Image was successfully updated.'
      redirect_to :action => 'edit', :id => @image
    else
      render :action => 'edit'
    end
  end

  def destroy
    @image = Image.find(params[:id])
    flash[:notice] = "" 
    @image.destroy
    @errors = get_errors_for(@image) if !@image.errors.empty?
    if @errors 
     flash[:notice] += @errors
    end
    flash[:notice] +=  "<div class=\"flash_success\">Image Destroyed Successfully!</div>"
    redirect_to :action => 'list'
  end

  def destroy_comment
   @comment = Comment.find(params[:id], :limit => 1)
   @comment.destroy # delete the comment
   flash[:notice] = "Comment destroyed!<br>"
   redirect_to :action => "edit", :id => params[:image_id]
  end

  def destroy_tag
   @tag = Tag.find(params[:id], :limit => 1)
   @tag.destroy # delete the comment
   flash[:notice] = "Tag destroyed!"
   redirect_to :action => "edit", :id => params[:image_id]
  end



private
 def clean_filename(filename) 
  @bad_chars = ['&', '\+', '%', '!', ' ', '/'] #string of bad characters
  for char in @bad_chars
   filename = filename.gsub(/#{char}/, "_") # replace the bad chars with good ones!
  end
  return filename 
 end
 
 def check_filename(filename)
  extensions = /.png|.jpg|.jpeg|.gif|.bmp|.tiff|.PNG|.JPG|.JPEG|.GIF|.BMP|.TIFF$/ #define the accepted regexs
  return extensions.match(filename)   # return false or true if matched
 end

 def create_image(image, filename)
  #use wb+ or wb to transfer as binary for binary sensitive files(pics, so, etc)
  path = "#{RAILS_ROOT}/public/images/normal"
  FileUtils.mkdir_p(path) if !File.exist?(path)  

  width = get_setting("uniform_width").to_i
  height = get_setting("uniform_height").to_i
  if params[:resize] == "cropped" # make a uniform image?
   image.crop_resized!( width, height )    
  elsif params[:resize] == "proportional"
   image.change_geometry!("#{width}x#{height}") { |cols, rows, img| img.resize!(cols, rows) }
  elsif params[:resize] == "scale"
   image.scale!( width, height )
  elsif params[:resize] == "no" 
  else
  end

  if params[:effect_monochrome] == "yes"
    image = image.quantize(256, Magick::GRAYColorspace)
  end

  if params[:effect_sepia] == "yes"
    image = image.quantize(256, Magick::GRAYColorspace)
    image = image.colorize(0.30, 0.30, 0.30, '#cc9933')
  end

  if params[:effect_watermark] == "yes"
   mark = Magick::Image.new(image.columns, image.rows)

   gc = Magick::Draw.new
   gc.gravity = Magick::CenterGravity
   gc.pointsize = 32
   gc.font_family = "Helvetica"
   gc.font_weight = Magick::BoldWeight
   gc.stroke = 'none'
   gc.annotate(mark, 0, 0, 0, 0, "Protected\r\nPhoto")

   mark = mark.shade(true, 310, 30)

   image.composite!(mark, Magick::CenterGravity, Magick::HardLightCompositeOp)
  end

  if params[:effect_polaroid] == "yes"
	image.border!(10, 10, "#f0f0ff")

	# Bend the image
	image.background_color = "none"

	amplitude = image.columns * 0.01        # vary according to taste
	wavelength = image.rows  * 2

	image.rotate!(90)
	image = image.wave(amplitude, wavelength)
	image.rotate!(-90)

	# Make the shadow
	shadow = image.flop
	shadow = shadow.colorize(1, 1, 1, "gray75")     # shadow color can vary to taste
	shadow.background_color = "white"       # was "none"
	shadow.border!(10, 10, "white")
	shadow = shadow.blur_image(0, 3)        # shadow blurriness can vary according to taste
	
	# Composite image over shadow. The y-axis adjustment can vary according to taste.
	image = shadow.composite(image, -amplitude/2, 5, Magick::OverCompositeOp)
	
	image.rotate!(-5)                       # vary according to taste
	#image.trim!
  end

  if params[:effect_rotate_90_cw] == "yes"
   image = image.rotate!(90)
  end

  if params[:effect_rotate_90_ccw] == "yes"
   image = image.rotate!(-90)
  end

  if params[:effect_rotate_180] == "yes"
   image = image.rotate!(180)
  end

  if params[:effect_gaussian_blur] == "yes"
   image = image.gaussian_blur(0.0, 3.0)
  end

  if params[:effect_negate] == "yes"
   image = image.negate
  end

  image.write("#{path}/#{filename}")      #save the image
  params[:image][:width] = image.columns # set the original width into params 
  params[:image][:height] = image.rows # set the original height into params
  return image
 end 

 def create_thumbnail(image, filename)
  #use wb+ or wb to transfer as binary for binary sensitive files(pics, so, etc)
  path = "#{RAILS_ROOT}/public/images/thumbnails"
  FileUtils.mkdir_p(path) if !File.exist?(path)  
  #file.rewind # rewind the read pointer since create_image was called first
  #image = Magick::Image.from_blob(file.read).first    # read in image binary

  thumbnail_width = get_setting("thumbnail_width").to_i
  thumbnail_height = get_setting("thumbnail_height").to_i
  image.crop_resized!( thumbnail_width, thumbnail_height ) # resize the thumbnail
  image.write("#{path}/#{clean_filename(filename)}")	#save the image
 end 

 def create_pinky(image, filename)
  #use wb+ or wb to transfer as binary for binary sensitive files(pics, so, etc)
  path = "#{RAILS_ROOT}/public/images/pinky"
  FileUtils.mkdir_p(path) if !File.exist?(path)  
  image.crop_resized!( 20, 20 )
  image.write("#{path}/#{clean_filename(filename)}")	#save the image
 end 

 def add_tag(name, image_id)
   @tag = Tag.new(:name => name, :image_id => image_id)
   if @tag.save
    return true
   else
    return false
   end
 end

end
