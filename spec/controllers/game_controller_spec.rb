require 'rails_helper'

RSpec.describe GameController, type: :controller do
  context "when not logged in" do
    context "POST create" do
      it "redirects to a login page" do
        post :create
        assert_response :redirect
      end
    end
  end
end
