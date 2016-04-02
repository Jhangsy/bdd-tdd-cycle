require 'spec_helper'

describe MoviesController do
  describe 'Add director Column' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
    it 'should update all changed attributes and redirect to movies_path' do
      @m.stub(:update_attributes!).and_return(true)
      put :update, {:id => "1", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end
  
  describe 'Movies with same director happy path' do
    before :each do
      @m=mock(Movie, :title => "Star Wars", :director => "director", :id => "1")
      Movie.stub!(:find).with("1").and_return(@m)
    end
    
    it 'should generate routing for movies with same director' do
      { :post => same_director_path(1) }.
      should route_to(:controller => "movies", :action => "same_director", :id => "1")
    end
    
    it 'should select the same_director template and display results' do
      Movie.stub!(:same_director).with('director').and_return(@m)
      get :same_director, :id => "1"
      response.should render_template('same_director')
    end
  end
  
  describe 'Movies with same director sad path' do
    before :each do
      m=mock(Movie, :title => "Star Wars", :director => nil, :id => "1")
      Movie.stub!(:find).with("1").and_return(m)
    end
    
    it 'should generate routing for Similar Movies' do
      { :post => same_director_path(1) }.
      should route_to(:controller => "movies", :action => "same_director", :id => "1")
    end
    it 'should redirect_to to movies_path and generate a flash' do
      get :same_director, :id => "1"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end
  
end