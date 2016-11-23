class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_with_same_director(movie)
    raise ArgumentError if movie.director.blank?
    Movie.all.where(director: movie.director)
  end  
end
