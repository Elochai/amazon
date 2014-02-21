require 'spec_helper'

describe Customers::OmniauthCallbacksController do

  describe "GET 'facebook'" do
    it "returns http success" do
      get 'facebook'
      response.should be_success
    end
  end

end
