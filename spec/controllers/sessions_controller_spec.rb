require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  context "when not logged in" do
    context "POST destroy" do
      it "redirects" do
        post :destroy
        assert_response :redirect
      end
    end

    context "GET new" do
      it "exists" do
        get :new
        assert_response :ok
      end
    end
  end
end
