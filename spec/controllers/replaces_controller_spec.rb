require 'rails_helper'

RSpec.describe ReplacesController, type: :controller do

  describe "POST #create" do
    before(:each) do
      data = Memdata.new("0","1","2","12")
      Memdata.set_key("Ab23",data)
    end

    context "Successful replace; Renders storage_success" do

      it "Successful replace(1)" do
        post 'create', :params => {:key => "Ab23",:flag => "5",:timeToLive => "200",:bytes => "2",:value => "12"}
        expect(response).to redirect_to(root_path)
      end

      it "Successful replace(2)" do
        post 'create', :params => {:key => "Ab23",:flag => "6",:timeToLive => "0",:bytes => "1",:value => "1"}
        expect(response).to redirect_to(root_path)
      end

      it "Successful replace(3)" do
        post 'create', :params => {:key => "Ab23",:flag => "2",:timeToLive => "100",:bytes => "3",:value => "123"}
        expect(response).to redirect_to(root_path)
      end

    end

    context "Not successful, bad input, redirects to /replace" do

      it "Bad flag input" do
        post 'create', :params => {:key => "Ab23",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "Bad timeToLive input" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "a",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "Bad bytes input" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "a",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "value.length>bytes" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "123"}
        expect(response).to redirect_to("/replace")
      end


    end

    context "Not successful, empty necesary field, redirects to /replace" do
      it "key = nil" do
        post 'create', :params => {:key => "",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "flag = nil" do
        post 'create', :params => {:key => "Ab23",:flag => "",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "timeToLive = nil" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "bytes = nil" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "",:value => "1"}
        expect(response).to redirect_to("/replace")
      end
    end

    context "Not successful, replace conditions not met, redirects to /replace" do
      it "Key didn't already exist" do
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/replace")
      end

      it "Key already expired after one second" do
        sleep(1)
        post 'create', :params => {:key => "Ab23",:flag => "5",:timeToLive => "200",:bytes => "2",:value => "12"}
        expect(response).to redirect_to("/replace")
      end
    end

  end

end
