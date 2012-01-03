class Admin::HitsController < ApplicationController
  layout "admin"
  before_filter :authenticate_login # protect this area

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @hits_pages, @hits = paginate :hits, :per_page => 10
  end

  def show
    @hits = Hits.find(params[:id])
  end

  def new
    @hits = Hits.new
  end

  def create
    @hits = Hits.new(params[:hits])
    if @hits.save
      flash[:notice] = 'Hits was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @hits = Hits.find(params[:id])
  end

  def update
    @hits = Hits.find(params[:id])
    if @hits.update_attributes(params[:hits])
      flash[:notice] = 'Hits was successfully updated.'
      redirect_to :action => 'show', :id => @hits
    else
      render :action => 'edit'
    end
  end

  def destroy
    Hits.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
