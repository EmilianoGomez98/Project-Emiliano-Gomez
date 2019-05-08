describe Setvalidation do
  include Addvalidation
  include Auxvalidation

  context "Successful validation" do
    #add_valid?(key,bytes,flag,timeToLive,value)
    it "Correct parameters" do
      sleep(1)
      statusCode = add_valid?("addv","3","0","1","val")
      expect(statusCode).to be 0
    end

  end

  context "Not successful validation" do

   context "An esencial field is empty, delpoy error: 'ERROR'" do
       it "key field is empty" do
         statusCode = add_valid?("","3","0","1","val")
         expect(statusCode).to be 6
       end

       it "bytes field is empty" do
         statusCode = add_valid?("addv","","0","1","val")
         expect(statusCode).to be 6
       end

       it "flag field is empty" do
         statusCode = add_valid?("addv","3","","1","val")
         expect(statusCode).to be 6
       end

       it "timeToLive field is empty" do
         statusCode = add_valid?("addv","3","0","","val")
         expect(statusCode).to be 6
       end
   end

   context "Bad format, deploy error: 'CLIENT_ERROR:Bad command format'" do
       it "key has spaces between characters" do
         statusCode = add_valid?("ad dv","3","0","1","val")
         expect(statusCode).to be 1
       end

       it "bytes has non-digit characters" do
         statusCode = add_valid?("addv","AA2","0","1","val")
         expect(statusCode).to be 1
       end

       it "flag has non-digit characters" do
         statusCode = add_valid?("addv","3","AA2","1","val")
         expect(statusCode).to be 1
       end

       it "timeToLive has non-digit characters" do
         statusCode = add_valid?("addv","3","0","AA2","val")
         expect(statusCode).to be 1
       end

   end

   context "bytes!=value.length, deploy error: 'CLIENT_ERROR:Bad data chunk '" do
       it "bytes<value.length" do
         statusCode = add_valid?("addv","2","0","1","val")
         expect(statusCode).to be 2
       end

       it "bytes>value.length" do
         statusCode = add_valid?("addv","4","0","1","val")
         expect(statusCode).to be 2
       end
   end

  end
end
