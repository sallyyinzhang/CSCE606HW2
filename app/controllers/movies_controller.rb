class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    #part 1
    @movies = Movie.all
    
    if params[:choose_title]=='yes'
      session[:title]='hilite'
      session[:release_date]=""
    elsif params[:choose_release_date]=="yes"
      session[:title]=""
      session[:release_date]="hilite"
    else
      session[:title]=""
      session[:release_date]=""
    end
 
    if session[:title]=="hilite"
     @movies = @movies.all.order(:title)
    elsif session[:release_date]=="hilite"
     @movies = @movies.all.order(:release_date)
    end
  
  #part 2
  #enumerable collection of all possible values of a movie rating
   @all_ratings = Movie.distinct.pluck(:rating)
    
    if params[:ratings]!=nil
     session[:checked]=params[:ratings]
    end
    
    if session[:checked]==nil
      session[:checked]=Hash.new()
      @all_ratings.each do |rating|
      session[:checked][rating]=1
      end
    end
    
    #returns an appropriate value for this collection.
    @movies = @movies.where({rating: session[:checked].keys})
    
    if session[:title]=="hilite" and params[:choose_title]==nil 
      params[:choose_title]="yes"
      redirect_to movies_path(params)
    elsif session[:release_date]=="hilite" and params[:choose_release_date]==nil
      params[:choose_release_date]="yes"
      redirect_to movies_path(params)
    elsif params[:ratings]==nil and session[:checked]!=nil
      params[:ratings]=session[:checked]
      flash.keep
      redirect_to movies_path(params)
    end
    
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
