require 'spec_helper'

describe RestBase::Exceptions::CBError do
  describe "Default Construction" do
    it "should use type: Error, code: 400, status: 400 with 'Unkown Error' message" do
      expected_message = "Unkown Error"
      expected_hash = {
        :type => "Error",
        :code => "400",
        :message => expected_message
      }
      
      target = RestBase::Exceptions::CBError.new
      
      expect(target).to_not be_nil
      expect(target.type).to eq("Error")
      expect(target.code).to eq("400")
      expect(target.status).to eq(400)
      expect(target.message).to eq(expected_message)
      expect(target.to_hash).to eq(expected_hash)
    end
  end
  
  describe "Custom Construction" do
    it "should set all the error fields" do
      error_hash = {
        :type => "CustomError",
        :code => "500",
        :status => 500,
        :message => "Test Message"
      }

      expected_hash = {
        :type => error_hash[:type],
        :code => error_hash[:code],
        :message => error_hash[:message]
      }
      
      target = RestBase::Exceptions::CBError.new(error_hash)
      
      expect(target).to_not be_nil
      expect(target.type).to eq(error_hash[:type])
      expect(target.code).to eq(error_hash[:code])
      expect(target.status).to eq(error_hash[:status])
      expect(target.message).to eq(error_hash[:message])
      expect(target.to_hash).to eq(expected_hash)
    end
  end
  
  describe "Comparison" do
    it "should be true for equal objects" do
      target_1 = RestBase::Exceptions::CBError.new    
      target_2 = RestBase::Exceptions::CBError.new
      
      expect(target_1).to eq(target_2)
    end
    
    it "should fail for objects with different types" do
      target_1 = RestBase::Exceptions::CBError.new(:type => "CustomError")
      target_2 = RestBase::Exceptions::CBError.new
      
      expect(target_1).to_not eq(target_2)
    end
    
    it "should fail for objects with different codes" do
      target_1 = RestBase::Exceptions::CBError.new(:code => "500")
      target_2 = RestBase::Exceptions::CBError.new
      
      expect(target_1).to_not eq(target_2)
    end
    
    it "should fail for objects with different statuses" do
      target_1 = RestBase::Exceptions::CBError.new(:status => 500)      
      target_2 = RestBase::Exceptions::CBError.new
      
      expect(target_1).to_not eq(target_2)
    end
    
    it "should fail for objects with different errors" do
      target_1 = RestBase::Exceptions::CBError.new(:message => "Test Message")
      target_2 = RestBase::Exceptions::CBError.new
      
      expect(target_1).to_not eq(target_2)
    end
  end
end