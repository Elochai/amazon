require 'spec_helper'

describe AuthorsController do
  before(:each) do
    customer = FactoryGirl.create :customer
    @author = FactoryGirl.create :author
    sign_in customer
  end

  describe "GET #index" do
    it "returns an array of authors" do
      get :index 
      expect(assigns(:authors)).to eq [@author]
    end 
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    before(:each) do
      Author.stub(:find).and_return @author
    end
    it "receives find and return author" do
      expect(Author).to receive(:find).with(@author.id.to_s).and_return @author
      get :show, id: @author.id
    end
    it "assigns author" do
      get :show, id: @author.id
      expect(assigns(:author)).to eq @author
    end
    it "renders template show" do
      get :show, id: @author.id
      expect(response).to render_template("show")
    end
  end
end
