require 'spec_helper'

describe CategoriesController do
  before(:each) do
    customer = FactoryGirl.create :customer
    @category = FactoryGirl.create :category
    sign_in customer
  end

  describe "GET #index" do
    it "returns an array of categories" do
      get :index 
      expect(assigns(:categories)).to eq [@category]
    end 
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    before(:each) do
      Category.stub(:find).and_return @category
    end
    it "receives find and return category" do
      expect(Category).to receive(:find).with(@category.id.to_s).and_return @category
      get :show, id: @category.id
    end
    it "assigns author" do
      get :show, id: @category.id
      expect(assigns(:category)).to eq @category
    end
    it "renders template show" do
      get :show, id: @category.id
      expect(response).to render_template("show")
    end
  end
end
