describe Ppendvalidation do
  include Ppendvalidation
  include Auxvalidation

  #Reminder:
  # ppend_valid?(key,bytes,value)
  # data = Memdata.new(flag,timeToLive,bytes,value)

  context "Successful validation" do
    before(:all) do
      Memdata.create_memdata("app","0","1","3","val")
    end
    it "Existent unexpired key and correct parameters " do
      statusCode = ppend_valid?("app","3","val")
      expect(statusCode).to eq 0
    end
  end

  context "Not successful validation" do

    context "An esencial field is empty, delpoy error: 'ERROR'" do
      it "key field is empty" do
        statusCode = ppend_valid?("","3","val")
        expect(statusCode).to be 6
      end

      it "bytes field is empty" do
        statusCode = ppend_valid?("ppenD","","val")
        expect(statusCode).to be 6
      end

    end

    context "Bad format, deploy error: 'CLIENT_ERROR:Bad command format'" do
      it "key has spaces between characters" do
        statusCode = ppend_valid?("ppen d","3","val")
        expect(statusCode).to be 1
      end

      it "bytes has non-digit characters" do
        statusCode = ppend_valid?("ppend","A3","val")
        expect(statusCode).to be 1
      end
    end

    context "bytes!=value.length, deploy error: 'CLIENT_ERROR:Bad data chunk '" do
        it "bytes<value.length" do
          statusCode = ppend_valid?("ppend","2","val")
          expect(statusCode).to be 2
        end

        it "bytes>value.length" do
          statusCode = ppend_valid?("ppend","4","val")
          expect(statusCode).to be 2
        end
    end

    context "Append/Preppend requirements not met" do
      it "key does not exist" do
        statusCode = ppend_valid?("ppend","3","val")
        expect(statusCode).to be 3
      end

      it "key exists but is expired" do
        Memdata.create_memdata("app","0","1","3","val")
        sleep(1)
        statusCode = ppend_valid?("app","3","val")
        expect(statusCode).to be 3
      end

    end

  end

end
