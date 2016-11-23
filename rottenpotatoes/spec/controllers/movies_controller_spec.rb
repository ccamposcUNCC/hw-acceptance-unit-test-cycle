require 'rails_helper'

describe MoviesController do
    
    before :each do
       @movie_class = class_double('Movie').as_stubbed_const
       @movie_attributes = {:title => 'a', :rating => 'a', :description => 'a', :release_date => '2016-03-13', :director => 'a'}
    end  
    describe 'Find Movies With Same Director' do
        
        before :each do
           @fake_results = [double('movie1'), double('movie2')]
           #@movie_class = class_double('Movie').as_stubbed_const
           @current_movie = double('movie')
           allow(@movie_class).to receive(:find).and_return(@current_movie)  
        end  
        
        it 'calls the model method that performs the movie search' do
           expect(@movie_class).to receive(:find_with_same_director).with(@current_movie).and_return(@fake_results)
           get :search_with_same_director, {id: '1'}
        end
        context 'movie has a director' do
            it 'selects the Search Results template for rendering' do
               allow(@movie_class).to receive(:find_with_same_director).and_return(@fake_results)
               get :search_with_same_director, {id: '1'}    
               expect(response).to render_template('search_with_same_director')
            end
            it 'makes the search results available to that template' do
               allow(@movie_class).to receive(:find_with_same_director).and_return(@fake_results)
               get :search_with_same_director, {id: '1'}   
               expect(assigns(:movies)).to eq(@fake_results)
            end    
        end
        context 'movie has no director' do
            subject { get :search_with_same_director, {id: '1'} }
            it 'redirects to home' do
                fake_movie = double('movie')
                allow(fake_movie).to receive(:director).and_return('')
                allow(fake_movie).to receive(:title).and_return('test-title')
                allow(@movie_class).to receive(:find).and_return(fake_movie) 
                allow(@movie_class).to receive(:find_with_same_director).and_raise(ArgumentError)
                expect(subject).to redirect_to(movies_path)
            end    
        end
    end
    describe 'create movie' do
        let(:new_movie) { instance_double(Movie, :title => 'a') } 
        it 'creates a movie' do
            
            expect(@movie_class).to receive(:create!).with(@movie_attributes).and_return(new_movie)
            post :create, {:movie => @movie_attributes}
        end
        let(:new_movie) { instance_double(Movie, :title => 'a') }
        it 'redirects to home' do
            allow(@movie_class).to receive(:create!).with(@movie_attributes).and_return(new_movie)
            post :create, {:movie => @movie_attributes}
            expect(response).to redirect_to movies_path
        end
    end
    
    describe 'update movie' do
        
        let(:current_movie) { instance_double(Movie, :id => 1, :title => 'a') }
        it 'updates a movie' do
            allow(@movie_class).to receive(:find).with("1").and_return(current_movie)
            expect(current_movie).to receive(:update_attributes!).with(@movie_attributes)
            put :update, {:id => 1, :movie => @movie_attributes}
        end
        let(:current_movie) { instance_double(Movie, :title => 'a') }
        it 'redirects to home' do
            allow(@movie_class).to receive(:find).with("1").and_return(current_movie)
            allow(current_movie).to receive(:update_attributes!).with(@movie_attributes)
            put :update, {:id => 1, :movie => @movie_attributes}
            expect(response).to redirect_to movie_path(current_movie)
        end
    end
    describe 'delete movie' do
        
        let(:current_movie) { instance_double(Movie, :id => 1, :title => 'a') }
        it 'deletes the movie' do
            allow(@movie_class).to receive(:find).with("1").and_return(current_movie)
            expect(current_movie).to receive(:destroy)
            delete :destroy, {:id => 1, :movie => @movie_attributes}
        end
    end
    
    describe 'show movies' do
        it 'assigns hilite css class for title' do
            all_ratings = ['rating1', 'rating2']
            allow(@movie_class).to receive(:all_ratings).and_return(all_ratings)
            allow(@movie_class).to receive(:where)
            get :index, {:sort => 'title'}
            expect(assigns(:title_header)).to eq 'hilite'
        end   
        
        it 'assigns hilite css class for release_date' do
            all_ratings = ['rating1', 'rating2']
            allow(@movie_class).to receive(:all_ratings).and_return(all_ratings)
            allow(@movie_class).to receive(:where)
            get :index, {:sort => 'release_date'}
            expect(assigns(:date_header)).to eq 'hilite'
        end  
    end
end