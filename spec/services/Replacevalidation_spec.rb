describe Replacevalidation do
  include Replacevalidation
  include Auxvalidation

  #Remiders:
  #  Memdata.create_memdata(key,flag,timeToLive,bytes,value)
  #  replace_valid?(key,bytes,flag,timeToLive,value)

  before(:all) do
    Memdata.create_memdata("repS","3","5","3","val")
  end

  context "Successful validation" do

    it "Existent unexpired key and correct parameters" do
      statusCode = replace_valid?("repS","3","5","3","val")
      expect(statusCode).to be 0
    end

  end

  context "Not successful validation" do

    context "An esencial field is empty, delpoy error: 'ERROR'" do
        it "key field is empty" do
          statusCode = replace_valid?("","3","5","3","val")
          expect(statusCode).to be 6
        end

        it "bytes field is empty" do
          statusCode = replace_valid?("repS","","5","3","val")
          expect(statusCode).to be 6
        end

        it "flag field is empty" do
          statusCode = replace_valid?("repS","3","","3","val")
          expect(statusCode).to be 6
        end

        it "timeToLive field is empty" do
          statusCode = replace_valid?("repS","3","5","","val")
          expect(statusCode).to be 6
        end

    end

    context "Bad format, deploy error: 'CLIENT_ERROR:Bad command format'" do

      it "key has spaces between characters" do
        statusCode = replace_valid?("rep S","3","5","3","val")
        expect(statusCode).to be 1
      end

      it "bytes has non-digit characters" do
        statusCode = replace_valid?("repS","3AA","5","3","val")
        expect(statusCode).to be 1
      end

      it "flag has non-digit characters" do
        statusCode = replace_valid?("repS","3","5AA","3","val")
        expect(statusCode).to be 1
      end

      it "timeToLive has non-digit characters" do
        statusCode = replace_valid?("repS","3","5","3AA","val")
        expect(statusCode).to be 1
      end
    end

    context "bytes!=value.length, deploy error: 'CLIENT_ERROR:Bad data chunk '" do
      it "bytes<value.length" do
        statusCode = replace_valid?("repS","2","5","3","val")
        expect(statusCode).to be 2
      end

      it "bytes>value.length" do
        statusCode = replace_valid?("repS","4","5","3","val")
        expect(statusCode).to be 2
      end
    end

    context "Replace requirements not met" do

      it "key does not exist" do
        statusCode = replace_valid?("rep","3","5","3","val")
        expect(statusCode).to be 3
      end

      it "key is expired" do
        Memdata.create_memdata("rep","0","1","3","val")
        sleep(1)
        statusCode = replace_valid?("rep","3","0","1","val")
        expect(statusCode).to be 3
      end
    end

  end
end
