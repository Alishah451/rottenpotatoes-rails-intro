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
    @all_ratings = Movie.ratings
    @selectedRatings = @all_ratings
    
    if params[:ratings] then
      @selectedRatings = params[:ratings].keys
      @movies = Movie.where({rating: @selectedRatings})
      session[:ratings] = params[:ratings]
    elsif session[:ratings] then
      @selectedRatings = session[:ratings].keys
      @movies = Movie.where({rating: @selectedRatings})
      redirect_bool = true   
    else
      @movies = Movie.all
    end

    if params[:sortBy] == 'title' then
      # @movies = Movie.where({rating: @selectedRatings})
      @movies = @movies.order(:title)
      session[:sortBy] = params[:sortBy]
      
    elsif params[:sortBy] == 'release_date' then
      # @movies = Movie.where({rating: @selectedRatings})
      @movies = @movies.order(:release_date)
      session[:sortBy] = params[:sortBy]
      
    elsif session[:sortBy] == 'title' then
      # @movies = Movie.where({rating: @selectedRatings})
      @movies = @movies.order(:title)
      redirect_bool = true       
    elsif params[:sortBy] == 'release_date' then
      # @movies = Movie.where({rating: @selectedRatings})
      @movies = @movies.order(:release_date)
      redirect_bool = true       
    end
    
    if redirect_bool == true then
      flash.keep
      redirect_to(movies_path(:ratings => session[:ratings], :sortBy => session[:sortBy]))
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
