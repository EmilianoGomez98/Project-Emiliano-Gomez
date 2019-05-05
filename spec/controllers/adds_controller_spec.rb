require 'rails_helper'

RSpec.describe AddsController, type: :controller do

  describe "POST #create" do

    context "Successful add; Renders storage_success" do
      it "Successful add(1)" do
        post 'create', :params => {:key => "Ab23",:flag => "0",:timeToLive => "3000",:bytes => "10",:value => "1234567890"}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end

      it "Successful add(2)" do
        post 'create', :params => {:key => "0",:flag => "0",:timeToLive => "0",:bytes => "0",:value => ""}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end

      it "Successful add(3)" do
        post 'create', :params => {:key => "mnS2",:flag => "12",:timeToLive => "0",:bytes => "3",:value => "123"}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end

      it "Expired key after 1sec, new one created successfully" do
        post 'create', :params => {:key => "mnS2",:flag => "12",:timeToLive => "1",:bytes => "3",:value => "123"}
        sleep(1)
        post 'create', :params => {:key => "mnS2",:flag => "12",:timeToLive => "5",:bytes => "3",:value => "123"}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end
    end

    context "Not successful, bad input, redirects to /add" do
      it "Bad flag input" do
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/add")
      end

      it "Bad timeToLive input" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "a",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/add")
      end

      it "Bad bytes input" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "1",:bytes => "a",:value => "1"}
        expect(response).to redirect_to("/add")
      end

      it "value.length>bytes" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "123"}
        expect(response).to redirect_to("/add")
      end


    end

    context "Not successful, empty necesary field, redirects to /add" do
      it "key = nil" do
        post 'create', :params => {:key => "",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/add")
      end

      it "flag = nil" do
        post 'create', :params => {:key => "1",:flag => "",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/add")
      end

      it "timeToLive = nil" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/add")
      end

      it "bytes = nil" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "1",:bytes => "",:value => "1"}
        expect(response).to redirect_to("/add")
      end
    end

    context "Not successful, add conditions not met" do
      it "Key already exists" do
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1"}
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/add")
      end
    end

  end


end
