require 'spec_helper'

describe CategoriesController do
  before(:each) do
    create_ability!
    customer = FactoryGirl.create :customer
    @category = FactoryGirl.create :category
    sign_in customer
  end

  describe "GET #index" do
    context "with read ability" do
      before do
        @ability.can :read, Category
      end
      it "returns an array of categories" do
        get :index 
        expect(assigns(:categories)).to eq [@category]
      end 
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Category
      end
      it "redirects to root_path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #show" do
    context "with read ability" do
      before do
        @ability.can :read, Category
        Author.stub(:find).and_return @category
      end
      it "receives find and return category" do
        expect(Category).to receive(:find).with(@category.id.to_s).and_return @category
        get :show, id: @category.id
      end
      it "assigns category" do
        get :show, id: @category.id
        expect(assigns(:category)).to eq @category
      end
      it "renders template show" do
        get :show, id: @category.id
        expect(response).to render_template("show")
      end
    end
    context "without read ability" do
      before do
        @ability.cannot :read, Category
      end
      it "redirects_to root_path" do
        get :show, id: @category.id
        expect(response).to redirect_to root_path
      end
    end
  end
end
