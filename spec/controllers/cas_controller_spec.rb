require 'rails_helper'

RSpec.describe CasController, type: :controller do

  describe "POST #create" do
    before(:each) do
      # data fields
      # => flag : "0"
      # => timeToLive : "1"
      # => bytes : "2"
      # => value : "12"
      # Assigned key : "Ab23"
      data = Memdata.new("0","1","2","12")
      Memdata.set_key("Ab23", data)
      @token = data.casToken
    end

    context "Successful cas; Renders storage_success" do

      it "Successful cas(1)" do
        post 'create', :params => {:key => "Ab23",:flag => "5",:timeToLive => "200",:bytes => "2",:value => "12",:casToken =>@token}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end

      it "Successful cas(2)" do
        post 'create', :params => {:key => "Ab23",:flag => "6",:timeToLive => "0",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end

      it "Successful cas(3)" do
        post 'create', :params => {:key => "Ab23",:flag => "2",:timeToLive => "100",:bytes => "3",:value => "123",:casToken =>@token}
        expect(response).to render_template("pages/storage_success", "layouts/application")
      end

    end

    context "Not successful, bad input, redirects to /cas" do

      it "Bad flag input" do
        post 'create', :params => {:key => "Ab23",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "Bad timeToLive input" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "a",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "Bad bytes input" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "a",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "value.length>bytes" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "123",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end


    end

    context "Not successful, empty necesary field, redirects to /cas" do
      it "key = nil" do
        post 'create', :params => {:key => "",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "flag = nil" do
        post 'create', :params => {:key => "Ab23",:flag => "",:timeToLive => "1",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "timeToLive = nil" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "bytes = nil" do
        post 'create', :params => {:key => "Ab23",:flag => "1",:timeToLive => "1",:bytes => "",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end
    end

    context "Not successful, cas conditions not met, redirects to /cas" do
      it "Key didn't already exist" do
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "Key already expired after one second" do
        sleep(1)
        post 'create', :params => {:key => "Ab23",:flag => "5",:timeToLive => "200",:bytes => "2",:value => "12",:casToken =>@token}
        expect(response).to redirect_to("/cas")
      end

      it "Bad casToken" do
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1",:casToken =>"230"}
        expect(response).to redirect_to("/cas")
      end
    end

  end

end
