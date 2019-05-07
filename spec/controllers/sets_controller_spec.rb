require 'rails_helper'

RSpec.describe SetsController, type: :controller do

  describe 'POST #create' do
    context "Successful set; Renders storage_success" do

      it "Successful set(1)" do
        post 'create', :params => {:key => "Ab23",:flag => "0",:timeToLive => "3000",:bytes => "10",:value => "1234567890"}
        expect(response).to redirect_to(root_path)
      end

      it "Successful set(2)" do
        post 'create', :params => {:key => "0",:flag => "0",:timeToLive => "0",:bytes => "0",:value => ""}
        expect(response).to redirect_to(root_path)
      end

      it "Successful set(3)" do
        post 'create', :params => {:key => "mnS2",:flag => "12",:timeToLive => "3",:bytes => "3",:value => "123"}
        expect(response).to redirect_to(root_path)
      end

      it "Overrides previous data specified to the key" do
        post 'create', :params => {:key => "mnS2",:flag => "12",:timeToLive => "3",:bytes => "3",:value => "123"}
        post 'create', :params => {:key => "mnS2",:flag => "0",:timeToLive => "2",:bytes => "5",:value => "2"}
        expect(response).to redirect_to(root_path)
      end
    end

    context "Not successful, bad input, redirects to /set" do
      it "Bad flag input" do
        post 'create', :params => {:key => "1",:flag => "a",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/set")
      end

      it "Bad timeToLive input" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "a",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/set")
      end

      it "Bad bytes input" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "1",:bytes => "a",:value => "1"}
        expect(response).to redirect_to("/set")
      end

      it "value.length>bytes" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "123"}
        expect(response).to redirect_to("/set")
      end


    end

    context "Not successful, empty necesary field, redirects to /set" do
      it "key = nil" do
        post 'create', :params => {:key => "",:flag => "1",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/set")
      end

      it "flag = nil" do
        post 'create', :params => {:key => "1",:flag => "",:timeToLive => "1",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/set")
      end

      it "timeToLive = nil" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "",:bytes => "1",:value => "1"}
        expect(response).to redirect_to("/set")
      end

      it "bytes = nil" do
        post 'create', :params => {:key => "1",:flag => "1",:timeToLive => "1",:bytes => "",:value => "1"}
        expect(response).to redirect_to("/set")
      end
    end

  end
end



#  before do
#    assign(:key, '10')
#    assign(:bytes, "1")
#    assign(:flag, "0")
#    assign(:timeToLive, "10")
#    assign(:value, "10")
#  end
#  describe '#create' do
#    it "Creates new 'data' and assigns it to a specific key" do
#
#      expect(Memdata.get_data(assigns(:key))).to eq @data
#    end
#  end
#end
