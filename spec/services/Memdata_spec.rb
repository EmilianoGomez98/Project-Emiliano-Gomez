describe Memdata do

  before(:each) do
    @data = Memdata.new("0","1","3","val")
    @expectedExpTime = Time.now +  1.seconds
    Memdata.set_key("Ab23",@data)
  end

    context "creating new memdata" do


      it "creates new data with correct flag field" do
        expect(@data).to have_attributes(flag: '0')
      end

      it "creates new data with correct expTime field" do
        expect(@data).to have_attributes(expTime: @expectedExpTime )
      end

      it "creates new data with correct bytes field" do
        expect(@data).to have_attributes(bytes: 3)
      end

      it "creates new data with correct value field" do
        expect(@data).to have_attributes(value: 'val')
      end

      it "sets the data to specified key correctly" do
        expect(Memdata.get_data("Ab23")).to equal @data
      end

    end

    context "looking for info" do

       it "checks if key is expired(false)" do
         expect(Memdata.is_expired?("Ab23")).to be false
       end

       it "checks if key is expired(true)" do
         sleep(1)
         expect(Memdata.is_expired?("Ab23")).to be true
       end

       it "sets new casToken and adds '1' to the casCounter" do
         currentCas = @data.casToken
         @data.change_casToken
         expect(currentCas+1).to be @data.casToken
       end
    end

    context "deletes expired keys" do
      it "deletes key if expired" do
        sleep(1)
        if Memdata.is_expired?("Ab23")
          Memdata.delete_expired("Ab23")
        end
        expect(Memdata.get_data("Ab23")).to eq nil
      end
    end



end
