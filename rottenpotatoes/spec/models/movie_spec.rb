require 'rails_helper'

describe Movie do
  describe 'finding movies with same director' do
    context 'movie has a director' do
      let(:current_movie) { instance_double(Movie, :id => 1, :title => 'test', :director => 'test-title', :rating => "G", :description => 'test-description',) }
      it 'queries the db for any further movies with director' do
        expect(Movie).to receive_message_chain(:all,:where).with(hash_including(director: current_movie.director))
        Movie.find_with_same_director(current_movie)
      end  
    end
    context 'movie has no director' do
      let(:current_movie) { instance_double(Movie, :id => 1, :title => 'test', :director => '', :rating => "G") }
      it 'throws an exception when there is no director' do
        expect {Movie.find_with_same_director(current_movie)}.to raise_error(ArgumentError)
      end  
    end
  end
end