require 'rails_helper'

RSpec.describe GetsController, type: :controller do
  describe "POST #show" do
    before(:each) do
      data = Memdata.new("0","1","2","12")
      Memdata.set_key("Ab23",data)
    end

    context "Successfully retrieves data for the given keys" do
      it "Retrieves data for the key selected" do
        post 'show', :params => {:keys => "Ab23"}
        expect(response).to render_template("gets/show", "layouts/application")
      end
    end

    context "Not successful, bad input" do
      it "Key field is empty" do
        post 'show', :params => {:keys => ""}
        expect(response).to redirect_to("/get")
      end
    end

  end
end
