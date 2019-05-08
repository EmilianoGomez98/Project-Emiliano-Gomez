require 'rails_helper'

RSpec.describe AppendsController, type: :controller do
  describe "POST #create" do
    before(:each) do
      Memdata.create_memdata("Ab23","0","1","2","12")
    end

    context "Successful append; Renders storage_success" do

      it "Successful append(1)" do
        post 'create', :params => {:key => "Ab23",:bytes => "2",:value => "12"}
        expect(response).to redirect_to(root_path)
      end

      it "Successful append(2)" do
        post 'create', :params => {:key => "Ab23",:bytes => "1",:value => "1"}
        expect(response).to redirect_to(root_path)
      end

      it "Successful append(3)" do
        post 'create', :params => {:key => "Ab23",:bytes => "3",:value => "123"}
        expect(response).to redirect_to(root_path)
      end

    end

    context "Not successful, bad input, redirects to /append" do

      it "Bad bytes input" do
        post 'create', :params => {:key => "Ab23",:bytes => "a",:value => "1"}
        expect(response).to redirect_to("/append")
      end

      it "value.length>bytes" do
        post 'create', :params => {:key => "Ab23",:bytes => "1",:value => "123"}
        expect(response).to redirect_to("/append")
      end

      it "value.length<bytes" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "3",:value => "12"}
        expect(response).to redirect_to("/append")
      end
    end

    context "Not successful, empty necesary field, redirects to /append" do
      it "key = nil" do
        post 'create', :params => {:key => "",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/append")
      end

      it "bytes = nil" do
        post 'create', :params => {:key => "Ab23",:bytes => "",:value => "1"}
        expect(response).to redirect_to("/append")
      end
    end

    context "Not successful, append conditions not met, redirects to /append" do
      it "Key didn't already exist" do
        post 'create', :params => {:key => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/append")
      end

      it "Key already expired after one second" do
        sleep(1)
        post 'create', :params => {:key => "Ab23",:bytes => "2",:value => "12"}
        expect(response).to redirect_to("/append")
      end
    end
  end
end
