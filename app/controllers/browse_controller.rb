class BrowseController < ApplicationController
  include SimpleCaptcha::ControllerHelpers  # Load SimpleCaptcha

  
  def create_comment
   if simple_captcha_valid?
    @comment = Comment.new(params[:comment])
    @comment.ip = "#{request.env['REMOTE_ADDR']}"
    if @comment.save # comment was saved successfully
     flash[:notice] = "Comment Added Successfully. Thanks, #{params[:comment][:name]}!<br>"
    end
   else #captcha failed
      flash[:notice] = "<font color=white>Your comment wasn't created, because you entered in the wrong code!</font><br>"
   end
    redirect_to :action => "view", :id => params[:comment][:image_id]
  end

  def index
   @latest_images = Image.find(:all, :order => "created_at DESC", :limit => 5)
   @latest_comments = Comment.find(:all, :order => "created_at DESC", :limit => 5)
   #@popular_images = Image.find(:all)
   @welcome_title = get_setting("welcome_title") 
   @welcome_message = get_setting("welcome_message") 
  end
 
  def login

  end
  
  def view_category
   begin
    @category = Category.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:notice] = "Category Not Found!"
    logger.info("Failed Category lookup ID:#{params[:id]}")
    redirect_to :action => "index"
   end
   @meta_title = @category.name + " Images - #{@category.description} -  #{@meta_title}"
   @images_in_category =  Image.find(:all, :conditions => [ "category_id = ?", params[:id] ], :limit => 1000, :order => "created_at DESC")
   @image = @images_in_category[0] # grab the first image
  end 

  def view
   @offset = params[:offset].to_i ||= 0 # set the query starting point, for pagination

   begin
    @image = Image.find(params[:id], :offset => @offset)
   rescue ActiveRecord::RecordNotFound
    logger.info("Failed Image lookup ID:#{params[:id]}")
    flash[:notice] = "Image Not Found!"
    #render :text => "Not found"
    #redirect_to :action => "index"
   end
     
    # print meta tags & title 
    if @image.description != "None"
     @meta_title = @image.url + " - " + @image.description + " - #{@meta_title}"
    else 
      @meta_title = @image.url + " - #{@meta_title}"
   end 
    
    @meta_keywords = @image.url + ", #{@image.description}"
    @dummy_watermark_enabled = get_setting("dummy_watermark_enabled")
    @meta_desc = @image.url + ", #{@image.description}"
    @images_in_category = Image.find(:all, :conditions => ["category_id = ?", @image.category.id], :select => "id, url, description")
    @random_pinkies = Image.find(:all, :conditions => ["category_id = ?", @image.category.id], :limit => 100)
    @count, @next, @last = 1

    for image in @images_in_category #run a counter through x images, to see which image this is in line
      if image.id == @image.id 
       if @count != @images_in_category.size #if this isn't the last image, add the next id
        @next = @images_in_category[@count].id 
       end 
       break 
      else 
       @last = image.id 
       @count += 1
      end
    end
  end
  
  def view_plain_thumbnail
   @image = Image.find(params[:id])  
   render :layout => false
  end
  
  def rss
    @site_url = request.env["HTTP_HOST"]
    headers["Content-Type"] = "application/xml"
    @images = Image.find(:all, :limit => 10 , :order => "created_at DESC")
    render :layout => false
  end
 
  def slideshow
  end
  
  def tag
   @other_tags = Tag.find(:all, :conditions => ["name = ?", params[:tag]], :order => "created_at DESC")
   @first_tag = @other_tags[0]
   @meta_title = "Images tagged #{params[:tag]}" + " - #{@meta_title}"
  end   

  private

end
