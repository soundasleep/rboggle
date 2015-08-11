require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  context "GET index" do
    before :each do
      get :index
    end

    it "exists" do
      assert_response :ok
    end
  end
end
