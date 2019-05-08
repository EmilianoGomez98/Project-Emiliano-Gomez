describe Casvalidation do
  include Casvalidation
  include Auxvalidation

  #Reminders:
  #  cas_valid?(key,bytes,flag,timeToLive,value,casToken)

  before(:all) do
    Memdata.create_memdata("casS","3","5","3","val")
    @casToken = Memdata.get_data("casS").casToken.to_s
  end

  context "Successful validation" do

    it "Existent unexpired key and correct parameters" do
      statusCode = cas_valid?("casS","3","1","3","val",@casToken)
      expect(statusCode).to be 0
    end

  end

  context "Not successful validation" do

    context "An esencial field is empty, delpoy error: 'ERROR'" do
        it "key field is empty" do
          statusCode = cas_valid?("","3","0","1","val",@casToken)
          expect(statusCode).to be 6
        end

        it "bytes field is empty" do
          statusCode = cas_valid?("casS","","0","1","val",@casToken)
          expect(statusCode).to be 6
        end

        it "flag field is empty" do
          statusCode = cas_valid?("casS","3","","1","val",@casToken)
          expect(statusCode).to be 6
        end

        it "timeToLive field is empty" do
          statusCode = cas_valid?("casS","3","0","","val",@casToken)
          expect(statusCode).to be 6
        end

        it "casToken field is empty" do
          statusCode = cas_valid?("casS","3","0","1","val","")
          expect(statusCode).to be 6
        end
    end

    context "Bad format, deploy error: 'CLIENT_ERROR:Bad command format'" do

      it "key has spaces between characters" do
        statusCode = cas_valid?("cas S","3","1","3","val",@casToken)
        expect(statusCode).to be 1
      end

      it "bytes has non-digit characters" do
        statusCode = cas_valid?("casS","3AA","1","3","val",@casToken)
        expect(statusCode).to be 1
      end

      it "flag has non-digit characters" do
        statusCode = cas_valid?("casS","3","AA2","1","val",@casToken)
        expect(statusCode).to be 1
      end

      it "timeToLive has non-digit characters" do
        statusCode = cas_valid?("casS","3","0","AA2","val",@casToken)
        expect(statusCode).to be 1
      end
    end

    context "bytes!=value.length, deploy error: 'CLIENT_ERROR:Bad data chunk '" do
      it "bytes<value.length" do
        statusCode = cas_valid?("casS","2","0","3","val",@casToken)
        expect(statusCode).to be 2
      end

      it "bytes>value.length" do
        statusCode = cas_valid?("casS","4","0","3","val",@casToken)
        expect(statusCode).to be 2
      end
    end

    context "CAS requirements not met" do

      it "key does not exist" do
        statusCode = cas_valid?("cas","3","0","3","val",@casToken)
        expect(statusCode).to be 3
      end

      it "key is expired" do
        Memdata.create_memdata("cas","0","1","3","val")
        sleep(1)
        statusCode = cas_valid?("cas","3","0","1","val",@casToken)
        expect(statusCode).to be 3
      end

      it "casToken not correct" do
        statusCode = cas_valid?("casS","3","5","3","val",@casToken+"1")
        expect(statusCode).to be 4
      end

    end

  end
end
